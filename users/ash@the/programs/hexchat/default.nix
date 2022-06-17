{ lib, pkgs, secrets, ... }:

let
  inherit (builtins) filter genList head length tail;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.generators) toKeyValue;
  inherit (lib.lists) foldr zipLists;
  inherit (lib.strings) concatStringsSep;
  optHead = list: if length list == 0 then null else head list;
  optTail = list: if length list == 0 then [] else tail list;
  findIndex = pred: list: let
    found = filter (x: pred x.snd) (zipLists (genList (x: x) (length list)) list);
  in if found == [] then null else (head found).fst;
  loginTypes = {
    default = null;
    sasl = 6;
    saslExternal = 10;
    slashPass = 7;
    msgNickserv = 1;
    slashNickserv = 2;
    challengeAuth = 8; # seems to be quakenet-specific
    custom = 9;
  };
  networkFlags = {
    roundRobin = 1;
    useGlobalUserInfo = 2;
    forceSsl = 4;
    autoconnect = 8;
    bypassProxy = -16;
    allowInvalidSsl = 32;
    favourite = 64;
  };
  mkServlistStanza = name: {
    servers,
    nicks,
    username ? null,
    realname ? null,
    encoding ? "UTF-8 (Unicode)",
    logintype ? "default",
    password ? null,
    commands ? [], # do not prefix with "/"
    channels ? [],
    # Flags
    roundRobin ? true,
    useSsl ? true,
    autoConnect ? false,
    useProxy ? true,
    allowInvalidSsl ? false,
    favourite ? false,
  }: toKeyValue {} { N = name; } + toKeyValue { listsAsDuplicateKeys = true; } {
    I = optHead nicks;
    i = optHead (optTail nicks);
    U = username;
    R = realname;
    P = password;
    L = loginTypes.${logintype};
    E = encoding;
    F = let flag = cond: n: if cond then n else 0; in foldr (x: y: x + y) 0 [
      (flag roundRobin 1)
      (flag (username == null && realname == null && nicks == []) 2)
      (flag useSsl 4)
      (flag autoConnect 8)
      (flag useProxy 16)
      (flag allowInvalidSsl 32)
      (flag favourite 64)
    ];
    D = let index = findIndex (server: server.default) servers; in if index != null then index else 0;
    S = map ({host, port ? null, default ? false, ssl ? true}: "${host}/${if ssl then "+" else ""}${toString (if port != null then port else if ssl then 6697 else 6667)}") servers;
    C = commands;
    J = channels;
  };
in
{
  home.packages = with pkgs; [ hexchat ];
  xdg.configFile."hexchat/servlist.conf".text = concatStringsSep "\n\n" (["v=2.14.3"] ++ mapAttrsToList mkServlistStanza secrets.hexchat.config);
  xdg.configFile."hexchat/hexchat.conf".source = ./hexchat.conf;
  # Stop hexchat.conf being overwritten by HexChat.
  # https://github.com/hexchat/hexchat/blob/90c91d6c9aa048eff8f8f8f888d37a21fd714522/src/common/cfgfiles.c#L1013
  xdg.configFile."hexchat/hexchat.conf.new".text = "";
}
