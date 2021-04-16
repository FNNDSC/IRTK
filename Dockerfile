# tip: use buildx to parallelize multi-stage builds
#
#    DOCKER_BUILDKIT=1 docker build --build-arg j=8 -t fnndsc/irtk .

FROM debian:buster-slim as builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y libvtk6-dev libfltk1.3-dev libgsl-dev libboost-dev cmake

WORKDIR /usr/local/bin/src
COPY . .
ARG j=8
RUN mkdir build && cd build && cmake .. && make -j ${j}

FROM debian:buster-slim
ARG DEBIAN_FRONTEND=noninteractive
# btw these are the libraries, not including development headers
# less than what's above in the builder image
RUN apt-get update && apt-get install -y \
    libvtk6.3 libgsl23 libfltk-images1.3 libfltk-gl1.3 libfltk-forms1.3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/src/build /opt/IRTK

ENV PATH=/opt/IRTK/bin:$PATH
CMD ["/opt/IRTK/bin/reconstruction"]
