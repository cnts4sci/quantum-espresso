FROM container4hpc/base-mpich314:0.2.1

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        libblas-common \
        libblas-dev \
&& rm -rf /var/lib/apt/lists/*

# Install QE 6.8 (pw.x only for now)
# FOR PRODUCTION: PUT ALL IN THE SAME LINE TO AVOID HAVING LAYERS WITH A LOT OF FILES!
RUN wget -q https://gitlab.com/QEF/q-e/-/archive/qe-6.8/q-e-qe-6.8.tar.gz \
    && tar xzf q-e-qe-6.8.tar.gz
RUN cd q-e-qe-6.8 \
    && ./configure
RUN cd q-e-qe-6.8 \
    && make -j2 pw \
    && make install \
    && cd .. && rm -fr q-e-qe-*