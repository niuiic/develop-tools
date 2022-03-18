templatePath="/home/niuiic/Applications/DevOpt/template"

if (($# < 1)); then
    echo -e "1. \033[35m rust-aarch64-static \033[0m: Set configuration for rust project to use aacrh64 target with static library."
    echo -e "2. \033[35m vue \033[0m: Create a vue project with typescript, less and vite."
    echo -e "3. \033[35m tauri \033[0m: Create a tauri project with vue typescript, less and vite."
    echo -e "4. \033[35m package-with-tauri \033[0m: Package a vue project with tauri."
    echo -e "5. \033[35m stm32 \033[0m: Create a rust stm32 project."
    echo -e "6. \033[35m openocd-connect \033[0m: Connect to develop board with openocd."
    echo -e "7. \033[35m openocd-disconnect \033[0m: Kill openocd."
    echo -e "8. \033[35m fpga \033[0m: Init configuration for FPGA."
    echo -e "9. \033[35m stm8 \033[0m: Create a stm8 project."
    echo -e "10. \033[35m rust \033[0m: Create a normal rust project."
    echo -e "11. \033[35m gd32 \033[0m: Create a rust gd32-riscv project."
    echo -e "12. \033[35m react \033[0m: Create a react project."
    echo -e "13. \033[35m react-native \033[0m: Create a react-native project."
    echo -e "14. \033[35m beego-api \033[0m: Create a beego api project."
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
    echo "Which language will be used, js or ts?"
    read lang
    if [[ $lang == "js" ]]; then
        proxychains -q npx create-react-app $appName --template redux
    elif [[ $lang == "ts" ]]; then
        proxychains -q npx create-react-app $appName --template redux-typescript
    fi
    cd $appName
    cp "$templatePath/react/task.ini" .task.ini
    cp "$templatePath/react/task.sh" .task.sh
    if [[ $lang == "js" ]]; then
        npm install prop-types --save
    fi
    touch .root
    cd ./public
    rm -rf *
    cat >index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>$appName</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF
elif [ $1 == "react-native" ]; then
    echo "What's your app's name?"
    read appName

    # create project
    echo "Choose the template called \`blank (TypeScript)\`."
    proxychains -q expo init $appName
    cd $appName

    # storybook
    echo "Do you want to use storybook? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        proxychains -q npx -p @storybook/cli sb init --type react
    fi

    # redux
    echo "Do you want to use redux? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        # redux-toolkit and middlewares
        proxychains -q yarn add @reduxjs/toolkit react-redux
        proxychains -q yarn add redux-logger @types/redux-logger
        # data persist
        proxychains -q yarn add redux-persist-expo-filesystem
        proxychains -q yarn add redux-persist
    fi

    # axios
    echo "Do you want to use axios? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        proxychains -q yarn add axios
    fi

    # ahooks
    echo "Do you want to use ahooks? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        proxychains -q yarn add ahooks
    fi

    # navigation
    echo "Do you want to use react navigation? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        proxychains -q yarn add @react-navigation/native
        proxychains -q expo install react-native-screens react-native-safe-area-context
        proxychains -q yarn add @react-navigation/native-stack
        proxychains -q yarn add @react-navigation/bottom-tabs
    fi

    # styles
    echo "Do you want to use styled-component? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        proxychains -q yarn add styled-components @types/styled-components @types/styled-components-react-native
    fi

    # additions
    echo "Do you want to add more additions? (Y or N)"
    read option
    if [[ $option == "y" || $option == "Y" ]]; then
        # charts
        proxychains -q yarn add react-native-gifted-chartsreact-native-canvas react-native-webview react-native-text
        proxychains -q yarn add -D react-native-svg-transformer
        proxychains -q expo install expo-linear-gradient react-native-svg

        # styled components
        proxychains -q yarn add react-native-really-awesome-button react-native-textinput-effects

        # icons
        proxychains -q yarn add @native-base/icons

        # keyboard
        proxychains -q yarn add react-native-keyboard-aware-scroll-view
    fi

    # fix dependencies
    proxychains -q expo doctor --fix-dependencies

    # editor configuration
    cp "$templatePath/react_native/task.ini" .task.ini
    cp "$templatePath/react_native/task.sh" .task.sh
    cp "$templatePath/react_native/eslintrc.js" .eslintrc.js
    touch .root

    # project configuration
    cp "$templatePath/react_native/metro.config.js" metro.config.js
    mkdir -p assets/svg
    cp "$templatePath/react_native/declarations.d.ts" assets/svg/declarations.d.ts
    proxychains -q yarn add @expo/metro-config

    # build project structure
    mkdir -p components pages utils/constants utils/types tests reduxs
    echo -e "{\n\t\"name\": \"components\"\n}" >components/package.json
    echo -e "{\n\t\"name\": \"pages\"\n}" >pages/package.json
    echo -e "{\n\t\"name\": \"assets\"\n}" >assets/package.json
    echo -e "{\n\t\"name\": \"utils\"\n}" >utils/package.json
    echo -e "{\n\t\"name\": \"reduxs\"\n}" >reduxs/package.json
    cp "$templatePath/react_native/tsconfig.json" tsconfig.json
    cp "$templatePath/react_native/babel.config.js" babel.config.js
elif [ $1 == "beego-api" ]; then
    echo "What's your project's name?"
    read projectName
    bee api $projectName
    cd $projectName
    go get $projectName
    go get -u all
    go get github.com/go-sql-driver/mysql
    bee generate docs
    cp "$templatePath/beego/task.ini" .task.ini
    touch .root
else
    echo "No such arguments"
fi
