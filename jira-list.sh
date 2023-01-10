jira issue list --plain -q"(STATUS!=DONE or (STATUS=DONE and UPDATED > '-1w')) and ASSIGNEE in ('Matus Benko','Vyacheslav')" --columns "KEY,SUMMARY,STATUS,ASSIGNEE" --no-headers
