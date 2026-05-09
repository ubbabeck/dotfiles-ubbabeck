{ pkgs, ... }:
let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdZQ2HcLiUN5P0+N1r+eaz8j+VuzuQqLuQ8JT86kyP4+yxhFUeHS74JkyLzA9qXZKnw7hrTL30y4uJpZZH1l/xFPwSexY5EN9+6o2WYWkp7qS1pMKa7kadspCpUshvbksbmsxHgEeIPjVA3p70xpBCcT0fA9f/tok5Cnm5SGs3ofyslwv+/mikvKMjwxECigvQDsJvkQ40jcXDG6oyf352HBuRUDwCIP4YphkL81CVlMQ2dUpAHXy3Qf/mRST6dwdjwojElr3gnvcoLl0zgkP49k66z7DFlmmixpyt0VoeApJAliMp1pbSvfi4+afENFZ0NLhFqte4FCjGR3arMy4eqJBv2qp6wUW4ZXFT8wKORNG2UTGe3Pxnxp9GLZznG8tUN+DAUR0fwwdgYGiAP67Ty7KJCx8yV7cu8J5LDkDY814MkOc8qOl0S4tg1gguvhxmkkmShrhu4UhTc7pFPae80XvRW2wnqQPtHHDhgZo4xLJj98dP0VQ2bQ9bR5MJgO9m94TgoZPcxA0LlKSqDyOUCosc2trphecjQQaYkRKWNbPnI6yzanX80ifSpNhAguZ37oMoYos2vM5fnNgRHYovstFifXVjkWzpCFhHJPpC01kDYmgbAz+6KrgWx0P1Mtks9DgMSz6IT7XYwyEuxJIrozzEeXGJjAeDoMiHjLcz5w== cardno:7311486"
  ];
in
{

  users.users = {
    ruben = {
      isNormalUser = true;
      home = "/home/ruben";
      description = "ruben";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "video"
        "kvm"
        "vboxusers"
        "adbusers"
        "wireshark"
      ];
      uid = 1000;
      openssh.authorizedKeys.keys = keys;

      shell = pkgs.zsh;
    };
    root.openssh.authorizedKeys.keys = keys;
  };
  imports = [ ./zsh.nix ];
}
