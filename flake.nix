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
              cookie: tenant.session.token=eyJraWQiOiJzZXNzaW9uLXNlcnZpY2UvcHJvZC0xNTkyODU4Mzk0IiwiYWxnIjoiUlMyNTYifQ.eyJhc3NvY2lhdGlvbnMiOltdLCJzdWIiOiI1Zjc1YTUxNTk1ZmU4ZTAwNjk1YmI1YzMiLCJlbWFpbERvbWFpbiI6ImZpbmFwaS5pbyIsImltcGVyc29uYXRpb24iOltdLCJjcmVhdGVkIjoxNjc5MzI2OTYxLCJyZWZyZXNoVGltZW91dCI6MTcwMTY4NzAxNCwidmVyaWZpZWQiOnRydWUsImlzcyI6InNlc3Npb24tc2VydmljZSIsInNlc3Npb25JZCI6IjA2M2VkOTdkLWJiMDMtNGRkNy1hZDBiLWYwNzgxMjcxMTM3OCIsInN0ZXBVcHMiOltdLCJhdWQiOiJhdGxhc3NpYW4iLCJuYmYiOjE3MDE2ODY0MTQsImV4cCI6MTcwNDI3ODQxNCwiaWF0IjoxNzAxNjg2NDE0LCJlbWFpbCI6Im1hdHVzLmJlbmtvQGZpbmFwaS5pbyIsImp0aSI6IjA2M2VkOTdkLWJiMDMtNGRkNy1hZDBiLWYwNzgxMjcxMTM3OCJ9.cQDCKLy6go_qs5VZFMJ_TPJjzFoaReG5KX7GkPcWfhNCxOFk4GYBspPwApSUBeR-JHJnxtjqurS_41or9Ep1eLWdf20iBsVyoyIThYTcVeRcY0zW1aQlTwemh3sgOtoSABiA92PbmEzTYqDBQUWg90Yb4PGes5V558N3KZo_jgnNHevoOnItXAiBSVbAtdRR3cfTHV2MWPHNgq1TKf9Ru8BAhwp5bFQrw9pnGCaC4KvIVt-NP_8jHQqn2ox_-Dzeuwoq-i8MZp41m4dgmelD9XeyLYQB_Qf1xwmdIBQwOHojzZ_G5df4ASAvslDJ-Ga8LD5BCzA9RsAuGi-9wn69Iw; ajs_anonymous_id=%2293cc60b6-e678-4a9e-99de-40f698326193%22; atlassian.xsrf.token=20fb7fdb25a35b35140df123345c610191966bfe_lin; JSESSIONID=A8135CB6FEB4A5ADF15112418B2DF6FD; io=oA5lNOD-45hp-bFgAHAF
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
