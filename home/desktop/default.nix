{ pkgs, ... }: {
  imports = [
    ./alacritty
    ./cursor.nix
    ./darkman.nix
    ./eww
    ./firefox.nix
    ./fonts.nix
    ./hyprland.nix
    ./mpv.nix
    ./portal.nix
    ./rofi.nix
    ./wallpaper
  ];

  home.packages = with pkgs; [
    wl-clipboard
    urlview
  ];

  home.keyboard = {
      layout = "us";
      variant = "dvp";
      options = [ "caps:escape" "compose:ralt" ];
  };

  home.file.".urlview".text = ''
    COMMAND firefox
    WRAP yes
  '';
}
