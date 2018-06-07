FROM golang:alpine
WORKDIR /src/app    
COPY main main
ENTRYPOINT ["/src/app/main"]