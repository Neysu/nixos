{ config, pkgs, inputs, lib, ... }:

{
  hardware = {
  	bluetooth = { 
  	  enable = true; 
	  powerOnBoot = true;
	  settings = {
	  	General = {
		  Experimental = true;
		  #FastConnectable = true;
	    };
	  	Policy = { 
		  AutoEnable = true;
	    };
	  };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel =  { 
	  sysctl = {
        "net.ipv6.conf.all.disable_ipv6" = true;
        "net.ipv6.conf.default.disable_ipv6" = true;
		"vm.max_map_count" = 16777216; # star citizen stuff
		"fs.file-max" = 524288; # same here
      };
	};
  };

  virtualisation.docker.enable = true;

  networking.hosts = {
    "127.0.0.1" = [ "egibeaux.42.fr" ];
  };

  programs = {
    starship.enable = true;
    firefox.enable = true;
    bat.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
	bash = {
		enable = true;
		completion.enable = true;
		shellAliases = {
		  icat = "kitten icat";
		};
	};
    fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";
      shellAbbrs = { 
	  	up = "sudo nixos-rebuild switch --flake ~/.config/flake-nixos";
		nclean = "sudo nix-collect-garbage --delete-older-than 7d";
	  };
      shellAliases = { 
	  	ls = "eza --icons"; 
		icat = "kitten icat";
	  };
    };
    neovim = {
      enable = true;
	  viAlias = true;
	  vimAlias = true;
	  defaultEditor = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default; # to remove on the 25.11
    };
  };

  nix = {
  	settings = { 
  	  experimental-features = [ "nix-command" "flakes" ];
	  substituters = ["https://nix-citizen.cachix.org"];
      trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
      auto-optimise-store = true;
	};
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  time.timeZone = "Europe/Paris";

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

  environment.gnome.excludePackages = with pkgs; [
	gnome-tour
	gnome-user-docs
  ];
  services = {
    xserver = {
      xkb.layout = "us";
    };
    displayManager.gdm.enable = true;
	desktopManager.gnome.enable = true;
	gnome = {
	  core-apps.enable = false;
	  core-developer-tools.enable = false;
	  games.enable = false;
	};
	flatpak = { 
	  enable = true;
	  remotes = [
	  	{ name = "RSILauncher"; location = "https://mactan-sc.github.io/rsilauncher/RSILauncher.flatpakrepo"; }
		{ name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
	  ];
	  packages = [
		{ appId = "io.github.mactan_sc.RSILauncher"; origin = "RSILauncher"; }
		"ch.tlaun.TL"
		"ca.desrt.dconf-editor"
	  ];
	};
  };

  home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;

	users.elliot = 
	  { pkgs, config, ...}:
	  {
		home = {
		  stateVersion = "25.05";

		  packages = with pkgs; [
			gnomeExtensions.dash-to-dock
			gnomeExtensions.blur-my-shell
			gnomeExtensions.search-light
		  ];
		};

		dconf = { 
		  enable = true;
		  settings = {
		    "org/gnome/shell" = {
			  disable-user-extensions = false;
			  enabled-extensions = [
				"blur-my-shell@aunetx"
			    "dash-to-dock@micxgx.gmail.com"
				"search-light@icedman.github.com"
			  ];
		    };
		  	"org/gnome/desktop/input-sources" = {
			  xkb-options = [ "ctrl:nocaps" ];
		    };
			"org/gnome/shell/extensions/dash-to-dock" = {
			  dash-max-icon-size = 44;
			  custom-theme-shrink = true;
			  apply-custom-theme = false;
			  intellihide-mode = "ALL_WINDOWS";
			};
			"org/gnome/shell/extensions/search-light" = {
			  shortcut-search = [ "<Super>r" ];
			  animation-speed = 400.0;
			  border-radius = 2.9726027397260273;
			};
			"org/gnome/desktop/wm/preferences" = {
			  button-layout = "appmenu:minimize,close";
			  resize-with-right-button = true;
			};
			"org/gnome/desktop/applications/terminal" = {
			  exec = "ghostty";
			};
			"org/gnome/shell/keybindings" = {
			 show-screen-recording-ui = [ "<Shift><Super>s" ];
			};
			"org/gnome/mutter" = {
			  experimental-features = [ "scale-monitor-framebuffer" ];
			};
			"org/gnome/desktop/wm/keybindings" = {
			  toggle-fullscreen = ["<Super>"];
			};
		  };
		};
		programs = {
		  ghostty.enable = true;
		  git = {
			enable = true;
			settings = {
			  user = {
				name = "Elliot";
				email = "elliot.gibeaux@proton.me";
			  };
			  core = { 
			    editor = "nvim";
			  };
			};
		  };
		};
	  };
  };

  users.users.elliot = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "elliot";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  nixpkgs.config.allowUnfree = true;

  environment = { 
  	sessionVariables = {
		TERMINAL = "ghostty";
	};
  	systemPackages = with pkgs; [
	  # wine
	  wine
	  wine64
	  winetricks
  
	  # gui apps
      mpv
	  bluez
	  kitty
	  sushi
	  loupe
	  papers
	  feishin
	  bottles
      discord
      firefox
	  showtime
      nautilus
      obs-studio
      qbittorrent
  	  gnome-tweaks
	  gnome-clocks
      protonvpn-gui
	  gnome-calendar
	  signal-desktop
	  gnome-bluetooth
	  gnome-calculator
	  gnome-text-editor
  
	  # compiler and such
	  go
	  zig
      lua
      gcc
      clang
  
	  # languages servers
	  zls
      nixd
	  gopls
      clang-tools
      lua-language-server
	  yaml-language-server
      docker-language-server
  
	  # cli and tui tools
	  fd
      eza
      wget
      btop
	  ripgrep
	  gnumake
	  openssl
      ripunzip
      fastfetch
      wl-clipboard
  	];
  };

  system = { 
  	autoUpgrade = {
      enable = true;
      flake = "~/.config/flake-nixos/";
      dates = "daily";
	};
	stateVersion = "25.05";
  };
}
