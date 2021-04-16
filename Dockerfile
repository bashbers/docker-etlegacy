FROM debian:stable-slim

LABEL maintainer "Sebastian Danielsson <sebastian.danielsson@protonmail.com>"

RUN apt update && apt install -y \
    p7zip-full \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://www.etlegacy.com/download/file/254 | tar xvz; mv etlegacy-*/ /etlegacy; \
    curl -o temp.exe https://cdn.splashdamage.com/downloads/games/wet/WolfET_2_60b_custom.exe; 7z e temp.exe -oetlegacy/etmain etmain/pak*.pk3; rm temp.exe

RUN useradd -Ms /bin/bash etlegacy; chown -R etlegacy:etlegacy /etlegacy

EXPOSE 27960/UDP

VOLUME ["/etlegacy"]

WORKDIR /etlegacy/etmain

COPY maps/ /etlegacy/etmain/

USER etlegacy

WORKDIR /etlegacy

ENTRYPOINT ["./etlded"]
CMD ["+set", "fs_game", "legacy", "+set", "fs_homepath", "etmain", "+set", "g_protect", "1", "+exec", "etl_server.cfg"]


# RUN curl https://filebase.trackbase.net/et/maps/goldrush_sw_te.zip --output goldrush.zip; unzip goldrush.zip; pwd;
# RUN curl https://filebase.trackbase.net/et/maps/supply.zip --output supply.zip; unzip supply.zip;