{ lib, stdenv, fetchFromGitHub, bash }:

# To make use of this derivation, use
# `programs.zsh.interactiveShellInit = "source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";`

stdenv.mkDerivation rec {
  pname = "zsh-nix-shell";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "zsh-nix-shell";
    rev = "v${version}";
    sha256 = "sha256-719lVo6p55G1tt3+6nMhZ904nyvlq0Q5exb0il36/Aw=";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  installPhase = ''
    install -D nix-shell.plugin.zsh --target-directory=$out/share/zsh-nix-shell
    install -D scripts/* --target-directory=$out/share/zsh-nix-shell/scripts
  '';

  meta = with lib; {
    description = "zsh plugin that lets you use zsh in nix-shell shell";
    homepage = src.meta.homepage;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aw ];
  };
}
