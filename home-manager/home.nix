{ lib, config, pkgs, inputs, ... }:

{
  home.username = "alphabril";
  home.homeDirectory = "/home/alphabril";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.sessionPath = [
    "$HOME/.local/bin"
  ];


  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
      ];
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      signal-desktop = super.signal-desktop.overrideAttrs (old: {
        preFixup = old.preFixup + ''
          gappsWrapperArgs+=(
            --add-flags "--enable-features=UseOzonePlatform"
            --add-flags "--ozone-platform=x11"
            --add-flags "--force-device-scale-factor=2"
          )
        '';
      });
    })
    (self: super: {
      vscode = super.vscode.overrideAttrs (old: {
        preFixup = old.preFixup + ''
          gappsWrapperArgs+=(
            --add-flags "--enable-features=UseOzonePlatform"
            --add-flags "--ozone-platform=x11"
            --add-flags "--force-device-scale-factor=1"
          )
        '';
      });
    })
  ];

  home.packages = with pkgs; [
    ffmpeg
    hyprcursor
    pavucontrol
    ngrok
    btop
    gtk3
    pulseaudioFull
    blueman
    signal-desktop
    vscode
    waybar
    transmission-qt
    gtk-engine-murrine
    (chromium.override {
      enableWideVine = true;
    })
    awscli
    xfce.thunar
    openssl
    gimp
    libreoffice-qt
    spotify
    slack
    jetbrains.datagrip
    discord
    dunst
    rofi-wayland
    swww
    whitesur-icon-theme
    wlogout
    go
    rustup
    pulsemixer
    networkmanagerapplet
    firefox
    killall
    socat
    nerdfonts
    wl-clipboard
    whatsapp-for-linux
    swaylock-effects
    gh
    (mpv.override {
      scripts = [mpvScripts.mpris];
    })
    alacritty
    htop
    bat
    wdisplays
    direnv
    fzf
    jq
    ripgrep
    grim
    slurp
    swappy
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."alacritty".source = ./config/alacritty;
  xdg.configFile."fish".source = ./config/fish;
  xdg.configFile."rofi".source = ./config/rofi;
  xdg.configFile."swaync".source = ./config/swaync;
  xdg.configFile."swaylock".source = ./config/swaylock;
  xdg.configFile."wlogout".source = ./config/wlogout;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."swww".source = ./config/swww;

  programs.git = {
    enable = true;
    userName = "alphabril";
    userEmail = "florian.marie.doucet@gmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "code";
    TERMINAL = "alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
