{ pkgs, ... }:

{
  home.packages = with pkgs; [ jetbrains.clion jetbrains.rider dotnet-sdk ];
}
