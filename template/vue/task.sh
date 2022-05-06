if [ $1 == "dev" ]; then
    yarn dev
elif [ $1 == "build" ]; then
    yarn build
elif [ $1 == "preview" ]; then
    yarn preview
elif [ $1 == "newComponent" ]; then
    mkdir -p ./src/$2/$3
    cd ./src/$2/$3
    touch $3.scss
    touch $3.ts
    cat >$3.vue <<EOF
EOF
    cat >index.ts <<EOF
EOF
fi
