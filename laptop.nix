{ config, pkgs, inputs, lib, ...}:

{
  imports = [
	./laptop-hardware-configuration.nix
  ];

  security.rtkit.enable = true;

  hardware = {
    nvidia = {
	  open = true;
  	  prime = {
	    offload = {
	      enable = true;
	      enableOffloadCmd = true;
	    };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
	  };
	};
	firmware = [
	  pkgs.linux-firmware
      pkgs.sof-firmware
    ];
  };

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-laptop";
    enableIPv6 = false;
  };
}
