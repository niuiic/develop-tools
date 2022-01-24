if [[ $1 == "projectRun" ]]; then
    proxychains -q yarn android
fi
