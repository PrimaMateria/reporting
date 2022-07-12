REPORT_DAY=`cat ./reportday`

if [[ -z "$REPORT_DAY" ]]
then
  date -d "$1" '+%FT%T'
else
  date -d "$REPORT_DAY $1" '+%FT%T'
fi

