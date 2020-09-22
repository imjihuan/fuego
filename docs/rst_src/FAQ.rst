.. _faq:

#####
FAQ
#####

Here is a list of Frequently Asked Questions and Answers about Fuego:

===========================
Languages and formats used
===========================

Q. Why does Fuego use shell scripting as the language for tests?
==================================================================

There are other computer languages which have more advanced features
(such as data structions, object orientation, rich libraries,
concurrency, etc.) than shell scripting.  It might seem odd that shell
scripting was chosen as the language for implementing the base scripts
for the tests in fuego, given the availability of these other
languages.

The Fuego architecture is specifically geared toward host/target
testing.  In particular, tests often perform a variety of operations
on the target in addition to the operations that are performed on the
host.  When the base script for a test runs on the host machine,
portions of the test are invoked on the target.  It is still true
today that the most common execution environment (besides native code)
that is available on almost every embedded Linux system is a
POSIX-compliant shell.  Even devices with very tight memory
requirements usually have a busybox 'ash' shell available.

In order to keep the base script consistent, Fuego uses shell
scripting on both the host and target systems.  Shell operations are
performed on the target using 'cmd', 'report' and 'report_append'
functions provided by Fuego.

Note that Fuego officially use 'bash' as the shell on the host, but
does not require a particular shell implementatio to be available on
the target.  Therefore, it is important to use only POSIX-compatible
shell features for those aspects of the test that run on target.








