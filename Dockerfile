FROM golang:1.22.4-alpine as stage1

WORKDIR /journey

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
WORKDIR /journey/cmd/journey
RUN CGO_ENABLED=0 GOOS=linux go build -o /journey/bin/journey .

FROM scratch

COPY --from=stage1 /journey/bin/journey /journey/bin/journey

EXPOSE 8080
ENTRYPOINT [ "/journey/bin/journey" ]