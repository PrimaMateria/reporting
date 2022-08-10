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

          report () 
          {
              activity=''${4:-code}
              $HOME/reporting/watson-add-di-sprint.sh $1 $2 +$3 +$activity
          }

          cc ()
          {
              report $1 $2 DATAINT-2488 $3
          }

          concept ()
          {
              report $1 $2 DATAINT-2351 $3
          }

          tracking ()
          {
              report $1 $2 DATAINT-2484 $3
          }

          cms () 
          { 
              report $1 $2 DATAINT-2483 $3
          }

          echo "${name}"
        '';
      };
    }
  );
}
