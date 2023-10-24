{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    bacon
    cargo-deny
    cargo-dl
    cargo-expand
    cargo-fuzz
    cargo-hack
    cargo-minimal-versions
    cargo-nextest
    cargo-supply-chain
    cargo-sweep
    cargo-udeps
    cargo-vet
    cargo-watch
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
  ];

  home.file = {
    "${config.binHome}/cargo-rubber".source = ./cargo-rubber;
    "${config.binHome}/cargo-rustdoc-clippy".source = ./cargo-rustdoc-clippy;
    "${config.binHome}/cargo-doc-like-docs.rs".source = ./cargo-doc-like-docs.rs;
  };

  programs.zsh.profileExtra = ''
    export CARGO_HOME="$XDG_RUNTIME_DIR/cargo-home"

    if ! [ -e "$CARGO_HOME" ]
    then
      (
        _link_cargo_dir() {
          base="$1"
          shift
          while [[ $# -gt 0 ]]; do
            mkdir -p "$CARGO_HOME/$(dirname "$1")" "$base/cargo/$(dirname "$1-")"
            ln -st "$CARGO_HOME/$(dirname "$1")" "$base/cargo/$1"
            shift
          done
        }

        _link_cargo_dir "${config.xdg.configHome}" config.toml
        _link_cargo_dir "${config.xdg.dataHome}" credentials.toml
        _link_cargo_dir "${config.xdg.cacheHome}" git/db/ registry/{index,cache}/ target/
        _link_cargo_dir "$XDG_RUNTIME_DIR" git/checkouts/ registry/src/

        chmod -R a-w,a+t $CARGO_HOME
      )
    fi
  '';
}
