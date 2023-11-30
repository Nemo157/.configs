{ pkgs-final, pkgs-prev, ... }:
pkgs-final.symlinkJoin {
  inherit (pkgs-prev.freetube) name;
  paths = [
    (pkgs-final.writeShellApplication {
      name = "freetube";
      runtimeInputs = [ pkgs-final.gnused ];
      text = ''
        # https://github.com/NixOS/nixpkgs/issues/256401#issuecomment-1734912230
        # and remove some log spam
        ${pkgs-prev.freetube}/bin/freetube "$@" "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" 2>&1 | sed \
          -e '/Cannot create bo with format= R_8 and usage=SCANOUT_CPU_READ_WRITE/d' \
          -e '/GBM-DRV error (get_bytes_per_component): Unknown or not supported format: 538982482/d'
      '';
    })
    pkgs-prev.freetube
  ];
}
