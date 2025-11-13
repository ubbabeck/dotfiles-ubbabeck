{ ... }:
{
  security.chromiumSuidSandbox.enable = true;
  security.lockKernelModules = false;
  boot.kernel.sysctl."user.max_user_namespaces" = 63414;
  security.allowUserNamespaces = true;

}
