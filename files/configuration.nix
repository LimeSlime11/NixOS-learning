# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  COUNTRY = {
    timeZone      = "Europe/Copenhagen";
    layoutX11     = "dk";
    keyMapConsole = "dk-latin1";
    defaultLocale = "en_DK.UTF-8";
    extraLocale   = "da_DK.UTF-8";  
};
in
{       

    services = {

        # VM clipboard sharing
        spice-vdagentd.enable = true;

        # Enable the X11 windowing system.
        xserver.enable = true;

        # Configure keymap in X11
        xserver.xkb = {
        layout  = COUNTRY.layoutX11; # Resolves to "dk"
        variant = "";
        };

        # Enable the XFCE Desktop Environment.
        xserver.displayManager.lightdm.enable = true;
        xserver.desktopManager.xfce.enable = true;
    };

    # Apps / Packages
    environment.systemPackages = with pkgs; [
        git
        fastfetch
        kdePackages.kate
        #   libreoffice
        #   chromium
        #   ungoogled-chromium
        # these are just examples
    ];

    # Guest / Borger
    users.users."guest" = {
        isNormalUser   = true;
        description    = "Guest";
        hashedPassword = "";
    };

    # Admin account (remember to change password on the device!)
    users.users.admin = {
        isNormalUser    = true;
        description     = "Administrator";
        initialPassword = "admin";
        extraGroups     = [ 
        "wheel"
        "networkmanager"
        ];

        # User-Specific Packages (Hidden from Guest)
        packages = with pkgs; [
        cowsay # important testing tool!
        ];
    };


    # Set your time zone.
    time.timeZone = COUNTRY.timeZone; 

    # Select internationalisation properties.
    i18n.defaultLocale = COUNTRY.defaultLocale;

    i18n.extraLocaleSettings = {
        LC_ADDRESS          = COUNTRY.extraLocale; 
        LC_IDENTIFICATION   = COUNTRY.extraLocale;
        LC_MEASUREMENT      = COUNTRY.extraLocale;
        LC_MONETARY         = COUNTRY.extraLocale;
        LC_NAME             = COUNTRY.extraLocale;
        LC_NUMERIC          = COUNTRY.extraLocale;
        LC_PAPER            = COUNTRY.extraLocale;
        LC_TELEPHONE        = COUNTRY.extraLocale;
        LC_TIME             = COUNTRY.extraLocale;
    };

    # Configure console keymap
    console.keyMap = COUNTRY.keyMapConsole; 


###=> Things I haven't touched <=###

    imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    # Bootloader.
    boot.loader.grub.enable      = true;
    boot.loader.grub.device      = "/dev/vda";

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable      = true;
    services.pipewire = {
        enable            = true;
        alsa.enable       = true;
        alsa.support32Bit = true;
        pulse.enable      = true;
    };

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Stateful tracking release version
    system.stateVersion = "26.05"; 
}
