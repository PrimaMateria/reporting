{
  description = "Reporting utils";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    tomatoc-src = {
      url = "github:gabrielzschmitz/Tomato.C";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, ... }: 
  utils.lib.eachDefaultSystem ( system:
    let 
      overlay = prev: final: {
        tomatoc = prev.stdenv.mkDerivation {
          name = "Tomato.C";
          buildInputs = [ prev.ncurses ];
          makeFlags = [ "PREFIX=$(out)" ];
          src = inputs.tomatoc-src;
        };
      };

      pkgs = import nixpkgs { 
        inherit system;
        overlays = [ overlay ];
      };
    in {
      devShell = pkgs.mkShell rec {
        packages = [ 
          pkgs.watson
          pkgs.jira-cli-go
          pkgs.tomatoc
        ];
        name = "nix.shell.reporting";
        shellHook = ''
          alias @a="$HOME/reporting/watson-add.sh"
          alias @do="$HOME/reporting/watson-add-di-other.sh"
          alias @ds="$HOME/reporting/watson-add-di-sprint.sh"
          alias @wo="$HOME/reporting/watson-add-webform-other.sh"
          alias @ws="$HOME/reporting/watson-add-webform-sprint.sh"
          alias @n="$HOME/reporting/watson-add-none.sh"
          alias @b="$HOME/reporting/watson-add-break.sh"
          alias @="watson"
          
          alias j="./jira-list.sh DATAINT"
          alias jfzf="j | fzf --height 20 | awk '{print \$1}'"


          daily ()
          {
              $HOME/reporting/watson-add-di-other.sh 930 1000 +meeting +daily
          }   

          report () 
          {
              activity=''${4:-code}
              $HOME/reporting/watson-add-di-sprint.sh $1 $2 +$3 +$activity
          }

          buzz () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +buzz
          }

          release () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +release
          }

          reporting () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +reporting
          }

          practice () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +practice
          }

          meeting () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +meeting +$3
          }

          sync () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +sync
          }

          b () 
          {
              $HOME/reporting/watson-add-break.sh $1 $2
          }

          x ()
          {
              TICKET=$(jfzf)
              report $1 $2 $TICKET $3
          }

          finapi() {
              TICKET=$(./jira-list.sh FINAPI | fzf --height 20 | awk '{print $1}')
              activity=''${3:-code}
              $HOME/reporting/watson-add-di-sprint.sh $1 $2 +$TICKET +$activity
          }

          echo "${name}"
        '';
      };
    }
  );
}
