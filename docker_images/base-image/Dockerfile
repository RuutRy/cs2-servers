FROM steamcmd/steamcmd

ENV STEAMAPPID 730
ENV STEAMAPP cs2
ENV STEAMAPPDIR "${STEAMAPP}-dedicated"

WORKDIR $HOME

RUN dpkg --add-architecture i386 \
            && apt-get update -y \
            && apt-get install -y --no-install-recommends libicu-dev wget busybox \
            && rm -rf /var/lib/apt/lists/*

COPY setup.sh .

RUN mkdir -p ${STEAMAPPDIR}

ENTRYPOINT ["./setup.sh"]