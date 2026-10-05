{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) ztIp;
  listenAddr = "[${ztIp "bubi"}]";
in
{
  # Admin login: `clan vars get bubi nextcloud/admin-password`.
  # Only used for the initial install; change it in the web UI afterwards.
  clan.core.vars.generators.nextcloud = {
    files."admin-password" = { };
    runtimeInputs = [ pkgs.xkcdpass ];
    script = ''
      xkcdpass -n 12 -d - | tr -d '\n' > "$out"/admin-password
    '';
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.ubbabeck.com";
    # Pinned so a stateVersion-driven default bump never triggers an
    # unplanned major upgrade; Nextcloud only upgrades one major at a time.
    package = pkgs.nextcloud35;
    https = true;

    # Local PostgreSQL over the unix socket with peer auth: no DB password.
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.clan.core.vars.generators.nextcloud.files."admin-password".path;
    };

    settings = {
      default_phone_region = "NO";
      maintenance_window_start = 1; # 01:00 UTC, background jobs run at night

      # ubbabeck.com mail is hosted at Proton, so submit through their relay
      # instead of running an MTA here; mail sent directly from bubi would
      # fail the domain's SPF/DMARC (p=quarantine).
      mail_smtpmode = "smtp";
      mail_smtphost = "smtp.protonmail.ch";
      mail_smtpport = 465;
      # Implicit TLS; on 587 STARTTLS would only be opportunistic.
      mail_smtpsecure = "ssl";
      mail_smtpauth = true;
      # Proton only accepts the address the SMTP token was issued for,
      # both as login and as sender.
      mail_smtpname = "cloud@ubbabeck.com";
      mail_from_address = "cloud";
      mail_domain = "ubbabeck.com";
    };
    secrets.mail_smtppassword = config.clan.core.vars.generators.nextcloud-smtp.files."token".path;
  };

  # Proton → Settings → IMAP/SMTP → SMTP tokens, issued for cloud@ubbabeck.com.
  clan.core.vars.generators.nextcloud-smtp.prompts.token = {
    description = "Proton SMTP token for cloud@ubbabeck.com";
    type = "hidden";
    persist = true;
  };

  # Locations and root come from services.nextcloud. Same ingress as
  # ubbabeck.com in ./nginx.nix: TLS passthrough from archie with PROXY
  # protocol on 443, reverse-proxied plain HTTP on 80, ZeroTier only.
  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    enableACME = true;
    forceSSL = true;
    listen = [
      {
        addr = listenAddr;
        port = 443;
        ssl = true;
        proxyProtocol = true;
      }
      {
        addr = listenAddr;
        port = 80;
      }
    ];
    extraConfig = ''
      set_real_ip_from ${ztIp "archie"};
      real_ip_header proxy_protocol;
    '';
  };

  # Consistent pg_dump before every borg run; the raw /var/lib/postgresql
  # copy borg also takes is not crash-safe on its own.
  clan.core.postgresql = {
    enable = true;
    # nextcloud's database.createLocally already creates db and user.
    databases.nextcloud = {
      create.enable = false;
      restore.stopOnRestore = [
        "phpfpm-nextcloud"
        "nextcloud-cron"
      ];
    };
  };
}
