############################
Fuego configuration file
############################

The Fuego configuration file contains configuration options and
settings for the Fuego test system.

The following settings are supported:

===============================
Fuego test network settings
===============================

These settings are used when a host participates in a Fuego test
network.  This refers to distributed operations between Fuego labs,
and not to the test network within a single Fuego lab.

host_name
================

host_name is used to specify a name for this instance of Fuego, within
the worldwide Fuego test network (or within a company Fuego network).
The default value for host_name is 'fuegohost'.  If this site
participates in distributed testing, the host_name should be set to
something unique, which describes the host.  For example, my lab uses
a Fuego host_name of "timdesk".

During test execution, this value appears in the environment variable
``FUEGO_HOST``.

A host_name should only consist of letters, numbers and underscores.
No other punctuation is allowed.

fuego_server
==================

The fuego_server setting indicates the domain name or IP address where
a Fuego test server is running.  This is a site where fuego tests can
be uploaded and downloaded, and where run requests can be posted and
retrieved, and run data can be uploaded for sharing.

By default, the value for this is 'fuegotest.org', which is the main
fuego web site.  If an organization is running its own Fuego server,
it should specify the IP address for their own server.

=====================
Fuego directories
=====================

Fuego data and programs are located in three directories, used for
read-only data, read-write data, and a core system directory.  These
variables are normally located within the Fuego repository, and at
hardcoded locations within the docker container.  However, they are
specified in the fuego configuration file so that the directories may
be placed elsewhere if this is convenient.

Each of these directories is normally specified as a file path
relative to the directory where the ``fuego.conf`` file resides.  However,
absolute paths are allowed.  If absolute paths are used, then the bind
mounts for the docker container should be such at the same absolute
paths can used both inside and outside the docker container to access
these directories.  For example, you could re-configure Fuego to use
directories under ``/opt/fuego`` both inside the container and on the
host.

fuego_ro_dir
==================

This indicates the location of the Fuego read-only data directory.
The default value is "..", since the fuego.conf file usually resides
in the directory ``fuego-ro/conf``.

Some important directories that reside in the fuego-ro directory are
the conf, boards and toolchains directory.

fuego_rw_dir
==================

``fuego_rw_dir`` indicates the location of the Fuego read-write data
directory.  The default value for fuego_rw_dir is ``../../fuego-rw``

Some important directories that reside in the ``fuego-rw`` directory are
the buildzone and logs directories.

fuego_core_dir
======================

The fuego_core_dir indicates the location of the Fuego core directory,
which has the main scripts, programs, data and source code that make
up the Fuego test system.  The default value for fuego_core_dir is
../../fuego-core

=============================
Configuration file syntax
=============================

The configuration file uses a very simple name=value syntax.  Most
settings consist of a single line.  Lines starting with '#' are
ignored.  Empty lines are ignored, and lines starting with a '#' are
interpreted as comments and are ignored.

If a setting value requires multiple lines, it is enclosed in
triple-double quotes, like a python multiline string.

Example: ::

  # this is a comment
  variable=value
  multi_line_variable="""foo
     bar
  baz   baf
  """
