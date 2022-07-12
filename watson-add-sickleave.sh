DIR="$HOME/reporting"

DATE="$1"

watson add -f "$DATE 10:00" -t "$DATE 18:00"  none +sick $LOG 

