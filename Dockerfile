## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM rocker/r-base

## That's me
MAINTAINER Dirk Eddelbuettel edd@debian.org

## Remain current
RUN apt-get update -qq && apt-get dist-upgrade -y

## From the Build-Depends of the Debian R package, plus subversion
## Check out R-devel
## Build and install according the standard 'recipe' I emailed/posted years ago
## Set Renviron.site to get libs from base R install
## Clean up
## -- all in one command to get a single AUFS layer
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    bash-completion \
    bison \
    debhelper \
    default-jdk \
    g++ \
    gcc \
    gfortran \
    groff-base \
    libblas-dev \
    libbz2-dev \
    libcairo2-dev \
    libjpeg-dev \
    liblapack-dev \
    liblzma-dev \
    libncurses5-dev \
    libpango1.0-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    libx11-dev \
    libxt-dev \
    mpack \
    subversion \ 
    tcl8.5-dev \
    texinfo \
    texlive-base \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-recommended \
    tk8.5-dev \
    x11proto-core-dev \
    xauth \
    xdg-utils \
    xfonts-base \
    xvfb \
    zlib1g-dev \
&& cd /tmp \
&& svn co http://svn.r-project.org/R/trunk R-devel \
&& cd /tmp/R-devel && \
    R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-pipe -std=gnu99 -Wall -pedantic -O3" \
    CXXFLAGS="-pipe -Wall -pedantic -O3" \
    ./configure --enable-R-shlib \
    		--without-blas \
    		--without-lapack \
    		--without-recommended-packages \
		--program-suffix=dev && \
    cd /tmp/R-devel && \
    make && \
    make install && \
    rm -rf /tmp/R-devel /tmp/downloaded_packages/ /tmp/*.rds \
&& echo "R_LIBS_SITE=\${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" > /usr/local/lib/R/etc/Renviron.site \
&& echo 'options("repos"="http://cran.rstudio.com")' >> /usr/local/lib/R/etc/Rprofile.site \
&& cd /usr/local/bin \
&& mv R Rdevel \
&& mv Rscript Rscriptdevel \
&& dpkg --purge  \
    libblas-dev \
    libbz2-dev  \
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libglib2.0-dev \
    libjpeg-dev \
    liblapack-dev  \
    liblzma-dev \
    libncurses5-dev \
    libpango1.0-dev \
    libpcre3-dev \
    libpng12-dev \
    libreadline-dev \
    libtiff5-dev \
    libxft-dev \
    libxt-dev \
    r-base-dev \
    tcl8.5-dev \
    texlive-base \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-recommended \
    tk8.5-dev \
&& apt-get autoremove -qy
