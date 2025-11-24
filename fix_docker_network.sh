#!/system/bin/sh
# find the route kernel would use to reach the Internet
LINE="$(ip -o route get 1.1.1.1 2>/dev/null || ip -o route get 8.8.8.8 2>/dev/null)"

GW="$(printf '%s\n' "$LINE" | awk '{for(i=1;i<=NF;i++) if($i=="via") {print $(i+1); exit}}')"
IF="$(printf '%s\n' "$LINE" | awk '{for(i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}')"

# optional: clean duplicate defaults
ip route del default 2>/dev/null

if [ -n "$GW" ]; then
  ip route replace default via "$GW" dev "$IF" metric 100
else
  # point-to-point (no gateway)
  ip route replace default dev "$IF" metric 100
fi

# ensure your rule exists
ip rule add from all lookup main pref 30000 2>/dev/null
