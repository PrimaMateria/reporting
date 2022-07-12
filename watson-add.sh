DIR="$HOME/reporting"

FROM="$1"
TO="$2"
LOG="${@:3}"

FROM_DATE=`$DIR/d "$FROM"`
TO_DATE=`$DIR/d "$TO"`

watson add -f $FROM_DATE -t $TO_DATE $LOG 
