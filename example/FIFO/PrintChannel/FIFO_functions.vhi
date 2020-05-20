
Variables:
buffer: T *
fifo_size: unsigned
head: int
reader_notify: class sc_core::sc_event
state: states
tail: int
writer_notify: class sc_core::sc_event

Functions:
read:
out: T &
write:
val: const T &
