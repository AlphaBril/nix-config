# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    timeout = 1;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  xdg.portal = {
    enable = true;
  };

  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };
  users.extraGroups.vboxusers.members = [ "alphabril" ];
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
	ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
	Restart = "on-failure";
	RestartSec = 1;
	TimeoutStopsec = 10;
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = false; # use xkbOptions in tty.
  };

  # xdg.portal.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;
  programs.light.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
    "nodejs-14.21.3"
    "electron-13.6.9"
  ];

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  services.xserver = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;

    enable = true;
    layout = "us";
    xkbOptions = "colemak,caps:escape";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pam.services.swaylock.text = ''
    auth include login
  '';
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.alphabril = {
    isNormalUser = true;
    description = "AlphaBril";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MUTTER_ALLOW_HYBRID_GPUS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    EGL_PLATFORM = "wayland";
    GST_VAAPI_ALL_DRIVERS = "1";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gedit
    epiphany
    geary
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}

