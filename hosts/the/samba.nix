{
  services.samba.enable = true;
  services.samba.enableNmbd = false;
  # allow SMBv1 (ugh)
  services.samba.extraConfig = ''
    client min protocol = NT1
  '';
}
