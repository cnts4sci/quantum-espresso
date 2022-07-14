FROM container4hpc/base-mpich314:0.2.1

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        libblas-common \
        libblas-dev \
        liblapack-dev \
&& rm -rf /var/lib/apt/lists/*

# Install QE 6.8 (pw.x only for now)
# FOR PRODUCTION: PUT ALL IN THE SAME LINE TO AVOID HAVING LAYERS WITH A LOT OF FILES!
RUN wget -q https://gitlab.com/QEF/q-e/-/archive/qe-7.0/q-e-qe-7.0.tar.gz \
    && tar xzf q-e-qe-7.0.tar.gz
RUN cd q-e-qe-7.0 \
    && ./configure
RUN cd q-e-qe-7.0 \
    && make -j2 all \
    && make install \
    && cd .. && rm -fr q-e-qe-*