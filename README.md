Prometheus Proxmox VE Exporter
==============================

This is an exporter that exposes information gathered from Proxmox VE
node for use by the Prometheus monitoring system based upon https://github.com/znerol/prometheus-pve-exporter

Running the docker container
------------


    docker run -d --name prometheus-pve-exporter -p 9221:9221 -v <localfolder>:/usr/src/app/ tommeulensteen/prometheus-pve-exporter

> :warning: **You have to supply a pve.yml in the <localfolder> for the container to work**

Use `::` for the `address` argument in order to bind to both IPv6 and IPv4
sockets on dual stacked machines.

Visit http://localhost:9221/pve?target=1.2.3.4 where 1.2.3.4 is the IP
of the Proxmox VE node to get metrics from. Specify the ``module``
request parameter, to choose which module to use from the config file.

The ``target`` request parameter defaults to ``localhost``. Hence if
``pve_exporter`` is deployed directly on the proxmox host, ``target``
can be omitted.

See the wiki_  for more examples and docs.

Authentication
--------------

Example ``pve.yml``

    default:
        user: prometheus@pve
        password: sEcr3T!
        verify_ssl: false

The configuration is passed directly into `proxmoxer.ProxmoxAPI()`_.

Proxmox VE Configuration
------------------------

For security reasons it is essential to add a user with read-only access
(PVEAuditor role) for the purpose of metrics collection.

Prometheus Configuration
------------------------

The PVE exporter can be deployed either directly on a Proxmox VE node or
onto a separate machine.

Example config for PVE exporter running on PVE node:

.. code:: yaml

    scrape_configs:
      - job_name: 'pve'
        static_configs:
          - targets:
            - 192.168.1.2:9221  # Proxmox VE node with PVE exporter.
            - 192.168.1.3:9221  # Proxmox VE node with PVE exporter.
        metrics_path: /pve
        params:
          module: [default]

Example config for PVE exporter running on Prometheus host:

.. code:: yaml

    scrape_configs:
      - job_name: 'pve'
        static_configs:
          - targets:
            - 192.168.1.2  # Proxmox VE node.
            - 192.168.1.3  # Proxmox VE node.
        metrics_path: /pve
        params:
          module: [default]
        relabel_configs:
          - source_labels: [__address__]
            target_label: __param_target
          - source_labels: [__param_target]
            target_label: instance
          - target_label: __address__
            replacement: 127.0.0.1:9221  # PVE exporter.

Grafana Dashboards
------------------

* `Proxmox via Prometheus by Pietro Saccardi`_


.. |Build Status| image:: https://travis-ci.org/znerol/prometheus-pve-exporter.svg?branch=master
   :target: https://travis-ci.org/znerol/prometheus-pve-exporter
.. |Package Version| image:: https://img.shields.io/pypi/v/prometheus-pve-exporter.svg
   :target: https://pypi.python.org/pypi/prometheus-pve-exporter
.. _wiki: https://github.com/znerol/prometheus-pve-exporter/wiki
.. _`proxmoxer.ProxmoxAPI()`: https://pypi.python.org/pypi/proxmoxer
.. _`Proxmox via Prometheus by Pietro Saccardi`: https://grafana.com/dashboards/10347
