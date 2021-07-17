# debug.gdb

target extended-remote :3333
set backtrace limit 32
monitor reset halt
load
monitor arm semihosting enable
l main
