FROM letssteam/arm-gcc-none-eabi-toolchain:latest

ENV CLANG_VERSION 19
ENV CLANG_PRIORITY 1

#Install clang
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
    lsb-release \
    wget \
    software-properties-common \
    gnupg && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod u+x llvm.sh && \
    ./llvm.sh ${CLANG_VERSION} && \
    rm -rf ./llvm.sh && \
    apt-get install -y -q \
    clang-tidy-${CLANG_VERSION} \
    clang-format-${CLANG_VERSION} && \
    update-alternatives \
        --install /usr/bin/clang                 clang                 /usr/bin/clang-${CLANG_VERSION} ${CLANG_PRIORITY} \
        --slave   /usr/bin/clang++               clang++               /usr/bin/clang++-${CLANG_VERSION}  \
        --slave   /usr/bin/asan_symbolize        asan_symbolize        /usr/bin/asan_symbolize-${CLANG_VERSION} \
        --slave   /usr/bin/c-index-test          c-index-test          /usr/bin/c-index-test-${CLANG_VERSION} \
        --slave   /usr/bin/clang-check           clang-check           /usr/bin/clang-check-${CLANG_VERSION} \
        --slave   /usr/bin/clang-cl              clang-cl              /usr/bin/clang-cl-${CLANG_VERSION} \
        --slave   /usr/bin/clang-cpp             clang-cpp             /usr/bin/clang-cpp-${CLANG_VERSION} \
        --slave   /usr/bin/clang-format          clang-format          /usr/bin/clang-format-${CLANG_VERSION} \
        --slave   /usr/bin/clang-format-diff     clang-format-diff     /usr/bin/clang-format-diff-${CLANG_VERSION} \
        --slave   /usr/bin/clang-import-test     clang-import-test     /usr/bin/clang-import-test-${CLANG_VERSION} \
        --slave   /usr/bin/clang-include-fixer   clang-include-fixer   /usr/bin/clang-include-fixer-${CLANG_VERSION} \
        --slave   /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-${CLANG_VERSION} \
        --slave   /usr/bin/clang-query           clang-query           /usr/bin/clang-query-${CLANG_VERSION} \
        --slave   /usr/bin/clang-rename          clang-rename          /usr/bin/clang-rename-${CLANG_VERSION} \
        --slave   /usr/bin/clang-reorder-fields  clang-reorder-fields  /usr/bin/clang-reorder-fields-${CLANG_VERSION} \
        --slave   /usr/bin/clang-tidy            clang-tidy            /usr/bin/clang-tidy-${CLANG_VERSION} \
        --slave   /usr/bin/lldb                  lldb                  /usr/bin/lldb-${CLANG_VERSION} \
        --slave   /usr/bin/lldb-server           lldb-server           /usr/bin/lldb-server-${CLANG_VERSION} && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install any needed packages by codal
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
    openocd \
    ncurses-dev \
    libudev-dev \
    ninja-build \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --install /usr/bin/python-config python-config /usr/bin/python3-config 1 && \
    update-alternatives --install /usr/bin/pydoc pydoc /usr/bin/pydoc3 1 && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# Install PyOCD
RUN python3 -mpip install -U pyocd

# Install dependency for chromium headless
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    sudo apt update && \
    sudo apt-get install -y -q \
    libx11-xcb1 \ 
    libxcomposite1 \ 
    libasound2 \ 
    libatk1.0-0 \ 
    libatk-bridge2.0-0 \ 
    libcairo2 \ 
    libcups2 \ 
    libdbus-1-3 \ 
    libexpat1 \ 
    libfontconfig1 \ 
    libgbm1 \ 
    libgcc1 \ 
    libglib2.0-0 \ 
    libgtk-3-0 \ 
    libnspr4 \ 
    libpango-1.0-0 \ 
    libpangocairo-1.0-0 \ 
    libstdc++6 \ 
    libx11-6 \ 
    libx11-xcb1 \ 
    libxcb1 \ 
    libxcomposite1 \ 
    libxcursor1 \ 
    libxdamage1 \ 
    libxext6 \ 
    libxfixes3 \ 
    libxi6 \ 
    libxrandr2 \ 
    libxrender1 \ 
    libxss1 \ 
    libxtst6 && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*
