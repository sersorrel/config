{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Don't automatically switch to HFP/HSP when something starts recording.
  environment.etc."wireplumber/policy.lua.d/51-bluetooth-policy.lua".text = ''
    bluetooth_policy.policy = {
      ["media-role.use-headset-profile"] = false,
    }
  '';
}
