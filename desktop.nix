{ config, pkgs, inputs, lib, ...}:

{
  imports = [
	./desktop-hardware-configuration.nix
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-desktop";
    enableIPv6 = false;
  };
}
