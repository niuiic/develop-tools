output(){
    sed -i "s/--> / /g" $1
    sed -i "s/::: / /g" $1
    cat $1
    rm $1
}

if [ $1 == "build" ]; then
    cargo build &>.tmp_log
    output ".tmp_log"
elif [ $1 == "run" ]; then
    cargo run
elif [ $1 == "test" ]; then
    cargo test -- --nocapture &>.tmp_log
    output ".tmp_log"
elif [ $1 == "run-example" ]; then
    cargo run --example $2
elif [ $1 == "build-example" ]; then
    cargo build --example $2 &>.tmp_log
    output ".tmp_log"
elif [ $1 == "concrete-build" ]; then
    cargo build --bin $2 &>.tmp_log
    output ".tmp_log"
elif [ $1 == "concrete-run" ]; then
    cargo run --bin $2
elif [ $1 == "concrete-test" ]; then
    cargo test -- --nocapture --test $2 &>.tmp_log
    output ".tmp_log"
elif [ $1 == "clean" ]; then
    rm -rf target
fi
