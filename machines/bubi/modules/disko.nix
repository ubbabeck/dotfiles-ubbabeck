{
  # facter.json reports UEFI firmware, so systemd-boot on an ESP works.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  disko.devices = {
    # Single QEMU disk (3T); by-id so the path survives device reordering.
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              # Keep the systemd-boot random seed unreadable for non-root.
              mountOptions = [
                "nofail"
                "umask=0077"
              ];
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
          mountpoint = "none";
        };
        options.ashift = "12";
        datasets = {
          "root" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              #keylocation = "file:///tmp/secret.key";
              keylocation = "prompt";
            };
          };
          "root/nixos" = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              mountpoint = "/";
              # nix-store/postgres churn is several 100G/day; long-lived
              # snapshots filled the pool. Keep only frequent+hourly (24h).
              "com.sun:auto-snapshot:daily" = "false";
              "com.sun:auto-snapshot:weekly" = "false";
              "com.sun:auto-snapshot:monthly" = "false";
            };
          };
          "root/home" = {
            type = "zfs_fs";
            options.mountpoint = "/home";
            mountpoint = "/home";
          };
          "root/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options = {
              mountpoint = "/tmp";
              sync = "disabled";
              "com.sun:auto-snapshot" = "false";
            };
          };
          # Own dataset so a full root fs cannot take postgres down
          # (reservation), and 16k records match its page-sized I/O.
          "root/postgres" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/postgresql/18";
            options = {
              mountpoint = "legacy";
              reservation = "60G";
              recordsize = "16k";
              compression = "zstd";
              logbias = "throughput";
            };
          };
          "root/docker" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
        };
      };
    };
  };
}
