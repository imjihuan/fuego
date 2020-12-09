##############################
Functional.fuego release test
##############################

=============
Description
=============

``Functional.fuego_release_test`` is a Fuego selftest, intended to be run
immediately before a release to test a ``Fuego/Jenkins`` integration.

It builds a separate docker container, with jenkins running on another
port, and then runs tests against that other container.

=============
Resources
=============

 * See the README for this test at:
   `<https://bitbucket.org/fuegotest/fuego-core/src/master/tests/Functional.fuego_release_test/README.md>`_


===========
Results
===========

As of July 2020, this test has been broken since at least January 2019.


See `<http://fuegotest.org/wiki/Issue_0074>`_

========
Tags
========

 * fuego
 * selftest

================
Dependencies
================


==========
Status
==========

 * not OK

==========
Notes
==========

How to run
================

In order to run the test, you need to build your initial container with
``Dockerfile.test`` instead of Dockerfile.  Otherwise, you will not have
the needed components in the Fuego docker container for the test.


The following is a guess as to the correct sequence:

 * ./fuego-host-scripts/docker-build-image.sh fuego 8090 Dockerfile
 * ./fuego-host-scripts/docker-build-image.sh fuego-test 8090 Dockerfile.test
 * ./fuego-host-scripts/docker-create-container.sh fuego-test fuego-test-container
 * ./start.sh fuego-test-container
 * ftc add-node -b fuego-test
 * ftc add-job -b fuego-test -t Functional.fuego_release_test
 * ftc build-job fuego-test.default.Functional.fuego_release_test

