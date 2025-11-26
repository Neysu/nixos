{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	nix-flatpak.url = "github:gmodena/nix-flatpak";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
	
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nix-flatpak, nixpkgs, neovim-nightly-overlay, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
	    ./configuration.nix 
		./laptop.nix
		home-manager.nixosModules.home-manager
		nix-flatpak.nixosModules.nix-flatpak
	  ];
    };
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
	    ./configuration.nix 
		./desktop.nix
		home-manager.nixosModules.home-manager
		nix-flatpak.nixosModules.nix-flatpak
	  ];
    };
  };
}

