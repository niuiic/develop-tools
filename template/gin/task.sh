if [[ $1 == "run" ]]; then
	pkill go
	go run main.go
elif [[ $1 == "exit" ]]; then
	pkill go
fi
