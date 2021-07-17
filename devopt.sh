templatePath="/home/niuiic/Applicants/DevOpt/template"

if (($# < 1)); then
    echo -e "1. \033[35m rust-aarch64-static \033[0m: Set configuration for rust project to use aacrh64 target with static library."
    echo -e "2. \033[35m vue \033[0m: Create a vue project with typescript, less and vite."
    echo -e "3. \033[35m tauri \033[0m: Create a tauri project with vue typescript, less and vite."
    echo -e "4. \033[35m package-with-tauri \033[0m: Package a vue project with tauri."
    echo -e "5. \033[35m stm32-init \033[0m: Set configuration for rust stm32 project."
    echo -e "6. \033[35m openocd-connect \033[0m: Connect to develop board with openocd."
    echo -e "7. \033[35m fpga-init \033[0m: Init configuration for FPGA."
    echo -e "8. \033[35m stm8-init \033[0m: Set configuration for stm8 project."
    echo -e "9. \033[35m rust-new \033[0m: Create a normal rust project."
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
elif [ $1 == "stm32-init" ]; then
    if (($# < 2)); then
        echo "Please input family name of stm32 chip."
        echo "For example : devopt stm32-init f1"
    else
        mkdir .cargo

        while read line; do
            echo -e $line >>Cargo.toml
        done <"$templatePath/stm32/$2_Cargo.toml"

        cp "$templatePath/stm32/$2_memory.x" memory.x
        cp "$templatePath/stm32/debug.gdb" debug.gdb
        cp "$templatePath/stm32/$2_task.ini" .task.ini
        cp "$templatePath/stm32/$2_config" .cargo/config
        cp "$templatePath/rust/tasks.sh" .tasks.sh
        cp "$templatePath/stm32/$2_openocd.cfg" openocd.cfg
        rm src/main.rs
        touch src/main.rs
        proxychains -q cargo build
    fi
elif [ $1 == "openocd-connect" ]; then
    openocd -f openocd.cfg
elif [ $1 == "openocd-disconnect" ]; then
    killall openocd
elif [ $1 == "fpga-init" ]; then
    if [ -d "sim_dir" ]; then
        cd sim_dir
    else
        mkdir sim_dir
        cd sim_dir
    fi
    cp "$templatePath/FPGA/task.ini" .task.ini
    cp "$templatePath/FPGA/tasks.sh" .tasks.sh
    touch .root
elif [ $1 == "stm8-init" ]; then
    echo "Please input the project name."
    read projectName
    mkdir $projectName
    cd $projectName
    cp "$templatePath/stm8/openocd.cfg" openocd.cfg
    cp "$templatePath/stm8/task.ini" .task.ini
    cp "$templatePath/stm8/tasks.sh" .tasks.sh
    cp "$templatePath/stm8/debug.gdb" debug.gdb
    cp "$templatePath/stm8/root_CMakeLists.txt" CMakeLists.txt
    # cp "$templatePath/stm8/clangd" .clangd
    sed -i "s/projectName/$projectName/g" CMakeLists.txt
    touch .root
    mkdir lib
    mkdir inc
    mkdir src
    mkdir build
    cd src
    cp "$templatePath/stm8/sub_CMakeLists.txt" CMakeLists.txt
    touch main.c
elif [ $1 == "rust-new" ]; then
    if (($# > 1)); then
        cargo new $2
        cd $2
        cp "$templatePath/rust/task.ini" .task.ini
        cp "$templatePath/rust/tasks.sh" .tasks.sh
        cat >Cargo.toml <<EOF
[package]
name = "$2"
version = "0.1.0"
edition = "2018"

[workspace]
members = []

[[bin]]
name = "$2"
path = "src/main.rs"

[dependencies]
EOF
        mkdir test
        mkdir examples
    else
        echo "Please input the project name as an argument."
    fi
else
    echo "No such arguments"
fi
