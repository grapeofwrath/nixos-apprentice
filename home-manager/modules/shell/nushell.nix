{config,pkgs,lib,...}:
let cfg = config.orion.shell.nushell; in {
  options.orion.shell.nushell = {
    enable = lib.mkEnableOption "Enable nushell";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      phortune
    ];
    programs.nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $carapace_completer # check 'carapace_completer'
            }
          }
        }
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
        )
        def "flake rebuild" [sub: string = switch] {
          sudo nixos-rebuild $sub --flake .
        }
        def "flake update" [] {
          sudo nix flake update
        }
        phortune
      '';
    };
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
