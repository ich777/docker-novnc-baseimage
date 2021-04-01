FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

COPY novnccheck /usr/bin
RUN chmod 755 /usr/bin/novnccheck

RUN cd /tmp && \
	wget -O /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz && \
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
	rm -rf /tmp/noVNC*

RUN apt-get update && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc websockify fluxbox screen libxcomposite-dev libxcursor1 && \
	sed -i '/    document.title =/c\    document.title = "noVNC";' /usr/share/novnc/app/ui.js && \
	rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
	wget -O /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/2.2.6/turbovnc_2.2.6_amd64.deb/download && \
	dpkg -i /tmp/turbovnc.deb && \
	rm -rf /opt/TurboVNC/java /opt/TurboVNC/README.txt && \
	cp -R /opt/TurboVNC/* / && \
	rm -rf /opt/TurboVNC

ENV CUSTOM_RES_W=640
ENV CUSTOM_RES_H=480

COPY /x11vnc /usr/bin/x11vnc
RUN chmod 751 /usr/bin/x11vnc