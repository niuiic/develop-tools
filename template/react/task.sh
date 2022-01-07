if [[ $1 == 'projectRun' ]]; then
    pid=$(netstat -nlp | grep :3000 | awk '{print $7}')
    pid=$(echo $pid | grep -E -o '[0-9]+')
    if [[ $pid != '' ]]; then
        kill -9 $pid
    fi
    npm start
elif [[ $1 == 'cleanMem' ]]; then
    pid=$(netstat -nlp | grep :3000 | awk '{print $7}')
    pid=$(echo $pid | grep -E -o '[0-9]+')
    if [[ $pid != '' ]]; then
        kill -9 $pid
    fi
    pkill -f firefox
elif [[ $1 == 'reopenFirefox' ]]; then
    firefox-bin
fi
