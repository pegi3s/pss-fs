FROM ubuntu:18.04
LABEL maintainer="hlfernandez"

# PLACE HERE YOUR DEPENDENCIES (SOFTWARE NEEDED BY YOUR PIPELINE)

RUN apt-get update --fix-missing && apt-get -y upgrade
RUN apt-get install -y software-properties-common wget make

# install clustalomega

RUN apt-get install -y g++ libargtable2-dev

RUN wget http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz -O /tmp/clustalomega.tar.gz \
	&& tar zxvf /tmp/clustalomega.tar.gz -C /opt/ && rm /tmp/clustalomega.tar.gz \
	&& cd /opt/clustal-omega-1.2.4/ \
	&& ./configure && make && make install

# install fasttree

RUN apt-get install -y fasttree

# install HYPHY

RUN apt-get install -y libcrypto++-dev libssl-dev openmpi-bin libopenmpi-dev \
                      cmake build-essential unzip

RUN wget https://github.com/veg/hyphy/archive/2.3.14.zip -O /tmp/hyphy-2.3.14.zip && \
    unzip /tmp/hyphy-2.3.14.zip -d /opt/ && \
    rm /tmp/hyphy-2.3.14.zip -f

RUN cd /opt/hyphy-2.3.14/ && \
    cmake . && make HYPHYMP && make install

# install codeML

RUN apt-get install -y gcc \
    && cd /usr/local/ \
    && wget http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz \
    && tar -xzvf paml4.9j.tgz \
    && rm -rf paml4.9j.tgz \
    && cd paml4.9j/src \
    && make \
    && cp baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00 /usr/local/bin/ \
    && cd /usr/local \
    && rm -rf /usr/local/paml4.9j \
    && apt-get remove -y gcc make \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /codeml

# install EMBOSS

RUN apt-get -qq update && apt-get -y upgrade && \
	apt-get install -y emboss=6.6.0+dfsg-6build1

# install translatorX

RUN apt-get -qq update && apt-get -y upgrade && \
	apt-get install -y perl

RUN wget http://evolution6.i3s.up.pt/static/pegi3s/dockerfiles/translatorx/translatorx_vLocal.pl -O /usr/local/bin/translatorx_vLocal.pl && \
	chmod u+x /usr/local/bin/translatorx_vLocal.pl

RUN apt-get update && apt-get install -y bc

# INSTALL COMPI

# Required gettext-base to have envsubst
RUN apt-get -y install gettext-base

ADD image-files/compi.tar.gz /

# COPY PIPELINE RESOURCES

COPY ./resources/scripts/* /opt/Fast_Screen/
COPY ./resources/config /home/config

RUN chmod u+x /opt/Fast_Screen/*

RUN ln -s /opt/Fast_Screen/clean_working_dir /usr/bin/clean_working_dir

# ADD PIPELINE
ADD pipeline.xml /pipeline.xml
ENTRYPOINT ["/compi", "run",  "-p", "/pipeline.xml"]
