{ pkgs, ... }:

let
  janus = with pkgs; stdenv.mkDerivation {
    pname = "janus";
    version = "unstable-2022-09-21";
    src = fetchFromGitHub {
      owner = "sersorrel";
      repo = "janus";
      rev = "b39f2e2b60e6492dd66e252f702dd126d16f2add";
      sha256 = "1b04wa0gq7y2sbd1mqpqyzsji80955vrfgfgw2m9idljvr9n74rp";
    };
    nativeBuildInputs = [
      makeWrapper
    ];
    buildInputs = [
      bat
      bintools
      bzip2
      gnutar
      gzip
      p7zip
      poppler_utils
      unzip
      xz
    ];
    installPhase = ''
      install -Dm755 -t $out/bin janus janus-open janus-close
    '';
    postFixup = ''
      wrapProgram $out/bin/janus-open --prefix PATH : ${lib.makeBinPath [
        bat
        bintools
        bzip2
        gnutar
        gzip
        p7zip
        poppler_utils
        unzip
        xz
      ]}
    '';
  };
in
{
  home.packages = with pkgs; [ janus ];
  programs.fish.interactiveShellInit = ''
    janus | source
  '';
}
