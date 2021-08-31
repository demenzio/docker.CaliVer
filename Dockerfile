FROM xuvin/s6overlay:debian-latest

ARG BUILD_DATE
ARG VERSION
ARG CALIBRE_INSTALLER=https://download.calibre-ebook.com/linux-installer.sh

LABEL build_version="${VERSION} Build-date:- ${BUILD_DATE}"  maintainer="xuvin" 

ENV INSTALL_DIR=/app AUTH_STATUS=enable-auth CONF_DIR=/config LIB_DIR=lib USERSQL=users.sqlite
ENV ADD_LIB=${CONF_DIR}/${LIB_DIR}/Books
ENV CALIBRE_TEMP_DIR=${CONF_DIR}/calibre/tmpdir CALIBRE_CACHE_DIRECTORY=${CONF_DIR}/calibre/cachedir
#ENV HOME=/config

WORKDIR /config/files

RUN echo "**** upgrade system ****" && \
		apt-get update && apt-get upgrade -y && \
	echo "**** install packages ****" && \
    	apt-get install -y libreadline8 wget xdg-utils xz-utils python gcc && \
	echo "**** clean up ****" && \
        rm -rf /var/lib/apt/lists/* && \
        apt-get autoremove -y && \
        apt-get clean && \
	echo "**** creating directory structure ****" && \
		echo "~ ~ ~>Creating ${INSTALL_DIR}/calibre" && \
			mkdir -p ${INSTALL_DIR}/calibre && \
		echo "~ ~ ~>Creating ${CONF_DIR}/${LIB_DIR}" && \
			mkdir -p ${CONF_DIR}/${LIB_DIR} && \
		echo "~ ~ ~>Creating ${CONF_DIR}/files" && \
			mkdir -p ${CONF_DIR}/files && \
		echo "~ ~ ~>Creating ${CALIBRE_TEMP_DIR}" && \
			mkdir -p ${CALIBRE_TEMP_DIR} && \
		echo "~ ~ ~>Creating ${CALIBRE_CACHE_DIRECTORY}" && \
			mkdir -p ${CALIBRE_CACHE_DIRECTORY}

RUN	echo "Installing to ${INSTALL_DIR}" && \
    	wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=${INSTALL_DIR} && \
    echo "~ ~ ~>Cleaning UP" && \ 
		rm -rf /tmp/*
	
ADD users.sqlite ${CONF_DIR}
#ADD demo-libry/* ${INSTALL_DIR}/${LIB_DIR}/Books/

ADD rootfs /

VOLUME [ "/${CONF_DIR}/files", "/${CONF_DIR}/lib" ]

EXPOSE 8080

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080 || exit 1

ENTRYPOINT ["/init"]

#CMD ["/bin/bash"]
