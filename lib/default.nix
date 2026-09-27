{ lib, self }:
{
  # ZeroTier address of a clan machine in the ubbabeck network, read from
  # the public vars so it is known at eval time on every machine.
  ztIp =
    machine:
    lib.trim (
      self.inputs.clan-core.lib.getPublicValue {
        flake = self;
        generator = "zerotier-ip-${machine}-zerotier-ubbabeck";
        file = "ip";
      }
    );
}
