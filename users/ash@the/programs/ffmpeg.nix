{ pkgs, ... }:

let
  ffmpeg-full = pkgs.ffmpeg-full.override {
    nonfreeLicensing = true;
    fdkaacExtlib = true;
  };
in
{
  home.packages = with pkgs; [ ffmpeg-full ];
}
