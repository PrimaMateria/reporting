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

          cc2 ()
          {
              report $1 $2 DATAINT-2578 $3
          }

          overlay () 
          {
              report $1 $2 DATAINT-2696 $3
          }

          cc ()
          {
              report $1 $2 DATAINT-2687 $3
          }

          polling () 
          {
              report $1 $2 DATAINT-2690 $3
          }

          buzz () 
          {
              $HOME/reporting/watson-add-di-other.sh $1 $2 +buzz
          }

          x ()
          {
              TICKET=$(jira issue list --plain -q"STATUS!=DONE and ASSIGNEE in ('Matus Benko','Vyacheslav')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers | fzf --height 20 | awk '{print $1}')
              report $1 $2 $TICKET $3
          }

          echo "${name}"
        '';
      };
    }
  );
}
