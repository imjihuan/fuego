.. _run_json:

###########
run.json
###########

===========
Summary
===========

The ``run.json`` file has data about a particular test run.  It has
information about the test, including the results for the test.

The format of portions of this file was inspired by the KernelCI API.
See `<https://api.kernelci.org/schema-test-case.html>`_

The results are included in an array of test_set objects, which can
contain arrays of test_case objects, which themselves may contain
measurement objects.


===================
Field details
===================

 * **duration** - the amount of time, in milliseconds, that the test
   took to execute

   * If the test included a build, this time is included in this number

 * **metadata** - various fields that are specific to Fuego

   * **attachments** - a list of the files that are available for this
     test - usually logs and such
   * **batch_id** - a string indicating the batch of tests this test was run
     in (if applicable)
   * **board** - the board the test was executed on
   * **build_number** - the Jenkins build number
   * **compiled_on** - indicates the location where the test was compiled
   * **fuego_core_version** - version of the fuego core system
   * **fuego_version** - version of the fuego container system
   * **host_name** - the host.  If not configured, it may be 'local_host'
   * **job_name** - the Jenkins job name for this test run
   * **keep_log** - indicates whether the log is kept (???)
   * **kernel_version** - the version of the kernel running on the board
   * **reboot** - indicates whether a reboot was requested for this test run
   * **rebuild** - indicates whether it was requested to rebuild the source
     for this run
   * **start_time** - time when this test run was started (in seconds since
     Jan 1, 1970)
   * **target_postcleanup** - indicates whether cleanup of test materials on the
     board was requested for after test execution
   * **target_precleanup** - indicates whether cleanup of test materials on the
     board was requested for before test execution
   * **test_plan** - test plan being executed for this test run.  May be 'None'
     if test was not executed in the context of a larger plan
   * **test_spec** - test spec used for this run
   * **testsuite_version** - version of the source program used for this run

     * FIXTHIS - testsuite_version is not calculated properly yet

   * **timestamp** - time when this test run was started (in ISO 8601 format)
   * **toolchain** - the toolchains (or PLATFORM) used to build the test program
   * **workspace** - a directory on the host where test materials were extracted
     and built, for this test.

     * This is the parent directory used, and not the specific directory used for
       this test.

 * **name** - the name of the test
 * **status** - the test result as a string.  This can be one of:

   * PASS
   * FAIL
   * ERROR
   * SKIP

 * **test_sets** - list of test_set objects, containing test results
 * **test_cases** - list of test_case objects, containing test results

   * Each test_case object has:

     * **name** - the test case name
     * **status** - the result for that test case

 * **measurements** - list of measurement objects, containing test results

   * For each measurement, the following attributes may be present:

     * **name** - the measure name
     * **status** - the pass/fail result for that test case
     * **measure** - the numeric result for that test case

============
Examples
============

Here are some sample ``run.json`` files, from Fuego 1.2


Functional test results
=============================

This was generated using

::

 ftc run-test -b docker -t Functional.hello_world

This example only has a single test_case.

::

  {
      "duration_ms": 1245,
      "metadata": {
          "attachments": [
              {
                  "name": "devlog",
                  "path": "devlog.txt"
              },
              {
                  "name": "devlog",
                  "path": "devlog.txt"
              },
              {
                  "name": "syslog.before",
                  "path": "syslog.before.txt"
              },
              {
                  "name": "syslog.after",
                  "path": "syslog.after.txt"
              },
              {
                  "name": "testlog",
                  "path": "testlog.txt"
              },
              {
                  "name": "consolelog",
                  "path": "consolelog.txt"
              },
              {
                  "name": "test_spec",
                  "path": "spec.json"
              }
          ],
          "board": "docker",
          "build_number": "3",
          "compiled_on": "docker",
          "fuego_core_version": "v1.1-805adb0",
          "fuego_version": "v1.1-5ad677b",
          "host_name": "fake_host",
          "job_name": "docker.default.Functional.hello_world",
          "keep_log": true,
          "kernel_version": "3.19.0-47-generic",
          "reboot": "false",
          "rebuild": "false",
          "start_time": "1509662455755",
          "target_postcleanup": true,
          "target_precleanup": "true",
          "test_plan": "None",
          "test_spec": "default",
          "testsuite_version": "v1.1-805adb0",
          "timestamp": "2017-11-02T22:40:55+0000",
          "toolchain": "x86_64",
          "workspace": "/fuego-rw/buildzone"
      },
      "name": "Functional.hello_world",
      "schema_version": "1.0",
      "status": "PASS",
      "test_sets": [
          {
              "name": "default",
              "status": "PASS",
              "test_cases": [
                  {
                      "name": "hello_world",
                      "status": "PASS"
                  }
              ]
          }
      ]
  }



Benchmark results
=======================

Here is the ``run.json`` file for a run of the test ``Benchmark.netperf``
on the board 'ren1' (which is a Renesas board in my lab).

::

  {
      "duration_ms": 33915,
      "metadata": {
          "attachments": [
              {
                  "name": "devlog",
                  "path": "devlog.txt"
              },
              {
                  "name": "devlog",
                  "path": "devlog.txt"
              },
              {
                  "name": "syslog.before",
                  "path": "syslog.before.txt"
              },
              {
                  "name": "syslog.after",
                  "path": "syslog.after.txt"
              },
              {
                  "name": "testlog",
                  "path": "testlog.txt"
              },
              {
                  "name": "consolelog",
                  "path": "consolelog.txt"
              },
              {
                  "name": "test_spec",
                  "path": "spec.json"
              }
          ],
          "board": "ren1",
          "build_number": "3",
          "compiled_on": "docker",
          "fuego_core_version": "v1.2.0",
          "fuego_version": "v1.2.0",
          "host_name": "local_host",
          "job_name": "ren1.default.Benchmark.netperf",
          "keep_log": true,
          "kernel_version": "4.9.0-yocto-standard",
          "reboot": "false",
          "rebuild": "false",
          "start_time": "1509669904085",
          "target_postcleanup": true,
          "target_precleanup": "true",
          "test_plan": "None",
          "test_spec": "default",
          "testsuite_version": "v1.1-805adb0",
          "timestamp": "2017-11-03T00:45:04+0000",
          "toolchain": "poky-aarch64",
          "workspace": "/fuego-rw/buildzone"
      },
      "name": "Benchmark.netperf",
      "schema_version": "1.0",
      "status": "PASS",
      "test_sets": [
          {
              "name": "default",
              "status": "PASS",
              "test_cases": [
                  {
                      "measurements": [
                          {
                              "measure": 928.51,
                              "name": "net",
                              "status": "PASS"
                          },
                          {
                              "measure": 59.43,
                              "name": "cpu",
                              "status": "PASS"
                          }
                      ],
                      "name": "MIGRATED_TCP_STREAM",
                      "status": "PASS"
                  },
                  {
                      "measurements": [
                          {
                              "measure": 934.1,
                              "name": "net",
                              "status": "PASS"
                          },
                          {
                              "measure": 56.61,
                              "name": "cpu",
                              "status": "PASS"
                          }
                      ],
                      "name": "MIGRATED_TCP_MAERTS",
                      "status": "PASS"
                  }
              ]
          }
      ]
  }

