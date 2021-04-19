# [Choice] Debian / Ubuntu version: debian-10, debian-9, ubuntu-20.04, ubuntu-18.04
ARG VARIANT=ubuntu-20.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

# Options for setup script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN yes | unminimize 2>&1 \ 
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install any needed packages specified in requirements.txt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
      clang-tidy \
      clang-format \
      openocd \
      ncurses-dev \
      libudev-dev \
      python3 && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# Install the last GCC from ARM
ENV ARM_GCC_VERSION 10-2020-q4-major
ENV ARM_GCC_PATH 10-2020q4
ENV ARCH x86_64
ENV OS linux

ENV ARM_GCC_INSTALL_FOLDER /arm_gcc/gcc-arm-none-eabi-${ARM_GCC_VERSION}
ENV ARM_GCC_FILENAME gcc-arm-none-eabi-${ARM_GCC_VERSION}-${ARCH}-${OS}.tar.bz2
ENV ARM_GCC_BASE_URL https://developer.arm.com/-/media/Files/downloads/gnu-rm
ENV ARM_GCC_URL ${ARM_GCC_BASE_URL}/${ARM_GCC_PATH}/${ARM_GCC_FILENAME}

RUN mkdir /arm_gcc && \
    cd /arm_gcc && \
    wget ${ARM_GCC_URL} -O ${ARM_GCC_FILENAME} && \
    tar xjf ${ARM_GCC_FILENAME} && \
    rm ${ARM_GCC_FILENAME}

ENV PATH="${ARM_GCC_INSTALL_FOLDER}/bin:${PATH}"

# make some useful symlinks that are expected to exist
RUN cd /usr/bin                                                                          && \
    ln -s idle3 idle                                                                     && \
    ln -s pydoc3 pydoc                                                                   && \
    ln -s python3 python                                                                 && \
    ln -s python3-config python-config                                                   && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-addr2line        && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ar               && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-as               && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-c++              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-c++filt          && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-cpp              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-elfedit          && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-g++              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc              && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-10.2.1       && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-ar           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-nm           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-ranlib       && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov             && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov-dump        && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov-tool        && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb              && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-add-index    && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-add-index-py && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-py           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gprof            && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ld               && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ld.bfd           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-lto-dump         && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-nm               && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-objcopy          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-objdump          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ranlib           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-readelf          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-size             && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-strings          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-strip

# This is required to get arm-none-eabi-gdb working
RUN  cd /usr/lib/x86_64-linux-gnu && \
    ln -s libncurses.so.6.2 libncurses.so.5 && \
    ln -s libtinfo.so.6.2 libtinfo.so.5

ENV NODE_VERSION 14.16.1

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    74F12602B6F1C4E913FAA37AD3A89613643B6201 \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.5

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  # smoke test
  && yarn --version
  
  # Install needed packages, yarn, nvm and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG NPM_GLOBAL=/usr/local/share/npm-global
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \ 
    PATH=${NPM_GLOBAL}/bin:${NVM_DIR}/current/bin:${PATH}

RUN if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} \
    && chmod g+s ${NPM_GLOBAL} \
    && npm config -g set prefix ${NPM_GLOBAL} \
    && sudo -u ${USERNAME} npm config -g set prefix ${NPM_GLOBAL} \
    && su ${USERNAME} -c "umask 0002 && npm install -g eslint pxt npm" \
    && npm cache clean --force > /dev/null 2>&1 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /root/.gnupg /tmp/library-scripts
