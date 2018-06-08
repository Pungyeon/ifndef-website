GOOS=linux
GOARCH=amd64
GOTEST=go test
GOPATH=$(pwd)
MAIN_PATH=./main.go
OUTPUT_DIR=terraform/
OUTPUT_FILE=main

all: build package
build:
	go build -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(MAIN_PATH)
package:
	zip $(OUTPUT_DIR)/function.zip $(OUTPUT_DIR)/$(OUTPUT_FILE)
test:
	$(GOTEST) -v ./...
docker:
	go build -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(MAIN_PATH)
	docker build -t lambda_test .