
##############
Updating Fuego
##############

Here are some notes about updating Fuego, and some tips for when it
might be necessary and when not.

=================
Introduction
=================

Fuego consists of two repositories - ``fuego`` and ``fuego-core``.  The
contents of the ``fuego`` repository are primarily focused on the
creation and management of the docker container, and the ``fuego`` Linux
distribution inside it, and on global configuration for the Fuego
system (including fuego configuration, board definitions and
toolchains).

The ``fuego-core`` repository has the core engine of Fuego, including
the 'ftc' command, the core scripts, and the Fuego tests themselves
(including source code in many cases).  This repository may get
updates more frequently as tests are added or as the core framework of
Fuego is fixes, extended and enhanced.

One of the goals of having separate repositories (which are a bit of a
pain to keep synchronized) is to make it possible to update the test
framework and tests in ``fuego-core`` without having to update the
``fuego`` repository or rebuild the docker container.

===================
Upgrading Fuego
===================

'pull'ing fuego-core
==========================

In many cases, you can upgrade the Fuego test framework merely by
doing a 'git pull' on the ``fuego-core`` repository, on your host
machine.  This will pull new features and new tests into your
``fuego-core`` repository.  The new scripts, tools and tests in this
repository will become visible inside your container under the
directory: ``/fuego-core``.

You can even do this while the docker container is running.  However,
you should not do a 'git pull' on ``fuego-core`` while a test is
running.  That might change the scripts and tools in the middle of a
test, which would lead to unpredictable behavior.

If you have local modifications to existing tests, you may need to
'git stash' those modifications, and merge them with the new code, in
order to proceed with the update.  New tests that you have created
should be in their own directories, and should not be affected by a
'git pull'.

For Fuego releases, we strive to preserve backwards compatibility with
core APIs, so that existing tests will not break when a new core
framework is installed.  However, in some rare cases this is
unavoidable.  These situations will be noted in the release notes for
a particular release.  See :ref:`Releases` for links to information about
each release.  In particular, a large amount of framework refactoring
occurred in the 1.1 and 1.2 releases.

In rare cases, which will be announced on the Fuego mailing list and
noted in the release notes, a change will be made in the framework
that is incompatible with the current format of nodes, jobs or builds,
as held by the Jenkins server.  In this case it becomes impossible to
use pre-existing test data with the new framework, and it may become
necessary to shelve that data and start a new instance (either of the
docker container or of Jenkins).


'pull'ing fuego
=====================

As new features are added to Fuego, sometimes it becomes necessary to
alter the way the docker container is built, or to add additional
Debian packages to the 'fuego' distribtion of Linux that is inside the
container.  These types of changes sometimes require that a new
container be built with the new attributes.  However, building a new
container eliminates the Jenkins node, job, and build data that is in
the current container.  For this reason, it is desirable to avoid
rebuilding the container, if possible.

In many cases it is possible to pull a new ``fuego`` repository and NOT
have to rebuild the container, by just implementing manually whatever
was changed.  For example, the most common change to ``fuego`` is in the
Dockerfile, to add a new package to the fuego distribution of Linux
inside the container.  While you could rebuild the container from
scratch after such a change, you can also manually just do an 'apt-get
install <new-package>' inside the running docker container.  This will
provide the same functionality for your existing docker container that
a new one would have (providing that new library, tool or feature).

In some cases, it is possible to implement other changes as well.  For
example, if a tool is placed in a new location by an updated
Dockerfile, then you could manually move the tool in your docker
container, for the same effect.  The details of this operation depend
on what has changed.  You can do a 'git log' in the 'fuego' repository
for details about the changes made, and decide if you can effect those
changes in your existing container, without having to rebuild a new
one.  If you have any questions, please ask them on the Fuego mailing
list, and we will try to assist.



Preserving old containers
==============================

Please note that you do not have to destroy or remove a container when
you create a new one.  By convention the fuego docker image is called
``fuego`` and the fuego docker container is called ``fuego-container``.
You can specify different names when you create a new image and
container, but the preferred method of dealing with this is to rename
the existing image and container, and create new ones with the default
names.  If you plan to preserve an image and container, you need to
preserve the ``fuego`` and ``fuego-core`` repositories in their same
directories, or docker will get confused.  That is, if you want to
upgrade and create a new docker container, while still preserving the
old container, you should 'git clone' the repositories to a new
directory location in your host filesystem.  Note in this case, that
you should not have both the new container and the old container
running at the same time, as there will be conflicts over TCP port
numbers and other host resources. The old test data (from the other
container) will not be visible along with any new data in the new
container (ie in the Jenkins interface).  However this does provide a
mechanism to preserve your data from previous tests.

Note that Fuego 'run' data is outside of the Jenkins directory, and
stored on the host filesystem in ``fuego-rw/logs``, so this data is always
available even when the docker container is rebuilt.  You should be
careful, however, as Jenkins job IDs will be reused, starting from 1,
for any new jobs executed with a fresh container and instance of
Jenkins.  These may overwrite the result directories from previous
runs, if you re-use the same ``fuego/fuego-rw`` directory.  This is yet
another reason to use new repository directories for a new docker
container build (and Fuego instance).


==================
Fuego versions
==================

Please note that this discussion applies more generally to major Fuego
releases.  For Fuego, and major release is considered one where the
second digit of the version number is the same (the '1' or '2' in 1.1
and 1.2).

If an API-incompatible change occurs within a major release, this is
considered a regression and we will try to fix it.

Our hope is that Fuego is starting to settle down a bit in the 1.2
release, and that API-incompatible changes will be more rare after
that release.
