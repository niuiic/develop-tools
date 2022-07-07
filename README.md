# develop-tools

Custom develop tools.

## Environment

OS: linux

Editor: neovim

> If you don't use neovim as the editor or you don't have the configuration, you need to modify the script for yourself.

Other tools may be needed:

1. asynctasks.vim & asyncrun.vim (neovim plugins)
2. proxychains-ng

## Usage

Modify `templatePath` defined at the first line of `devtool.sh`, then you can use the tools.

## tools

1.  rust-aarch64-static: Set configuration for rust project to use aacrh64 target with static library.
2.  vue: Create a vue project with typescript, less and vite.
3.  tauri: Create a tauri project.
4.  stm32: Create a rust stm32 project.
5.  openocd-connect: Connect to develop board with openocd.
6.  openocd-disconnect: Kill openocd.
7.  fpga: Init configuration for FPGA.
8.  stm8: Create a stm8 project.
9.  rust: Create a normal rust project.
10. gd32: Create a rust gd32-riscv project.
11. react: Create a react project.
12. react-native: Create a react-native project.
13. beego-api: Create a beego api project.
14. git-commit: Add git commit specification for the project.
