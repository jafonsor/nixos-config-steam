{ config, pkgs, ...}:

{

  # keep a list of packages at the top so that all pieces of the configuration use the same
  # packages list
  environment.systemPackages = [
    pkgs.mangohud # gamescope
    pkgs.discord

    pkgs.heroic # epic games
  ];

  # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1229444338
  # Attempted fix for making steam using gamescope. not sure if it works
  # and also not sure if this is how it should be done (pkgs instead of nixpkgs).
#   pkgs.config.packageOverrides = pkgs: {
#     steam = pkgs.steam.override {
#       extraPkgs = pkgs: with pkgs; [
#         xorg.libXcursor
#         xorg.libXi
#         xorg.libXinerama
#         xorg.libXScrnSaver
#         libpng
#         libpulseaudio
#         libvorbis
#         stdenv.cc.cc.lib
#         libkrb5
#         keyutils
#       ];
#     };
#   };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # -- gamescope --
   programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam.gamescopeSession.enable = true;
  hardware.xone.enable = true; # support for the xbox controller USB dongle

  # -- gamescope as display manager: disabled for now --
  # boot.kernelPackages = pkgs.linuxPackages; # (this is the default) some amdgpu issues on 6.10
  # programs.gamescope = {
  #   enable = true;
  #   capSysNice = true;
  # };
  # programs.steam.gamescopeSession.enable = true;
  #
  # hardware.xone.enable = true; # support for the xbox controller USB dongle
  # services.getty.autologinUser = "your_user";
  # environment.systemPackages = [ pkgs.mangohud ];
  #
  # ### --- handle ./gs.sh: add the script and find a way to make the path absolute ---
  # environment.loginShellInit = ''
  #   [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
  # '';

  # -- gamemode --
  programs.gamemode.enable = true;

  # -- VR --
  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  #  - enables handtracking. monado fails without it
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
