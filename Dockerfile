FROM build-base-image

WORKDIR /qe-build

# Compile Lapack
# TODO: this should be moved to build-machine base image
ARG LAPACK_VERSION="3.10.1"

RUN wget -c -O lapack.tar.gz https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v${LAPACK_VERSION}.tar.gz && \
    mkdir -p lapack && \
    tar xf lapack.tar.gz -C lapack --strip-components=1 && \
    cd lapack && \
    cp INSTALL/make.inc.gfortran make.inc && \
    make lapacklib blaslib && \
    mkdir -p /usr/local/lapack/lib && \
    cp *.a /usr/local/lapack/lib

# Compile QE
ARG QE_VERSION

RUN wget -c -O qe.tar.gz https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VERSION}/q-e-qe-${QE_VERSION}.tar.gz && \
    mkdir -p qe && \
    tar xf qe.tar.gz -C qe --strip-components=1 && \
    cd qe && \
    LAPACK_LIBS=/usr/local/lapack/lib/liblapack.a BLAS_LIBS=/usr/local/lapack/lib/librefblas.a ./configure -enable-static && \
    make -j8 pw ph && \
    make install


# Move binaries to a small image to reduce the size
FROM runtime-base-image

#RUN apt-get update && apt-get install -y \
#    libquadmath0 \
#  && rm -rf /var/lib/apt/lists/* \
#  && apt-get clean all

COPY --from=0 /usr/local/bin/* /usr/local/bin/

