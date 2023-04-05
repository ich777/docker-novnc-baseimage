FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-novnc-baseimage"

ARG NOVNC_V=1.4.0
ARG TURBOVNC_V=3.0.3

COPY novnccheck /usr/bin
RUN chmod 755 /usr/bin/novnccheck

RUN cd /tmp && \
	wget -O /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/v${NOVNC_V}.tar.gz && \
	tar -xvf /tmp/novnc.tar.gz && \
	cd /tmp/noVNC* && \
	sed -i 's/credentials: { password: password } });/credentials: { password: password },\n                           wsProtocols: ["'"binary"'"] });/g' app/ui.js && \
	mkdir -p /usr/share/novnc && \
	cp -r app /usr/share/novnc/ && \
	cp -r core /usr/share/novnc/ && \
	cp -r utils /usr/share/novnc/ && \
	cp -r vendor /usr/share/novnc/ && \
	cp -r vnc.html /usr/share/novnc/ && \
	cp package.json /usr/share/novnc/ && \
	cd /usr/share/novnc/ && \
	chmod -R 755 /usr/share/novnc && \
	rm -rf /tmp/noVNC* /tmp/novnc.tar.gz

RUN apt-get update && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc websockify fluxbox screen libxcomposite-dev libxcursor1 xauth && \
	sed -i '/    document.title =/c\    document.title = "noVNC";' /usr/share/novnc/app/ui.js && \
	rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
	wget -O /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_V}/turbovnc_${TURBOVNC_V}_amd64.deb/download && \
	dpkg -i /tmp/turbovnc.deb && \
	rm -rf /opt/TurboVNC/java /opt/TurboVNC/README.txt && \
	cp -R /opt/TurboVNC/bin/* /bin/ && \
	rm -rf /opt/TurboVNC /tmp/turbovnc.deb && \
	sed -i '/# $enableHTTP = 1;/c\$enableHTTP = 0;' /etc/turbovncserver.conf

ENV CUSTOM_RES_W=640
ENV CUSTOM_RES_H=480

COPY /x11vnc /usr/bin/x11vnc
RUN chmod 751 /usr/bin/x11vnc