{
  description = "Reporting utils";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    watson-jira-next.url = "github:PrimaMateria/watson-jira-next/feature/config-custom-path";
  };

  outputs = inputs@{ self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
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

        watsonJiraConfig = pkgs.writeTextFile {
          name = "watson-jira-config.yaml";
          text = ''
            jira:
              server: https://finapi.jira.com/
              cookie: tenant.session.token=eyJraWQiOiJzZXNzaW9uLXNlcnZpY2UvcHJvZC0xNTkyODU4Mzk0IiwiYWxnIjoiUlMyNTYifQ.eyJhc3NvY2lhdGlvbnMiOltdLCJzdWIiOiI1Zjc1YTUxNTk1ZmU4ZTAwNjk1YmI1YzMiLCJlbWFpbERvbWFpbiI6ImZpbmFwaS5pbyIsImltcGVyc29uYXRpb24iOltdLCJjcmVhdGVkIjoxNzAxNjg3MzUzLCJyZWZyZXNoVGltZW91dCI6MTcwMzE2OTE2NCwidmVyaWZpZWQiOnRydWUsImlzcyI6InNlc3Npb24tc2VydmljZSIsInNlc3Npb25JZCI6ImVkZTg2YjhkLWNmODUtNDc0Ni1iNzYzLThlN2RkYzQwNGE0ZiIsInN0ZXBVcHMiOltdLCJvcmdJZCI6IjU1NDEyMDE5LThlMjktNGY0Ny04YzI1LTBhNmY0NjJiYzU5ZiIsImF1ZCI6ImF0bGFzc2lhbiIsIm5iZiI6MTcwMzE2ODU2NCwiZXhwIjoxNzA1NzYwNTY0LCJpYXQiOjE3MDMxNjg1NjQsImVtYWlsIjoibWF0dXMuYmVua29AZmluYXBpLmlvIiwianRpIjoiZWRlODZiOGQtY2Y4NS00NzQ2LWI3NjMtOGU3ZGRjNDA0YTRmIn0.IHL1YlqNg3ckTUbxLpV_IhsgW1290Ow785W3P9e-7Wsl9oFFkgm30EI79pXuruxUwNqwuhkudP_hcWXEOs2hkipsBIu7wRacEeFscimT06CuiT-daT9SBXGXsPmZbt5gOu4tqzPOYh3O6r_tpN8QtIgF07CLh3OctjrT1DIVkpD3OGeZquVGV0BiukaxKmsCqaZrW4XtxAiXayJ1MsrisAItd8ScRRET1NprBeQm7zU-hl5eyPNY9hjyxCSD4IVwiYl6C_6wNAS1IjsYk3eUHp8ezgMaIvJHS0AlwRznD6KzQDnEAagZ-jKjPcn4VzOz146afG_zPX3XFuJwBA_7dw; ajs_anonymous_id=%2293cc60b6-e678-4a9e-99de-40f698326193%22; atlassian.xsrf.token=1c93f13e9aa93b20a2322098f0b5f003857eb17c_lin; JSESSIONID=0AAFE731EA18B84A2BE7E2998CC6C946
            mappings:
              - name: sprint
                type: issue_specified_in_tag
          '';
        };

        overlay = final: prev: {
          jira-cli-go = prev.writeShellApplication {
            name = "jira";
            text = ''
              ${prev.jira-cli-go}/bin/jira -c ${jiraConfig} "$@"
            '';
          };

          watson-jira-next-wrapper = prev.writeShellApplication {
            name = "watson-jira";
            text = ''
              ${inputs.watson-jira-next.defaultPackage.x86_64-linux}/bin/watson-jira-next --config ${watsonJiraConfig} "$@"
            '';
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        devShell = pkgs.mkShell rec {
          packages = [
            pkgs.watson
            pkgs.jira-cli-go
            pkgs.watson-jira-next-wrapper
          ];
          name = "nix.shell.reporting";
          shellHook = ''
            alias @="watson"
            alias @a="$HOME/reporting/watson-add.sh"
            alias @do="$HOME/reporting/watson-add-di-other.sh"
            alias @ds="$HOME/reporting/watson-add-di-sprint.sh"
            alias @wo="$HOME/reporting/watson-add-webform-other.sh"
            alias @ws="$HOME/reporting/watson-add-webform-sprint.sh"
            alias @n="$HOME/reporting/watson-add-none.sh"
            alias @b="$HOME/reporting/watson-add-break.sh"
            alias @="watson"
            
            d () {
              TICKET=$(./jira-list.sh DATAINT | fzf --height 20 | awk '{print $1}')
              $HOME/reporting/watson-add-di-sprint.sh $1 $2 +$TICKET 
            }

            f () {
              TICKET=$(./jira-list.sh FINAPI | fzf --height 20 | awk '{print $1}')
              $HOME/reporting/watson-add-webform-sprint.sh $1 $2 +$TICKET
            }

            b () {
              TICKET=$(./jira-list.sh board | fzf --height 20 | awk '{print $1}')
              if [[ $TICKET == FINAPI* ]]; then
                  $HOME/reporting/watson-add-webform-sprint.sh $1 $2 +$TICKET
              elif [[ $TICKET == ABC* ]]; then
                  $HOME/reporting/watson-add-di-sprint.sh $1 $2 +$TICKET 
              else
                  echo "No matching project for the ticket"
              fi
            }

            watsonstart () {
              PROJECT=$1
              TICKET=$2
              AT=$3
              if [[ -z $AT ]]; then
                watson start $PROJECT +sprint +$TICKET
              else
                watson start $PROJECT +sprint +$TICKET --at $AT
              fi
            }

            sd () {    
              TICKET=$1
              AT=$2
              watsonstart di $TICKET $AT
            }

            sf () {
              TICKET=$1
              AT=$2
              watsonstart webform $TICKET $AT
            }

            sdj () {    
              AT=$1
              TICKET=$(./jira-list.sh DATAINT | fzf --height 20 | awk '{print $1}')
              sd $TICKET $AT
            }
            
            sfj () {
              AT=$1
              TICKET=$(./jira-list.sh FINAPI | fzf --height 20 | awk '{print $1}')
              sf $TICKET $AT
            }

            s () { 
              watson stop
            }

            echo "${name}"
          '';
        };
      }
    );
}
