
############
Front page
############

This is the documentation for the Fuego test system.

===============
Introduction 
===============

Fuego is a test framework specifically designed for embedded Linux testing.

It supports automated testing of embedded targets from a host system,
as it's primary method of test execution.

The quick introduction to Fuego is that it consists of a host/target
script engine, with a Jenkins front-end, and over 50 pre-packaged
tests, installed in a docker container.

Intro presentation 
------------------

Tim Bird gave a talk introducing Fuego, at Embedded Linux Conference
in April 2016, and LinuxCon Japan 2016.  The slides were improved a
bit for the talk in Japan, but there's only video for the ELC talk
(not the LCJ talk).  Therefore, here are links to the LCJ slides and
the ELC video.  The slides are close enough that you should be able to
follow along.

The slides from LCJ are available here:
`Introduction-to-Fuego-LCJ-2016.pdf <http://fuegotest.org/ffiles/Introduction-to-Fuego-LCJ-2016.pdf>`_

And here is the video from ELC:
`You tube video <https://youtu.be/AueBSRN4wLk>`_

You can find more presentations about Fuego on our wiki at:
`<http://fuegotest.org/wiki/Presentations>`_.


============
Quickstart 
============

Please see the :ref:`Fuego Quickstart Guide <quickstart>` for how to
get up an running quickly in Fuego.

Where to download 
-----------------

Code for the test framework is available in 2 git repositories:
 * `<https://bitbucket.org/fuegotest/fuego/>`_
 * `<https://bitbucket.org/fuegotest/fuego-core/>`_

The fuego-core directory should reside inside the fuego directory.
But normally you do not clone that repository directly.  It is cloned
for you during the Fuego install process.  See the
:ref:`Fuego Quickstart Guide <quickstart>` or the
:ref:`Installing Fuego <installfuego>` page for more information.

===============
Documentation 
===============

 * :ref:`Documentation <doc>` has user documentation for Fuego.

============
Resources
============

Mailing list
------------

Fuego discussions are held on the fuego mailing list:
 * `<https://lists.linuxfoundation.org/mailman/listinfo/fuego>`_

Note that this is a new list (as of September 2016).  Previously,
discussions about Fuego (and its predecessor JTA) were held on the
ltsi-dev mailing list:
 * `<https://lists.linuxfoundation.org/mailman/listinfo/ltsi-dev>`_

Presentations
-------------

A number of presentations have been given on the Fuego test framework,
and related projects (such as its predecessor JTA, and a derivative
project JTA-AGL).

See the `Presentations <http://fuegotest.org/wiki/Presentations>`_
page on the Fuego wiki for a list of presentations that you can read
or view for more information about Fuego.

==========
Vision
==========
 
The purpose of Fuego is to bring the benefits of open source to the
testing process.

It can be summed up like this:

.. note:: 

  Do for testing
  what open source has done for coding

There are numerous aspects of testing that are still done in an ad-hoc
and company-specific way.  Although there are open source test
frameworks (such as Jenkins or LAVA), and open source test programs
(such as cylictest, LTP, linuxbench, etc.), there are lots of aspects
of Linux testing that are not shared.

The purpose of Fuego is to provide a test framework for testing
embedded Linux, that is distributed and allows individuals and
organizations to easily run their own tests, and at the same time
allows people to share their tests and test results with each other.

Historically, test frameworks for embedded Linux have been difficult
to set up, and difficult to extend. In cases where a test program was
reasonably self-contained, the test system was not easy to to extend.
Many Linux test systems are not easily applied in cross or embedded
environments. Some very full frameworks are either not viewed as
processor-neutral, and are difficult to set up, or are targeted at
running tests on a dedicated group of boards or devices.

The vision of open source in general is one of sharing source code and
capabilities, to expand the benefits to all participants in the
ecosystem. The best way to achieve this is to have mechanisms to
easily use the system, and easily share enhancements to the system, so
that all participants can use and build on each others efforts.

The goal of Fuego is to provide a framework that any group can install
and use themselves, while supporting important features like
cross-compilation, host/target test execution, and easy test
administration. Test administration consists of starting tests (both
manually and automatically), viewing test results, and detecting
regressions. Ease of use is critical, to allow testers to use tests
that are otherwise difficult to individually set up, configure, and
interpret the results from. It is also important to make it very easy
to share tests (scripts, configuration, results parsing, and
regression detection methods).

Some secondary goals of this project are the ability for 3rd parties
to initiate or schedule tests on our hardware, and the ability to
share our test results with others.

The use of Jenkins as the core of the test framework already supports
many of the primary and secondary goals. The purpose of this project
is to augment the Jenkins system to support embedded configurations of
Linux, and to provide a place for centralized sharing of test
configurations and collateral.

There is no such thing as a "Linux Test distribution".  Fuego aims to
be this.  It intends to provide test programs, scripts to build,
deploy and run them, and tools to analyze, track, and visualize test
results.

For more details about a high-level vision of open source testing,
please see :ref:`OSS Test Vision <oss>`.

================
Other Resources 
================

Historical information
----------------------


`<http://elinux.org/Fuego>`_ has some historical information about Fuego.

Related systems
---------------
 
See :ref:`Other test systems <ots>` for notes and comparisons

Things to do 
------------

Looking for something to do on Fuego?  See the Fuego wiki
for a list of projects, at:
`Fuego To Do List <http://fuegotest.org/wiki/Fuego_To_Do_List>`_

