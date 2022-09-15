{ pkgs, ... }:

let
  some = pkgs.rustPlatform.buildRustPackage {
    pname = "some";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "sersorrel";
      repo = "some.rs";
      rev = "1e24bff9b2b8ef09ea69d82f40a3da6b07dc1d38";
      sha256 = "17z113zka3id1s7p59rq54y2whk9ah3pbnyazhm9x7lzq34d02va";
    };
    cargoSha256 = "0706n3939aqz1h5b3g1ipdni29nsbwyiycna2qhns6dwxj6fm9sk";
    meta = with pkgs.lib; {
      description = "a meta-pager";
      homepage = "https://github.com/sersorrel/some.rs";
    };
  };
in
{
  home.packages = with pkgs; [ some ];
}
