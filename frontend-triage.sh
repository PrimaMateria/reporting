issues=("DATAINT-2910" "DATAINT-2909" "DATAINT-2911" "DATAINT-2912" "DATAINT-2913" "DATAINT-2914" "DATAINT-2915" "DATAINT-2916" "DATAINT-2917" "DATAINT-2918" "DATAINT-2919" "DATAINT-2920" "DATAINT-2921")

for issue in "${issues[@]}"; do
  jira epic add DATAINT-2984 $issue
done

