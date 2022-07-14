FROM ethcscs/mpich:ub1804_cuda92_mpi314

## Uncomment the following lines if you want to build mpi yourself:
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        wget \
        gfortran \
        zlib1g-dev \
        libopenblas-dev \
&& rm -rf /var/lib/apt/lists/*

# Install MPICH
RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
&& tar xf mpich-3.1.4.tar.gz \
&& cd mpich-3.1.4 \
&& ./configure --enable-fortran --enable-fast=all,O3 --prefix=/usr \
&& make -j$(nproc) \
&& make install \
&& ldconfig

# Install QE 6.8 (pw.x only for now)
# FOR PRODUCTION: PUT ALL IN THE SAME LINE TO AVOID HAVING LAYERS WITH A LOT OF FILES!
RUN wget -q https://gitlab.com/QEF/q-e/-/archive/qe-6.8/q-e-qe-6.8.tar.gz \
&& tar xzf q-e-qe-6.8.tar.gz
RUN cd q-e-qe-6.8 \
&& ./configure
RUN cd q-e-qe-6.8 \
&& make -j6 pw \
&& make install \
&& cd .. && rm -fr q-e-qe-*