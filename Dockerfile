FROM debian:11-slim AS build

#COPY eclipse-java-2023-06-R-linux-gtk-x86_64.tar.gz /tmp/eclipse.tar.gz

RUN apt-get update && \
    apt-get install -y wget && \
    wget -nv https://ftp.fau.de/eclipse/technology/epp/downloads/release/2023-06/R/eclipse-java-2023-06-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz && \
    tar -xzf /tmp/eclipse.tar.gz -C /opt --no-same-owner && \
    wget -nv -O /opt/eclipse/lombok.jar https://projectlombok.org/downloads/lombok.jar && \
    rm /tmp/eclipse.tar.gz && \
    useradd -u 1000 -ms /bin/bash eclipse && \
    cat /opt/eclipse/eclipse.ini | sed "/^-vmargs/a -javaagent:lombok.jar" > /opt/eclipse/eclipse.ini.new && \
    mv /opt/eclipse/eclipse.ini.new /opt/eclipse/eclipse.ini && \
    chown -R eclipse:eclipse /opt/eclipse

COPY --chown=eclipse:eclipse entrypoint.sh /opt/eclipse/

#    wget https://eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-03/R/eclipse-java-2022-03-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz && \


FROM debian:11-slim AS main

COPY --from=build /opt/eclipse /opt/eclipse

RUN useradd -u 1000 -ms /bin/bash eclipse && \
    apt-get update && \
    apt-get install -y libswt-gtk-4-jni dbus-x11 libsecret-1-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /home/eclipse/workspace && \
    mkdir /home/eclipse/sources && \
    mkdir /home/eclipse/mvn_repo && \
    chown -R eclipse:eclipse /home/eclipse


ENV HOME=/home/eclipse
ENV ECLIPSE_WORKSPACE=/home/eclipse/workspace
ENV ECLIPSE_SOURCES=/home/eclipse/sources
ENV MAVEN_REPO=/home/eclipse/mvn_repo
ENV ECLIPSE_CONFIG=/home/eclipse/.eclipse

USER eclipse
COPY --chown=eclipse:eclipse settings.xml /home/eclipse/.m2/

VOLUME $ECLIPSE_WORKSPACE
VOLUME $ECLIPSE_SOURCES
VOLUME $MAVEN_REPO

WORKDIR /opt/eclipse

ENTRYPOINT ["/opt/eclipse/entrypoint.sh"]


