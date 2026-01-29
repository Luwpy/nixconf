{
  lib,
  self,
  ...
}: let
  # Gerador simplificado para o formato do mango (chave=valor)
  toMangoConf = {attrs}: let
    inherit (lib) isList concatMapStringsSep generators;
    mkFields = generators.toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = k: v:
        if isList v
        then concatMapStringsSep "\n" (val: "${k}=${val}") v
        else "${k}=${v}";
    };
  in
    mkFields attrs;
in {
  flake.nixosModules.extra_hjem = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      mkEnableOption
      mkOption
      mkIf
      concatLines
      mapAttrsToList
      getExe
      mkAfter
      ;
    user = config.preferences.user.name;
    cfg = config.home.programs.mango;
  in {
    options.home.programs.mango = {
      enable = mkEnableOption "mango configuration";

      settings = mkOption {
        default = {};
        description = "mango settings (tagrule, monitorrule, etc)";
      };

      extraConfig = mkOption {
        default = "";
        description = "Raw configuration string";
      };

      finalConfig = mkOption {
        default = "";
      };
    };

    config = mkIf cfg.enable {
      home.programs.mango.finalConfig = (toMangoConf {attrs = cfg.settings;}) + "\n" + cfg.extraConfig;

      hjem.users.${user} = {
        # Ajustado para o caminho provável do mango
        files.".config/mango/config".text = cfg.finalConfig;
      };

      # Autostart integrado no settings como exec-once
      home.programs.mango.settings.exec-once = builtins.map (entry:
        if (builtins.typeOf entry) == "string"
        then getExe (pkgs.writeShellScriptBin "autostart" entry)
        else getExe entry)
      config.preferences.autostart;

      home.programs.mango.extraConfig = let
        wrapWriteApplication = text:
          getExe (pkgs.writeShellApplication {
            name = "mango-script";
            text = text;
          });

        # Adaptação para o formato de bind do Mango: SUPER+SHIFT,tecla,comando
        # O Mango usa '+' para unir modificadores e ',' para separar campos
        sanitizeKeyName = keyName: let
          # Remove espaços e garante que o formato seja MOD+MOD,tecla
          parts = lib.splitString " " (lib.toUpper keyName);
          mainKey = lib.last parts;
          mods = lib.flatten (lib.init parts);
          modString = lib.concatStringsSep "+" (builtins.filter (x: x != "+") mods);
        in
          if modString == ""
          then mainKey
          else "${modString},${mainKey}";

        makeMangoBinds = parentKeyName: keyName: keyOptions: let
          finalKeyName = sanitizeKeyName keyName;
        in
          # Nota: mango não possui o conceito de 'submaps' nativo como Hyprland
          # Esta lógica foi simplificada para mapear comandos diretos
          if builtins.hasAttr "exec" keyOptions
          then ''
            bind=${finalKeyName},spawn,${wrapWriteApplication keyOptions.exec}
          ''
          else if builtins.hasAttr "package" keyOptions
          then ''
            bind=${finalKeyName},spawn,${getExe keyOptions.package}
          ''
          else if (builtins.isString keyOptions) # Caso seja um comando interno do Mango
          then ''
            bind=${finalKeyName},${keyOptions}
          ''
          else ""; # Mango não suporta recursão de submaps via config plana facilmente
      in
        mkAfter (
          concatLines (
            mapAttrsToList (makeMangoBinds "root") config.preferences.keymap
          )
        );
    };
  };
}
