FROM xuvin/s6overlay:ubuntu-v1.22.1.0

ARG BUILD_DATE
ARG VERSION
ARG CALIBRE_INSTALLER=https://download.calibre-ebook.com/linux-installer.sh

LABEL build_version="${VERSION} Build-date:- ${BUILD_DATE}"  maintainer="xuvin" 

ENV INSTALL_DIR=/app AUTH_STATUS=enable-auth CONF_DIR=/config LIB_DIR=lib USERSQL=users.sqlite
ENV ADD_LIB=${CONF_DIR}/${LIB_DIR}/Books
ENV CALIBRE_TEMP_DIR=${CONF_DIR}/calibre/tmpdir CALIBRE_CACHE_DIRECTORY=${CONF_DIR}/calibre/cachedir

WORKDIR /config

RUN echo "**** upgrade system ****" && \
		apt-get update && apt-get upgrade -y && \
	echo "**** install packages ****" && \
    	apt-get install -y libreadline7 wget xdg-utils xz-utils python gcc && \
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
		echo "~ ~ ~>Creating ${CONF_DIR}/calibre/tmpdir" && \
			mkdir -p ${CONF_DIR}/calibre/tmpdir && \
		echo "~ ~ ~>Creating ${CONF_DIR}/calibre/cachedir" && \
			mkdir -p ${CONF_DIR}/calibre/cachedir

RUN	echo "Installing to ${INSTALL_DIR}" && \
    	wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=${INSTALL_DIR} && \
    echo "~ ~ ~>Cleaning UP" && \ 
		rm -rf /tmp/*
	
COPY users.sqlite ${CONF_DIR}/files
#ADD demo-libry/* ${INSTALL_DIR}/${LIB_DIR}/Books/

ADD rootfs /

VOLUME [ "/${CONF_DIR}/files", "/${CONF_DIR}/lib" ]

EXPOSE 8080

ENTRYPOINT ["/init"]

#CMD ["/bin/bash"]