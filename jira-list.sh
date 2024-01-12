if [ "$1" == "DATAINT" ]; then
  jira -p $1 issue list --plain -q"(STATUS!=DONE or (STATUS=DONE and UPDATED > '-1w')) and ASSIGNEE in ('Matus Benko','Viacheslav Bagmut')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers
fi

if [ "$1" == "FINAPI" ]; then
  jira -p $1 issue list --plain -q"(STATUS!=CLOSED or (STATUS=CLOSED and UPDATED > '-1w')) and ASSIGNEE in ('Matus Benko','Viacheslav Bagmut')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers
fi

if [ "$1" == "board" ]; then
  jira issue list --plain -q"labels = frontend_board or 'Epic Link' in (DATAINT-2984, DATAINT-3028, DATAINT-2222) or ('Epic Link' in (FINAPI-10107, DATAINT-2216, DATAINT-2215, DATAINT-2947, FINAPI-12873, FINAPI-3616, DATAINT-3130, DATAINT-3441, FINAPI-13577) and labels = Frontend) or (key in (DATAINT-2984, DATAINT-3028, DATAINT-2222, FINAPI-10107, DATAINT-2216, DATAINT-2215, DATAINT-2947, FINAPI-12873, FINAPI-3616, DATAINT-3130, FINAPI-13577))" --columns 'KEY,SUMMARY,STATUS,ASSIGNEE' --no-headers
fi
