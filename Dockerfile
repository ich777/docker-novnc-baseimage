FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends xvfb wmctrl x11vnc fluxbox screen novnc libxcomposite-dev && \
	rm -rf /var/lib/apt/lists/*