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
      jiraConfig = pkgs.writeTextFile {
        name = "jira-cli-go-config.yml";
        text = ''
          board:
            id: 134
            name: DI Scrum
            type: scrum
          epic:
            name: customfield_11511
            link: customfield_11510
          installation: Cloud
          issue:
            fields:
              custom:
                - name: Publish Release Notes
                  key: customfield_14111
                  schema:
                    datatype: option
                - name: Organisationen
                  key: customfield_14700
                  schema:
                    datatype: array
                    items: sd-customerorganization
                - name: Request participants
                  key: customfield_13810
                  schema:
                    datatype: array
                    items: user
                - name: Epic Link
                  key: customfield_11510
                  schema:
                    datatype: any
                - name: Release Notes
                  key: customfield_14210
                  schema:
                    datatype: string
                - name: Sprint
                  key: customfield_10711
                  schema:
                    datatype: array
                    items: json
                - name: Account
                  key: io.tempo.jira__account
                  schema:
                    datatype: option2
                - name: Product owner
                  key: customfield_12910
                  schema:
                    datatype: user
                - name: Responsible
                  key: customfield_12312
                  schema:
                    datatype: array
                    items: user
                - name: Epic Name
                  key: customfield_11511
                  schema:
                    datatype: string
            types:
              - id: "10000"
                name: Enhancement
                handle: Enhancement
                subtask: false
              - id: "1"
                name: Bug
                handle: Bug
                subtask: false
              - id: "10900"
                name: Development sub-task
                handle: Development sub-task
                subtask: true
              - id: "10101"
                name: Task
                handle: Task
                subtask: false
              - id: "10400"
                name: Sub-task
                handle: Sub-task
                subtask: true
              - id: "10002"
                name: "Responsibility "
                handle: "Responsibility "
                subtask: false
              - id: "10800"
                name: Initiative
                handle: Initiative
                subtask: false
              - id: "6"
                name: Epic
                handle: Epic
                subtask: false
              - id: "11000"
                name: Decision
                handle: Decision
                subtask: false
              - id: "11300"
                name: Maintenance
                handle: Maintenance
                subtask: false
              - id: "11313"
                name: P0
                handle: P0
                subtask: false
          login: matus.benko@finapi.io
          project:
            key: DATAINT
            type: classic
          server: https://finapi.jira.com
          '';
      };

      overlay = final: prev: {
        tomatoc = prev.stdenv.mkDerivation {
          name = "Tomato.C";
          buildInputs = [ prev.ncurses ];
          makeFlags = [ "PREFIX=$(out)" ];
          src = inputs.tomatoc-src;
        };

        jira-cli-go =  prev.writeShellApplication {
          name = "jira";
          text = ''
            ${prev.jira-cli-go}/bin/jira -c ${jiraConfig} "$@"
          '';
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
