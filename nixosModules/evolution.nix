{ pkgs, ... }:
{
  # Evolution stores IMAP/SMTP passwords via libsecret → Secret Service.
  # KWallet (unlocked by ./niri/kwallet-tpm) provides the Secret Service API.
  # EDS is required so Evolution uses persistent credential storage instead
  # of in-memory per-session prompts. dconf holds the account settings and
  # the "remember password" flag.
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  environment.systemPackages = [
    pkgs.evolution
  ];
}
