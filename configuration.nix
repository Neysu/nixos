# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	];

  services = { 
	blueman.enable = true;

	openssh.enable = true;

	displayManager.sddm = { 
	  enable = true;
	  wayland.enable = true;
    };

  	xserver = { 
	  videoDrivers = [ "nvidia" "modesetting" ];
	  xkb = {
        layout = "us";
	   	variant = "";
      };
	};
  };

  hardware = { 
	bluetooth.enable = true;
	graphics.enable = true;
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
  };

  programs = {
  	bat.enable = true;
	starship.enable = true;
	hyprland.enable = true;
  	fish = {
  	  enable = true; 
	  interactiveShellInit = "set fish_greeting";
	  shellAbbrs = {
	    up = "sudo nixos-rebuild switch --flake ~/.config/flake-nixos";
	  };
	  shellAliases = {
	    ls = "eza --icons";
	  };
	};
	neovim = {
	  enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
	};
	waybar.enable = true;
	steam = {
	  enable = true;
	  remotePlay.openFirewall = true;
	  dedicatedServer.openFirewall = true;
	};
	git = {
	  enable = true;
	  config = {
		user = {
	  	  email = "elliot.gibeaux@proton.me";
		  name = "Elliot";
		};
		code.core = "nvim";
	  };
	};
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader =  { 
  	systemd-boot.enable = true; 
  	efi.canTouchEfiVariables = true;
  };

  networking = {
	networkmanager.enable = true;
	hostName = "nixos"; 
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable networking

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.elliot = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "elliot";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable automatic login for the user.
  #services.getty.autologinUser = "elliot";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
	 gcc
	 clang
     kitty
     firefox
     btop
     hyprpaper
	 wget
	 hyprlock
	 discord
	 clang-tools
	 nixd
	 bluez
	 albert
	 fastfetch
	 eza
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
