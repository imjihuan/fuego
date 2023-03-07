.. _front-page:

##################
Fuego Test System
##################

=================
Welcome to Fuego!
=================

Fuego is a test system specifically designed for embedded Linux testing.
It supports automated testing of embedded targets from a host system,
as its primary method of test execution.

Fuego consists of a host/target script engine, and over 100 pre-packages
tests.  These are installed in a docker container along with a Jenkins
web interface and job control system, ready for out-of-the-box
Continuous Integration testing of your embedded Linux project.

The idea is that in the simplest case, you just add your board, select
or install a toolchain, and go!

Introduction presentation
-------------------------

Tim Bird gave some talks introducing Fuego, at various conferences
in 2016.  The slides and a video are provided below, if you want
to see an overview and introduction to Fuego.

The slides are here:
`Introduction-to-Fuego-LCJ-2016.pdf
<http://fuegotest.org/ffiles/Introduction-to-Fuego-LCJ-2016.pdf>`_,
along with a
`YouTube video <https://youtu.be/AueBSRN4wLk>`_.
You can find more presentations about Fuego on our wiki at:
`<http://fuegotest.org/wiki/Presentations>`_.


================
Getting Started
================

There are a few different ways to get started with Fuego:
 1. Use the :ref:`Fuego Quickstart Guide <quickstart_guide>` to
    get Fuego up an running quickly.
 2. Or go through our :ref:`Install and First Test <install_and_first_test>`
    tutorial to install Fuego and run a test on a single "fake" board.
    This will give you an idea of basic Fuego operations, without
    having to configure Fuego for your own board
 3. Work through the documentation for :ref:`Installation <installfuego>`

Where to download
-----------------

Code for the test framework is available in 2 git repositories:
 * `<https://bitbucket.org/fuegotest/fuego/>`_
 * `<https://bitbucket.org/fuegotest/fuego-core/>`_

The fuego-core directory resides inside the fuego directory.
But normally you do not clone that repository directly.  It is cloned
for you during the Fuego install process.  See the
:ref:`Fuego Quickstart Guide <quickstart_guide>` or the
:ref:`Installing Fuego <installfuego>` page for more information.

===============
Documentation
===============
See the index below for links to the major sections of the documentation
for Fuego.  The major sections are:

 * :ref:`Tutorials <tutor>`
 * :ref:`Installation and Administration <admin>`
 * :ref:`User Guides <user_guides>`
 * :ref:`Developer Resources <dev_res>`
 * :ref:`API Reference <api_rex>`

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

..
   FIXTHIS - 'admonition:: Vision' didn't work with rtd theme

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

Historically, test frameworks for embedded Linux have been difficult to
set up, and difficult to extend.  Many Linux test systems are not easily
applied in cross or embedded environments. Some very full frameworks are
either not viewed as processor-neutral, and are difficult to set up, or
are targeted at running tests on a dedicated group of boards or devices.

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
be this.  It intends to provide test programs, a system to build,
deploy and run them, and tools to analyze, track, and visualize test
results.

For more details about a high-level vision of open source testing,
please see  :ref:`OSS Test Vision <oss>`.

================
Other Resources
================

Historical information
----------------------


`<http://elinux.org/Fuego>`_ has some historical information about
Fuego.

Things to do
------------

Looking for something to do on Fuego?  See the Fuego wiki
for a list of projects, at:
`Fuego To Do List <http://fuegotest.org/wiki/Fuego_To_Do_List>`_

