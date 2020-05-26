FROM        python:alpine

WORKDIR /usr/src/app

RUN         pip install --no-cache-dir prometheus-pve-exporter

EXPOSE      9221

ENTRYPOINT  [ "/usr/local/bin/pve_exporter" ]
CMD         [ "/usr/src/app/pve.yml", "9221" ]