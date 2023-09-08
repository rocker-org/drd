## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM r-base:latest

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rocker-org/drd" \
      org.label-schema.vendor="Rocker Project" \
      maintainer="Dirk Eddelbuettel <edd@debian.org>"

## Needed in case a base package has an interactive question
## (as e.g. base-passwd in Oct 2020)
ENV DEBIAN_FRONTEND noninteractive

## Remain current
RUN apt-get update -qq && apt-get dist-upgrade -y

## From the Build-Depends of the Debian R package, plus subversion
## Check out R-devel
## Build and install according the standard 'recipe' I emailed/posted years ago
## Set Renviron.site to get libs from base R install
## Clean up
## -- all in one command to get a single AUFS layer
RUN apt-get update -qq && \
        apt-get install -y -t unstable --no-install-recommends \
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
                libcairo2-dev/unstable \
                libcurl4-openssl-dev/unstable \
                libfreetype-dev \
                libharfbuzz-dev/unstable \
                libjpeg-dev \
                liblapack-dev \
                liblzma-dev \
                libncurses-dev \
                libpango1.0-dev/unstable \
                libpcre2-dev \
                libpng-dev \
                libreadline-dev \
                libtiff5-dev/unstable \
                libx11-dev \
                libxcb1-dev/unstable \
                libxdmcp-dev/unstable \
                libxt-dev \
                mpack \
                subversion \
                tcl-dev \
                texinfo \
                texlive-base \
                texlive-fonts-recommended \
                texlive-plain-generic \
                texlive-latex-base \
                texlive-latex-recommended \
                tk-dev \
                x11proto-core-dev \
                xauth \
                xdg-utils \
                xfonts-base \
                xvfb \
                zlib1g-dev \
        && cd /tmp \
        && wget https://stat.ethz.ch/R/daily/R-devel.tar.xz \
        && tar xaf R-devel.tar.xz \
        && rm R-devel.tar.xz \
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
                CFLAGS=$(R CMD config CFLAGS) \
                CXXFLAGS=$(R CMD config CXXFLAGS) \
                FFLAGS=$(R CMD config FFLAGS) \
                ./configure --enable-R-shlib \
                        --enable-memory-profiling \
                        --with-blas \
                        --with-lapack \
                        --with-readline \
                        --without-recommended-packages \
                        --program-suffix=dev && \
                cd /tmp/R-devel && \
                make && \
                make install && \
                rm -rf /tmp/R-devel /tmp/downloaded_packages/ /tmp/*.rds \
        && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/site-library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron \
        && echo 'options("repos"="https://cloud.r-project.org")' >> /usr/local/lib/R/etc/Rprofile.site \
        && cd /usr/local/bin \
        && mv R Rdevel \
        && mv Rscript Rscriptdevel \
        && ln -s Rdevel RD \
        && ln -s Rscriptdevel RDscript \
        && rm -f /usr/share/fonts/type1/texlive-fonts-recommended/.uuid \
        && rm -f /usr/share/fonts/type1/.uuid \
        && apt-get purge -qy \
                libblas-dev \
                libbz2-dev  \
                libcairo2-dev \
                libfontconfig-dev \
                libfontconfig1-dev \
                libfreetype-dev \
                libglib2.0-dev \
                libharfbuzz-dev \
                libicu-dev \
                libjpeg-dev \
                liblapack-dev  \
                liblzma-dev \
                libncurses-dev \
                libpango1.0-dev \
                libpcre2-dev \
                libpng-dev \
                libreadline-dev \
                libtiff-dev \
                libtiff5-dev \
                libxft-dev \
                r-base-dev \
                tcl-dev \
                tcl8.6-dev \
                texlive-base \
                texlive-fonts-recommended \
                texlive-plain-generic \
                texlive-latex-base \
                texlive-latex-recommended \
                texlive-plain-generic \
                tk-dev \
                tk8.6-dev \
        && apt-get autoremove -qy \
        && rm -rf /tmp/R-devel

## Copy 'checkbashisms' (as a local copy from devscripts package)
COPY checkbashisms /usr/local/bin

## Launch R-devel by defailt
CMD ["RD"]
