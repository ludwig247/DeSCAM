restart -f
#set start [clock seconds]
#puts "Start time was $start seconds"
time{
run -all
}
#set finish [clock seconds]
#puts "End time was $finish seconds"
#set diff [expr ($finish - $start)/60]
#puts "Runtime was $diff minutes"
