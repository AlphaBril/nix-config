{ lib, config, pkgs, inputs, ... }:

{
  home.username = "alphabril";
  home.homeDirectory = "/home/alphabril";
  home.stateVersion = "23.05"; # Please read the comment before changing.
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

  home.packages = with pkgs; [
    chromium
    signal-desktop
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
    rofi
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

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.overrideAttrs (oldAttrs: {
        preFixup = oldAttrs.preFixup + ''
          gappsWrapperArgs+=(
            --add-flags "--enable-features=UseOzonePlatform"
            --add-flags "--ozone-platform=x11"
          )
        ''; # change to wayland when got time
    });
  };

  home.sessionVariables = {
    EDITOR = "code";
    TERMINAL = "alacritty";
    DEFAULT_BROWSER = "chromium-gpu";
  };

  wayland.windowManager.hyprland.extraConfig = ''
    # <===== ENVIRONMENT VARIABLES ====>

    env = GTK_THEME,Adwaita:dark
    env = GDK_BACKEND,wayland,x11
    env = XCURSOR_SIZE,24
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_QPA_PLATFORM,wayland,x11
    env = XDG_SESSION_DESKTOP,Hyprland
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland,x11

    # <==== GENERAL ====>

    general {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      gaps_in = 3
      gaps_out = 8
      border_size = 2
      col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
      col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
      layout = dwindle
    }

    dwindle {
      pseudotile = yes
      preserve_split = yes
      force_split = 2
    }

    master {
      new_is_master = true
    }

    misc {
      focus_on_activate = true
      mouse_move_enables_dpms = true
      animate_manual_resizes = true
      disable_hyprland_logo = true
      disable_splash_rendering = true
    }

    # <==== DECORATION ====>
    
    decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      rounding = 10
      drop_shadow = false
      shadow_range = 0
      shadow_render_power = 0
      col.shadow = rgba(1a1a1aee)
  }

    # <==== INPUTS ====>

    input {
      kb_layout = us
      kb_variant =
      kb_model =
      kb_options =
      kb_rules =
      follow_mouse = 1

      touchpad {
          natural_scroll = no
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      force_no_accel = 1
    }

    gestures {
      workspace_swipe = on
      workspace_swipe_fingers = 3
      workspace_swipe_cancel_ratio = 0.05
    }

    device:epic mouse V1 {
      sensitivity = -0.5
    }

    # <==== ANIMATIONS ====>

    animations {
      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      enabled = yes
      bezier = wind, 0.05, 0.9, 0.1, 1.05
      bezier = winIn, 0.1, 1.1, 0.1, 1.1
      bezier = winOut, 0.3, -0.3, 0, 1
      bezier = liner, 1, 1, 1, 1
      animation = windows, 1, 6, wind, slide
      animation = windowsIn, 1, 6, winIn, slide
      animation = windowsOut, 1, 5, winOut, slide
      animation = windowsMove, 1, 5, wind, slide
      animation = border, 1, 1, liner
      animation = borderangle, 1, 30, liner, loop
      animation = fade, 1, 10, default
      animation = workspaces, 1, 5, wind
  }

    # <===== BINDINGS ====>

    $mod = SUPER
    $mL = mouse:272
    $mR = mouse:273

    bind   = $mod        , C     , killactive
    bind   = $mod SHIFT  , M     , exit
    bind   = $mod        , SPACE , togglefloating
    bind   = $mod SHIFT  , SPACE , pin
    bind   = $mod        , P     , pseudo
    bind   = $mod        , J     , togglesplit
    bind   = $mod        , F     , fullscreen
    bindm  = $mod        , $mL   , movewindow
    bindm  = $mod        , $mR   , resizewindow

    # workspaces
    # binds $mod + [shift +] {i..10} to [move to] workspace {i..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
      x: let
        ws = let
	  c = (x + 1) / 10;
	in
	  builtins.toString (x + 1 - (c * 10));
      in ''
        bind   = $mod        , ${ws} , workspace      , ${toString (x + 1)}
        bind   = $mod SHIFT  , ${ws} , movetoworkspace, ${toString (x + 1)}
      ''
    )
    10)}
    bind   = $mod        , TAB   , workspace      , previous
    bind   = $mod SHIFT  , TAB   , movetoworkspace, previous

    # Resize
    bind   = $mod CONTROL, H     , resizeactive   , -10 0
    bind   = $mod CONTROL, I     , resizeactive   , 10 0
    bind   = $mod CONTROL, E     , resizeactive   , 0 -10
    bind   = $mod CONTROL, N     , resizeactive   , 0 10

    bind   = $mod        , R     , submap         , resize
    submap = resize
    bind   =             , H     , resizeactive   , -10 0
    bind   =             , I     , resizeactive   , 10 0
    bind   =             , E     , resizeactive   , 0 -10
    bind   =             , N     , resizeactive   , 0 10
    bind   =             , Escape, submap         , reset
    bind   = $mod        , R     , submap         , reset
    submap = reset

    # Movements
    bind   = $mod        , H     , movefocus      , l
    bind   = $mod        , I     , movefocus      , r
    bind   = $mod        , E     , movefocus      , u
    bind   = $mod        , N     , movefocus      , d
    bind   = $mod SHIFT  , H     , movewindow     , l
    bind   = $mod SHIFT  , I     , movewindow     , r
    bind   = $mod SHIFT  , E     , movewindow     , u
    bind   = $mod SHIFT  , N     , movewindow     , d

    # Exec
    bind   = $mod        , Return, exec           , alacritty
    bind   = $mod        , T     , exec           , nautilus
    bind   = $mod        , W     , exec           , firefox
    bind   = $mod        , D     , exec           , rofi -show drun
    bind   = $mod SHIFT  , D     , exec           , rofi -show run
    bind   = $mod        , L     , exec           , swaylock
    bind   = $mod_SHIFT  , S     , exec           , grim -g "$(slurp)" - | swappy -f -

    # Hyprland Relative Workspace
    bind   = $mod        , LEFT  , exec           , hyprland-relative-workspace b
    bind   = $mod        , RIGHT , exec           , hyprland-relative-workspace f
    bind = $mod_SHIFT, left, workspace, -1
    bind = $mod_SHIFT, right, workspace, +1

    $xdg = $HOME/.config
    $scripts = $xdg/home-manager/scripts
    $lockscreen = $scripts/lockscreen
    $screenshot = $scripts/screenshot

    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    exec-once = waybar --config $xdg/waybar/config.jsonc
    exec-once = waybar --config $xdg/waybar/window-title.jsonc
    exec-once = nm-applet

    exec-once = sh $scripts/xdg

    exec-once = $xdg/swww/swwwallpaper.sh # start wallpaper daemon
    exec-once = gammastep
    exec-once = slack
    exec-once = chromium
    exec-once = spotify
    exec-once = signal-desktop

    $dropterm = ^(gophrland-alacritty)$
    windowrule = float,$dropterm
    windowrule = workspace special:scratchpads_special_workspace silent,$dropterm
    windowrule = size 75% 60%,$dropterm
    windowrulev2 = dimaround,class:$dropterm

    $pulsemixer = ^(pulsemixer-alacritty)$
    windowrule = float,$pulsemixer
    windowrule = workspace special:scratchpads_special_workspace silent,$pulsemixer
    windowrule = size 75% 60%,$pulsemixer
    windowrulev2 = dimaround,class:$pulsemixer
    windowrulev2 = workspace 4, class:^(chromium-browser)$
    windowrulev2 = workspace 5, class:^(Slack)$
    windowrulev2 = workspace 6, title:^(Spotify Premium)$
    windowrulev2 = workspace 7, title:^(Signal)
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
