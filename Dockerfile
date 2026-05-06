FROM apache/tika:latest-full

USER root

ENV OMP_THREAD_LIMIT=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        tesseract-ocr-spa \
        tesseract-ocr-cat \
        tesseract-ocr-eus \
    && rm -rf /var/lib/apt/lists/*

COPY tika-config.xml /opt/tika-config.xml

USER 35002:35002

CMD ["-c", "/opt/tika-config.xml"]
