FROM containers4hpc/base-mpich314:0.1.0

# Install QE 7.0 (pw.x only for now)
# FOR PRODUCTION: PUT ALL IN THE SAME LINE TO AVOID HAVING LAYERS WITH A LOT OF FILES!
RUN wget -q https://gitlab.com/QEF/q-e/-/archive/qe-7.0/q-e-qe-7.0.tar.gz \
    && tar xzf q-e-qe-7.0.tar.gz
RUN cd q-e-qe-7.0 \
    && ./configure \
    && make -j4 pw \
    && make install \
    && cd .. && rm -fr q-e-qe-*