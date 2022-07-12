{
  description = "Reporting utils";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
  utils.lib.eachDefaultSystem ( system:
    let 
      pkgs = import nixpkgs { 
        inherit system;
      };
    in {
      devShell = pkgs.mkShell rec {
        name = "nix.shell.reporting";
        shellHook = ''
          daily ()
          {
              $HOME/reporting/watson-add-di-other.sh 930 1000 +meeting +daily
          }   

          fwl ()
          {
              $HOME/reporting/watson-add-di-sprint.sh $1 $2 +DATAINT-2366 +code
          }

          echo "${name}"
        '';
      };
    }
  );
}
