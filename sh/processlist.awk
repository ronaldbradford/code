BEGIN {
  FS = "|"
}
/\^+---/ {  }
/\^| Id / { }

/^\| [0-9]/ {
  state=$8
  gsub(/[ \t]+$/,"",state)
  states["All"] += 1
  if (state != "") {
    states[state] += 1
    states["Working"] += 1
  }
}

END {
  for (i in states) {
    print states[i] " " i


  }
}

