# tika-ocr

Custom Apache Tika image for `tika.populate.tools` with OCR enabled for Spanish, Catalan and Basque.

## What's inside

- Base: `apache/tika:latest-full` (Tika + Tesseract + English).
- Adds: `tesseract-ocr-spa`, `tesseract-ocr-cat`, `tesseract-ocr-eus`.
- Loads `tika-config.xml` so the PDF parser uses `ocrStrategy=auto` — OCR runs only when a page has no text layer, so text-PDF extraction stays fast.

## Image

`ghcr.io/populatetools/tika-ocr:latest`

GitHub Actions rebuilds the image:

- on every push to `main`,
- nightly at 04:00 UTC, so the upstream `apache/tika:latest-full` security updates get picked up,
- on demand via `workflow_dispatch`.

Tags published: `latest`, `sha-<short>`, `nightly`.

## Local smoke test

```bash
docker build -t tika-ocr:dev .
docker run --rm -p 9998:9998 tika-ocr:dev

curl -sL -o /tmp/anexos.pdf \
  "https://contratos-files.gobierto.es/documents/tenders/6a89c71d8756f85720bb40f2c631b13d/Anexos.pdf"

curl -sX PUT --data-binary @/tmp/anexos.pdf \
  -H "Content-Type: application/pdf" \
  -H "Accept: text/plain" \
  http://localhost:9998/tika | wc -c
```

A successful run prints a body well over 20 bytes containing recognisable Spanish text. The same request against vanilla `apache/tika:latest-full` returns ~20 bytes of newlines for image-only PDFs.

## Deploy

Pull the published image and run it however you deploy containers:

```bash
docker pull ghcr.io/populatetools/tika-ocr:latest
docker run -d -p 9998:9998 ghcr.io/populatetools/tika-ocr:latest
```

## Why this exists

`apache/tika:latest-full` ships Tesseract + English only. Image-only PDFs from Spanish public administrations (scanner output, Hewlett-Packard MFP, etc.) silently extracted to empty strings, masking ~22% of indexed documents in `contratos.gobierto.es`. See the parent investigation in the contratos repo.
