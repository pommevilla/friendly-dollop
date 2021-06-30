FROM ubuntu:xenial

# set up for installation of R 
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x51716619e084dab9 \
    && echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list \
    && apt-get update

# install R itself
RUN apt-get install -y r-base 

# install other packages needed
RUN apt-get install -y \
    cmake \
    libcurl4-openssl-dev \
    libssh2-1-dev \
    libssl-dev \
    libxml2-dev \
    locales \
    texlive-fonts-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    wget

# install pandoc manually to a known good version
RUN cd /tmp \
    && wget https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb \
    && dpkg -i pandoc-2.5-1-amd64.deb

# install devtools and bookdown
RUN R -e 'options(download.file.method = "wget"); install.packages("devtools", repos = "https://cran.rstudio.com")' 

# install quarto manually to a known good version
RUN cd /tmp \
	&& wget https://github.com/quarto-dev/quarto-cli/releases/download/v0.1.307/quarto-0.1.307-amd64.deb \
	&& dpkg -i quarto-0.1.307-amd64.deb 

# set up LANG for building books; otherwise pandoc writes "C" as the language,
# which confuses kindlegen
RUN locale-gen en_US.utf8
ENV LANG=en_US.utf8

