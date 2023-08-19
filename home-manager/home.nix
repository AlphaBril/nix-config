{ config, pkgs, inputs, ... }:

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
    rofi
    swww
    deno
    lazygit
    whitesur-icon-theme
    wlogout
    go
    rustup
    pulsemixer
    jetbrains.idea-ultimate
    jetbrains.datagrip
    networkmanagerapplet
    _1password
    _1password-gui
    firefox
    killall
    nerdfonts
    wl-clipboard
    whatsapp-for-linux
    swaylock-effects
    libimobiledevice
    ifuse
    gh
    git
    (mpv.override {
      scripts = [mpvScripts.mpris];
    })
    alacritty
    gammastep
    htop
    bat
    gnomeExtensions.appindicator
    wdisplays
    gnomeExtensions.tray-icons-reloaded
    direnv
    fzf
    jq
    ripgrep
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."alacritty".source = ./config/alacritty;
  xdg.configFile."fish".source = ./config/fish;
  xdg.configFile."rofi".source = ./config/rofi;
  xdg.configFile."lvim".source = ./config/lvim;
  xdg.configFile."swaync".source = ./config/swaync;
  xdg.configFile."wlogout".source = ./config/wlogout;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."ideavim".source = ./config/ideavim;

  programs.git = {
    enable = true;
    userName = "alphabril";
    userEmail = "florian.marie.doucet@gmail.com";
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
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

    # <==== MONITORS ====>
    monitor=eDP-1,2560x1440@165,0x0,1

    # <==== GENERAL ====>

    general {
      gaps_in = 10
      gaps_out = 10
      border_size = 1
      col.active_border = rgba(47ffffff) rgba(5cdd96ff) 45deg
      col.inactive_border = rgba(595959aa)

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
      rounding = 10
      # blur = true
      # blur_size = 3
      # blur_passes = 5
      # blur_ignore_opacity = false
      # blur_new_optimizations = true

      dim_special = 0.5
      dim_around = 0.2

      drop_shadow = true
      shadow_range = 4
      shadow_render_power = 3
      # shadow_scale = 1.0
      col.shadow = rgba(ee1a1a1a)
      col.shadow_inactive = rgba(ee1a1a1a)
      shadow_offset = [10 10]
    }

    # <==== INPUTS ====>

    input {
      kb_layout = us
      kb_variant = colemak
      kb_model =
      kb_options = caps:escape
      kb_rules =

      follow_mouse = 1

      touchpad {
        natural_scroll = yes
      }

      natural_scroll = yes
      sensitivity = 0
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
      enabled = yes
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 7, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 7, default
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
    bind   = $mod        , L     , exec           , $lockscreen

    # Hyprland Relative Workspace
    bind   = $mod        , LEFT  , exec           , hyprland-relative-workspace b
    bind   = $mod        , RIGHT , exec           , hyprland-relative-workspace f
    bind   = $mod SHIFT  , LEFT  , exec           , hyprland-relative-workspace b --with-window
    bind   = $mod SHIFT  , RIGHT , exec           , hyprland-relative-workspace f --with-window

    $xdg = $HOME/.config
    $scripts = $xdg/home-manager/scripts
    $lockscreen = $scripts/lockscreen
    $screenshot = $scripts/screenshot

    exec-once = waybar --config $xdg/waybar/config.jsonc
    exec-once = waybar --config $xdg/waybar/window-title.jsonc
    exec-once = nm-applet

    exec-once = sh $scripts/xdg

    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store

    exec-once = swayidle -w timeout 1200 '$lockscreen' timeout 1200 'hyprctl dispatch dpms off'
    exec-once = swww-daemon
    exec-once = bash $xdg/swww/swwwallpaper.sh -n
    exec-once = swaync
    exec-once = gammastep

    exec-once = tuxedo-control-center

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
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
