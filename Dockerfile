FROM openmpi-builder-image AS openmpi-builder
FROM lapack-builder-image AS lapack-builder

# As build-machine image, it is not actually a runtime
# but I do the runtime multi-stage build to minimize the size
# and for testing the integrity of the openmpi/lapack... static build and move
FROM build-base-image AS qe-builder

WORKDIR /qe-build

# Copy build toolchains from the builder stage
COPY --from=openmpi-builder /opt/openmpi /opt/openmpi
COPY --from=lapack-builder /usr/local/lapack /usr/local/lapack

# Set up environment variables for OpenMPI
ENV PATH="/opt/openmpi/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/openmpi/lib:$LD_LIBRARY_PATH"

# Compile QE (for test only)
ARG QE_VERSION

RUN wget -c -O qe.tar.gz https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VERSION}/q-e-qe-${QE_VERSION}.tar.gz && \
    mkdir -p qe && \
    tar xf qe.tar.gz -C qe --strip-components=1 && \
    cd qe && \
    LAPACK_LIBS=/usr/local/lapack/lib/liblapack.a BLAS_LIBS=/usr/local/lapack/lib/librefblas.a ./configure -enable-static && \
    make -j8 all && \
    make install


# Move binaries to a small image to reduce the size
FROM runtime-base-image

COPY --from=qe-builder /usr/local/bin/* /usr/local/bin/

# Require OMPI to run
COPY --from=openmpi-builder /opt/openmpi /opt/openmpi

# Set up environment variables for OpenMPI
ENV PATH="/opt/openmpi/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/openmpi/lib:$LD_LIBRARY_PATH"
