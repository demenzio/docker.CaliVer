FROM ubuntu
#MAINTAINER xuvin

ARG BUILD_DATE
ARG VERSION

LABEL build_version="${VERSION} Build-date:- ${BUILD_DATE}"  maintainer="xuvin" 

ENV CALIBRE_INSTALLER=https://download.calibre-ebook.com/linux-installer.sh INSTALL_DIR=/opt AUTH_STATUS=enable-auth CONF_DIR=config LIB_DIR=lib
ENV ADD_LIB=/${INSTALL_DIR}/LIB_DIR/Books

WORKDIR "/${INSTALL_DIR}"

RUN echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
    echo "~~~~   Update and Upgrade  ~~~~" && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
	apt-get update && apt-get upgrade -y && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
    echo "~~~~ Install Needed Packages ~~~~" && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
    apt-get install -y wget xdg-utils xz-utils python gcc &&\
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
    echo "~~~~     Install Calibre   ~~~~" && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
	echo "Creating /${INSTALL_DIR}" && \
    wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sh /dev/stdin install_dir=${INSTALL_DIR} && \
    echo "~ ~ ~>Cleaning UP" && \ 
	rm -rf /tmp/* && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
    echo "~~ Creating Folder Structure ~~" && \
	echo "~~~~ ~~~~~~~~~~~~~~~~~~~~~ ~~~~" && \
	echo "~ ~ ~>Creating ${INSTALL_DIR}/${CONF_DIR}" && \
	mkdir -p ${INSTALL_DIR}/${CONF_DIR} && \
	echo "~ ~ ~>Creating ${INSTALL_DIR}/${LIB_DIR}" && \
	mkdir -p ${INSTALL_DIR}/${LIB_DIR}/Books

COPY users.sqlite ${INSTALL_DIR}/${CONF_DIR}
#ADD demo-libry/* ${INSTALL_DIR}/${LIB_DIR}/Books/

VOLUME [ "/${INSTALL_DIR}/${CONF_DIR}", "/${INSTALL_DIR}/${LIB_DIR}" ]

EXPOSE 8080

ENTRYPOINT calibre-server --log ${INSTALL_DIR}/${CONF_DIR}/log.file --${AUTH_STATUS} --userdb ${INSTALL_DIR}/${CONF_DIR}/users.sqlite ${ADD_LIB}

#CMD ["/bin/bash"]