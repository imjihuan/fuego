############
test.yaml
############

The ``test.yaml`` file is used to hold meta-information about a test.  This is
used by the :ref:`Test package system`  for packaging a test and providing
information for viewing and searching for tests in a proposed "test store".
The ``test.yaml`` file can also can be used by human maintainers to preserve
information (in a structured format) about a test, that is not included in the
other test materials.

As an overview, the ``test.yaml`` file indicates where the source for the
test comes from, it's license, the name of the test maintainer, a
description of the test and tags for categorizing the test, and a
formal list of parameters that are used by the test (what they mean
and how to use them).

=====================
test.yaml fields
=====================

Here are the fields supported in a ``test.yaml`` file:

``fuego_package_version``

  Indicates the version of package
  (in case of changes to the package schema).  For now, this is always 1.

``name``

  Has the full Fuego name of the test.  Ex: Benchmark.iperf

``description``

  Has an English description of the test

``license``

  Has an SPDX identifier for the test.  This is the main
  license of the test project that the Fuego test uses, if the project
  has a tarfile or git repo.  Otherwise it reflects the license of any
  non-Fuego-specific materials in the test directory.  In such case,
  the test directory should include a LICENSE file.  Fuego materials
  (``fuego_test.sh``, ``spec.json``, ``chart_config.json``, etc.) are
  considered to be under the default Fuego license (which is BSD-3-Clause)
  unless otherwise specifically indicated in these files.  The license
  identifier for this field should be obtained from
  `<https://spdx.org/licenses/>`_

``author``

  The author or authors of the base test

``maintainer``

  The maintainer of the Fuego materials for this test

``version``

  The version of the base test

``fuego_release``

  The version of Fuego materials for this test.  This is a monotonically
  incrementing integer, starting at 1 for each new version of the base test.

``type``

  Either Benchmark or Functional

``tags``

  A list of tags used to categorize this test.  This is intended to be
  used in an eventual online test store.

``tarball_src``

  A URL where the tarball was originally obtained from


``gitrepo``

  A git URL where the source may be obtained from

``host_dependencies``

  A list of Debian package names that must be installed in the docker
  container in order for this test to work properly.  This field is
  optional, and indicates packages needed that are beyond those included in
  the standard Fuego host distribution in the Fuego docker container.

``params``

  A list of parameters that may be used with this test, including their
  descriptions, whether they are optional or required, and an example
  value for each one

``data_files``

  A list of the files that are included in this test.  This is used as the
  manifest for packaging the test (``fuego_test.sh``, and ``test.yaml`` are
  implicitly included in the packaging manifest).


More on params
===================

The 'params' field in the test.yaml file is a list of dictionaries
with one item per test variable used by the test.

The name of the parameter is the short name of the parameter, without
the test name prefix (e.g. FUNCTIONAL_LTP).  The parameter name is the
key for the dictionary with that parameters attributes.

Each parameter has a dictionary with attributes describing it.  The
dictionary has the following fields (keys):

 - 'description' - text description of the parameter
 - 'example' - an example of the parameter
 - 'optional' - indicates whether the test requires this parameter
   (test variable) to be set or not.  The value of the 'optional'
   field must be one of 'yes' or 'no'.

The test variables may be described by the ``test.yaml`` file can be
defined in one of multiple locations in the Fuego test system.  Most
commonly the test variables are defined in a spec for the test, but
they can also be defined in the board file, or as a dynamic board
variable.

=========
Example
=========

Here is an example ``test.yaml`` file, for the package ``Benchmark.iperf3``:

::

  fuego_package_version: 1
  name: Benchmark.iperf3
  description: |
      iPerf3 is a tool for active measurements of the maximum achievable
      bandwidth on IP networks.
  license: BSD-3-Clause.
  author: |
      Jon Dugan, Seth Elliott, Bruce A. Mah, Jeff Poskanzer, Kaustubh Prabhu,
      Mark Ashley, Aaron Brown, Aeneas Jaißle, Susant Sahani, Bruce Simpson,
      Brian Tierney.
  maintainer: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
  version: 3.1.3
  fuego_release: 1
  type: Benchmark
  tags: ['network', 'performance']
  tarball_src: https://iperf.fr/download/source/iperf-3.1.3-source.tar.gz
  gitrepo: https://github.com/esnet/iperf.git
  params:
      - server_ip:
          description: |
              IP address of the server machine. If not provided, then SRV_IP
              _must_ be provided on the board file. Otherwise the test will fail.
              if the server ip is assigned to the host, the test automatically
              starts the iperf3 server daemon. Otherwise, the tester _must_ make
              sure that iperf3 -V -s -D is already running on the server machine.
          example: 192.168.1.45
          optional: yes
      - client_params:
          description: extra parameters for the client
          example: -p 5223 -u -b 10G
          optional: yes
  data_files:
      - chart_config.json
      - fuego_test.sh
      - parser.py
      - spec.json
      - criteria.json
      - iperf-3.1.3-source.tar.gz
      - reference.json
      - test.yaml
