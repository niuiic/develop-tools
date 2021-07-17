headerDir="/home/niuiic/Applicants/DevOpt/template/stm8/headers"

if [ -d "build" ]; then
    cd build
else
    mkdir build
    cd build
fi

if [ $1 == "build" ]; then
    cmake .. -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=on
    # sed -i "s/\/usr\/bin\/sdcc/\/usr\/lib\/llvm\/12\/bin\/clang/g" ./compile_commands.json
    ninja
    cp ./compile_commands.json ..
elif [ $1 == "run" ]; then
    cmake .. -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=on
    # sed -i "s/\/usr\/bin\/sdcc/\/usr\/lib\/llvm\/12\/bin\/clang/g" ./compile_commands.json
    ninja
    cp ./compile_commands.json ..
    cd ../bin
    stm8-gdb -q -x ../debug.gdb
elif [ $1 == "clean" ]; then
    cd ..
    if [ -d "build" ]; then
        rm -rf build
    fi
    if [ -f "compile_commands.json"]; then
        rm compile_commands.json
    fi
elif [ $1 == "get" ]; then
    cd ..
    ls $headerDir
    echo "Please input the name of the head file."
    read fileName
    result=$(ls $headerDir | grep "^$fileName.h$")
    if [ -n "$result" ]; then
        cp "$headerDir/$fileName.h" ./inc
        echo "Successfully get the head file."
    else
        echo "No such file."
    fi
fi
