sourcefile="demo.sv"
exe="Vdemo"
simfile="sim_main.cpp"
timescale="10ns/10ns"
buildcmd="verilator +1800-2017ext+ --cc $sourcefile --trace"
runcmd="verilator +1800-2017ext+ --cc $sourcefile --trace --exe $simfile --timescale $timescale && make -j $(nproc) -C ./obj_dir -f $exe.mk $exe"

if [ $1 == "run" ]; then
    eval $runcmd &>/dev/null
    cd ./obj_dir
    eval "./$exe"
    if [ -f "$exe.vcd" ]; then
        gtkwave "./$exe.vcd"
    fi
elif [ $1 == "build" ]; then
    eval $runcmd &>.build.log
    sed -i "s/^%[A-z]*-*:*\s*[A-z]*\s*[A-z]*://g" .build.log
    cat .build.log
    rm .build.log
elif [ $1 == "check" ]; then
    eval $buildcmd &>.build.log
    sed -i "s/^%[A-z]*-*:*\s*[A-z]*\s*[A-z]*://g" .build.log
    cat .build.log
    rm .build.log
elif [ $1 == "clean" ]; then
    if [ -d "obj_dir" ]; then
        rm -rf obj_dir
    fi
elif [ $1 == "watch" ]; then
    if [ -f "$exe.vcd" ]; then
        cd ./obj_dir
        gtkwave "./$exe.vcd"
    else
        echo -e "\033[31mNo vcd file exists.\033[0m"
    fi
elif [ $1 == "init" ]; then
    project_path=$(pwd)
    eval $buildcmd
    cat >compile_commands.json <<EOF
[
  {
    "directory": "$project_path",
    "command": "g++ $simfile -I ./obj_dir -I /usr/share/verilator/include -I /usr/share/verilator/include/*",
    "file": "./$simfile"
  }
]
EOF
    cat >$simfile <<EOF
#include "$exe.h"
#include <fstream>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
using namespace std;

// top object pointer
$exe *top = nullptr;
// wave generation pointer
VerilatedVcdC *tfp = nullptr;

// simulation timestamp
vluint64_t main_time = 0;
// upper limit of simulation timestamp
const vluint64_t sim_time = 1024;

int main(int argc, char **argv) {
  // init
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);
  top = new $exe;
  tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("$exe.vcd");

  while (!Verilated::gotFinish() && main_time < sim_time) {
    // simulation time step in
    top->eval();
    // wave output step in
    tfp->dump(main_time);
    main_time += 1;
  }

  // clear sources and exit
  tfp->close();
  delete top;
  delete tfp;
  exit(0);
  return 0;
}
EOF
fi
