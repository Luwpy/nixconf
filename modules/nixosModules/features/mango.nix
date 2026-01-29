{self, ...}: {
  flake.nixosModules.mango = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe mapAttrsToList;

    mod = "SUPER";
    terminal = self.packages.${pkgs.stdenv.hostPlatform.system}.terminal;

    # Helper para converter números de workspace (0-9) para tags (1-10)
    toTagID = n:
      if n == 0
      then "10"
      else toString n;
  in {
    imports = [
    ];
    # Ativa o módulo que definimos no passo anterior
    home.programs.mango.enable = true;

    home.programs.mango.settings = {
      # 1. Configuração de Layouts por Tag (Tagrules)
      tagrule =
        (map (n: "id:${toString n},layout_name:tile") [1 2 3 4 5 6 7])
        ++ ["id:8,layout_name:vertical_scroller" "id:9,layout_name:scroller"];

      # 2. Configuração de Monitores (Monitorrule)
      # Formato Mango: monitorrule=saída,escala,foco,layout,x,y,largura,altura,hz
      monitorrule =
        mapAttrsToList (
          name: m:
            if m.enabled
            then "${name},1,1,scroller,${toString m.x},${toString m.y},${toString m.width},${toString m.height},${toString m.refreshRate}"
            else "" # MangoWC pode não ter um 'disable' direto via config plana, deixamos vazio ou removemos
        )
        config.preferences.monitors;

      # 3. Atalhos de Teclado (Binds)
      bind =
        [
          "${mod},Return,spawn,${getExe terminal}"
          "${mod},Q,killclient"
          "${mod},SHIFT, F, togglefloating"
          "${mod},F,fullscreen"

          # Movimentação de Foco
          "${mod},Left,focusdir,left"
          "${mod},Right,focusdir,right"
          "${mod},Up,focusdir,up"
          "${mod},Down,focusdir,down"

          # Atalhos extras (HJKL)
          "${mod},H,focusdir,l"
          "${mod},L,focusdir,r"
          "${mod},K,focusdir,u"
          "${mod},J,focusdir,d"

          # Troca de janelas (Move window)
          "${mod}+SHIFT,Left,exchange_client,left"
          "${mod}+SHIFT,Right,exchange_client,right"
          "${mod}+SHIFT,Up,exchange_client,up"
          "${mod}+SHIFT,Down,exchange_client,down"

          # Lançador de aplicativos
          "${mod},S,spawn,${getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell} ipc call launcher toggle"
        ]
        # Geração dinâmica para troca de Tags (Workspaces)
        ++ (map (n: "${mod},${toString n},view,${toTagID n}") [1 2 3 4 5 6 7 8 9 0])
        # Geração dinâmica para mover janelas entre Tags
        ++ (map (n: "${mod}+SHIFT,${toString n},tag,${toTagID n}") [1 2 3 4 5 6 7 8 9 0]);
    };

    # Programas de suporte via NixOS
    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard

      swww

      networkmanagerapplet

      rofi
    ];

    # Inicialização automática
    home.programs.mango.extraConfig = ''
      exec-once=swww init
      exec-once=nm-applet --indicator
    '';
  };
}
