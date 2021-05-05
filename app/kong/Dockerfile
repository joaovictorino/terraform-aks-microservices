FROM alpine

RUN apk add httpie

COPY kong.yml /kong.yml

WORKDIR /

ENTRYPOINT http -f POST kong:8001/config config=@kong.yml --ignore-stdin