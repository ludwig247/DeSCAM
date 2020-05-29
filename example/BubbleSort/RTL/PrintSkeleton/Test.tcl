set start [clock seconds];
run -all
set finish [clock seconds];
puts [expr {$finish - $start}]