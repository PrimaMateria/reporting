#!/usr/bin/awk -f

BEGIN {
  FS=","
  OFS=" "
  fp=0
  di=0
}

{
  if($4 == "" && $3 == "di") di=$5
  if($4 == "" && $3 == "fraudpool") fp=$5
}

END {
  total=di+fp
  pdi=(di/total)*100
  pfp=(fp/total)*100
  print "di: " pdi  "%"
  print "fraudpool: " pfp "%"
}
