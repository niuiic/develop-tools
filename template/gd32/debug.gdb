# debug.gdb

set history save on
set confirm off
target extended-remote :3333
set print asm-demangle on
monitor reset halt
load
l main
