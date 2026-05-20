FROM apache/tika:latest-full

USER root

ENV OMP_THREAD_LIMIT=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        tesseract-ocr-spa \
        tesseract-ocr-cat \
        tesseract-ocr-eus \
    && rm -rf /var/lib/apt/lists/*

ARG JAI_IMAGEIO_CORE_VERSION=1.4.0
ARG JAI_IMAGEIO_JPEG2000_VERSION=1.4.0
RUN mkdir -p /tika-extras \
    && wget -q -O /tika-extras/jai-imageio-core.jar \
        "https://repo1.maven.org/maven2/com/github/jai-imageio/jai-imageio-core/${JAI_IMAGEIO_CORE_VERSION}/jai-imageio-core-${JAI_IMAGEIO_CORE_VERSION}.jar" \
    && wget -q -O /tika-extras/jai-imageio-jpeg2000.jar \
        "https://repo1.maven.org/maven2/com/github/jai-imageio/jai-imageio-jpeg2000/${JAI_IMAGEIO_JPEG2000_VERSION}/jai-imageio-jpeg2000-${JAI_IMAGEIO_JPEG2000_VERSION}.jar"

COPY tika-config.xml /opt/tika-config.xml

USER 35002:35002

CMD ["-c", "/opt/tika-config.xml"]
