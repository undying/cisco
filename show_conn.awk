
###
# run on your Cisco ASA: show conn all | redir tftp://<tftp_addr>/show_conn_all.txt
# and then you can parse the output: awk -f show_conn.awk show_conn_all.txt
###

function print_array_n(array, top, header){
  printf("%28s\n", header)

  i = 0
  for(key in array){
    printf("%28s  %8s\n", key, array[key])
    if(i++ > top)
      break
  }

  print "\n"
}


BEGIN {
  PROCINFO["sorted_in"] = "@val_type_desc"
  TOP = 20
}

NR > 2 {
  PROTO[$1]++;

  split($3, source, ":");
  SOURCE[source[1]]++;

  split($5, dest, ":");
  DEST[dest[1]]++;

  source_dest = source[1]" "dest[1]
  PAIRS[source_dest]++
  BYTES[source_dest] += $9
}

END {
  print_array_n(PROTO, 2, "TOP By Proto:");

  print_array_n(PAIRS, TOP, "Top Source-Destination IP Pairs:")

  print_array_n(SOURCE, TOP, "Top Source IP:")

  print_array_n(DEST, TOP, "Top Destination IP:")

  print_array_n(BYTES, TOP, "Top Connections by Bytes:")
}


