FROM golang:alpine
WORKDIR /src/app    
COPY bin/main main
ENTRYPOINT ["/src/app/main"]