FROM letssteam/arm-gcc-none-eabi-toolchain:latest

# Install any needed packages by codal
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
    clang-tidy \
    clang-format \
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
