if [ "$1" == "DATAINT" ]; then
  jira -p $1 issue list --plain -q"(STATUS!=DONE or (STATUS=DONE and UPDATED > '-1w')) and ASSIGNEE in ('Matus Benko','Vyacheslav Bagmut')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers
fi

if [ "$1" == "FINAPI" ]; then
  jira -p $1 issue list --plain -q"(STATUS!=CLOSED or (STATUS=CLOSED and UPDATED > '-1w')) and ASSIGNEE in ('Matus Benko','Vyacheslav Bagmut')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers
fi
