templatePath="/home/niuiic/Applications/DevOpt/template"

if (($# < 1)); then
    echo -e "1. \033[35m rust-aarch64-static \033[0m: Set configuration for rust project to use aacrh64 target with static library."
    echo -e "2. \033[35m vue \033[0m: Create a vue project with typescript, less and vite."
    echo -e "3. \033[35m tauri \033[0m: Create a tauri project with vue typescript, less and vite."
    echo -e "4. \033[35m package-with-tauri \033[0m: Package a vue project with tauri."
    echo -e "5. \033[35m stm32 \033[0m: Create a rust stm32 project."
    echo -e "6. \033[35m openocd-connect \033[0m: Connect to develop board with openocd."
    echo -e "7. \033[35m fpga-init \033[0m: Init configuration for FPGA."
    echo -e "8. \033[35m stm8 \033[0m: Create a stm8 project."
    echo -e "9. \033[35m rust \033[0m: Create a normal rust project."
    echo -e "10. \033[35m gd32 \033[0m: Create a rust gd32-riscv project."
    exit 0
fi

if [ $1 == "rust-aarch64-static" ]; then
    mkdir .cargo
    cp "$scriptPath/rust/rust-aarch64-static-config" .cargo/config
elif [ $1 == "vue" ]; then
    echo "What's your app's name?"
    read appName
    proxychains -q yarn create @vitejs/app $appName --template vue-ts
    cd $appName
    proxychains -q yarn set version berry
    # proxychains -q yarn set version from sources
    cp "$templatePath/vue/yarnrc.yml" .yarnrc.yml
    yarn install
    yarn add less -D
    yarn add eslint eslint-plugin-vue -D
    yarn add @vuedx/typescript-plugin-vue -D
    cp "$templatePath/vue/task.ini" .task.ini
    touch .root
    rm ./tsconfig.json
    cp "$templatePath/vue/tsconfig.json" tsconfig.json
    rm src/shims-vue.d.ts
    rm vite.config.ts
    cp "$templatePath/vue/vite.config.ts" vite.config.ts
elif [ $1 == "tauri" ]; then
    echo "What's your app's name?"
    read appName
    proxychains -q yarn create @vitejs/app $appName --template vue-ts
    cd $appName
    proxychains -q yarn set version berry
    # proxychains -q yarn set version from sources
    cp "$templatePath/tauri/yarnrc.yml" .yarnrc.yml
    yarn install
    yarn add less -D
    yarn add eslint eslint-plugin-vue -D
    yarn add @vuedx/typescript-plugin-vue -D
    cp "$templatePath/tauri/task.ini" .task.ini
    touch .root
    rm ./tsconfig.json
    cp "$templatePath/tauri/tsconfig.json" tsconfig.json
    rm src/shims-vue.d.ts
    rm vite.config.ts
    cp "$templatePath/tauri/vite.config.ts" vite.config.ts
    cp "$templatePath/tauri/tauri-plugin.ts" tauri-plugin.ts
    yarn add tauri @types/sharp
    yarn add @rollup/plugin-replace -D
    yarn tauri init
elif [ $1 == "package-with-tauri" ]; then
    rm .task.ini
    cp "$templatePath/tauri/task.ini" .task.ini
    rm ./tsconfig.json
    cp "$templatePath/tauri/tsconfig.json" tsconfig.json
    rm vite.config.ts
    cp "$templatePath/tauri/vite.config.ts" vite.config.ts
    cp "$templatePath/tauri/tauri-plugin.ts" tauri-plugin.ts
    yarn add tauri @types/sharp
    yarn add @rollup/plugin-replace -D
    yarn tauri init
elif [ $1 == "stm32" ]; then
    echo "Please input the project name."
    read projectName
    echo "Please input the of family name of the stm32 chip."
    read chipName
    cargo new $projectName
    cd $projectName
    mkdir .cargo
    while read line; do
        echo -e $line >>Cargo.toml
    done <"$templatePath/stm32/$chipName""_Cargo.toml"
    touch .root
    cp "$templatePath/stm32/$chipName""_memory.x" memory.x
    cp "$templatePath/stm32/debug.gdb" debug.gdb
    cp "$templatePath/stm32/$chipName""_task.ini" .task.ini
    cp "$templatePath/stm32/$chipName""_config" .cargo/config
    cp "$templatePath/rust/tasks.sh" .tasks.sh
    cp "$templatePath/stm32/$chipName""_openocd.cfg" openocd.cfg
    rm src/main.rs
    touch src/main.rs
    proxychains -q cargo build
elif [ $1 == "openocd-connect" ]; then
    openocd -f openocd.cfg
elif [ $1 == "openocd-disconnect" ]; then
    killall openocd
elif [ $1 == "fpga" ]; then
    if [ -d "sim_dir" ]; then
        cd sim_dir
    else
        mkdir sim_dir
        cd sim_dir
    fi
    cp "$templatePath/FPGA/task.ini" .task.ini
    cp "$templatePath/FPGA/tasks.sh" .tasks.sh
    touch .root
elif [ $1 == "stm8" ]; then
    echo "Please input the project name."
    read projectName
    mkdir $projectName
    cd $projectName
    cp "$templatePath/stm8/openocd.cfg" openocd.cfg
    cp "$templatePath/stm8/task.ini" .task.ini
    cp "$templatePath/stm8/tasks.sh" .tasks.sh
    cp "$templatePath/stm8/debug.gdb" debug.gdb
    cp "$templatePath/stm8/root_CMakeLists.txt" CMakeLists.txt
    sed -i "s/projectName/$projectName/g" CMakeLists.txt
    touch .root
    mkdir lib
    mkdir inc
    mkdir src
    mkdir build
    cd src
    cp "$templatePath/stm8/sub_CMakeLists.txt" CMakeLists.txt
    touch main.c
elif [ $1 == "rust" ]; then
    echo "Please input the project name."
    read projectName
    cargo new $projectName
    cd $projectName
    cp "$templatePath/rust/task.ini" .task.ini
    touch .root
    cp "$templatePath/rust/tasks.sh" .tasks.sh
    cp "$templatePath/rust/vimspector.json" .vimspector.json
    sed -i "s/program_target/$projectName/g" .vimspector.json
    cat >Cargo.toml <<EOF
[package]
name = "$projectName"
version = "0.1.0"
edition = "2018"

[workspace]
members = []

[[bin]]
name = "$projectName"
path = "src/main.rs"

[dependencies]
EOF
    mkdir tests
    mkdir examples
elif [ $1 == "gd32" ]; then
    cp "$templatePath/gd32/openocd.cfg" .
    cp "$templatePath/gd32/debug.gdb" .
    mkdir .cargo
    touch .root
    cp "$templatePath/gd32/config" ./.cargo
elif [ $1 == "react" ]; then
    echo "What's your app's name?"
    read appName
    proxychains -q create-react-app $appName
    cd $appName
    cp "$templatePath/react/task.ini" .task.ini
    cp "$templatePath/react/task.sh" .task.sh
    rm ./src/*
    cp "$templatePath/react/App.js" ./src
    cp "$templatePath/react/index.js" ./src
    touch .root
elif [ $1 == "react-native" ]; then
    echo "What's your app's name?"
    read appName
    proxychains -q react-native init $appName
    cd $appName
    cp "$templatePath/react_native/task.ini" .task.ini
    cp "$templatePath/react_native/task.sh" .task.sh
    touch .root
else
    echo "No such arguments"
fi
