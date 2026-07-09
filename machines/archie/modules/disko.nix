{
  # Contabo VPS firmware is legacy SeaBIOS (i440FX), not UEFI, so boot via GRUB
  # on the disk's MBR gap instead of systemd-boot on an ESP. GRUB's BIOS build
  # cannot read a ZFS /boot ("unknown filesystem"), so /boot is plain ext4.
  # disko derives boot.loader.grub.devices from the EF02 partition below.
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # GRUB core.img for BIOS boot on a GPT disk lives here (no filesystem).
          boot = {
            size = "1M";
            type = "EF02";
          };
          # Kernel/initrd on ext4 so GRUB's i386-pc build can read them.
          bootfs = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
              mountOptions = [ "nofail" ];
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
    zpool.zroot = {
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
          options.mountpoint = "/";
          mountpoint = "/";
        };
        "home" = {
          type = "zfs_fs";
          options.mountpoint = "/home";
          mountpoint = "/home";
        };
        "tmp" = {
          type = "zfs_fs";
          mountpoint = "/tmp";
          options = {
            mountpoint = "/tmp";
            sync = "disabled";
          };
        };
      };
    };
  };
}
