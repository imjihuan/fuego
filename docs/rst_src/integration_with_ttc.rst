.. _integration_with_ttc:

############################
Integration with ttc
############################

This page describes how to use Fuego with ``ttc``.  ``ttc`` is a tool
used for manual and automated access to and manipulation of target
boards.  It is a tool developed by Tim Bird and used at Sony for
managing their board farms, and for doing kernel development on multiple
different target boards at a time (including especially boards with
different processors and architectures.)

This page describes how ``ttc`` and Fuego are integrated, so that the
Fuego test framework can use ``ttc`` as it's transport mechanism.

You can find more information about ``ttc`` on the embedded Linux wiki
at: http://elinux.org/Ttc_Program_Usage_Guide

========================================
Outline of supported functionality
========================================

Here is a rough outline of the support for ``ttc`` in Fuego:

 * Integration for the tool and helper utilities in the container
   build

   * When the docker container is built, ``ttc`` is downloaded
     from Github and installed into the Docker image.
   * During this process, the path to the ``ttc.conf`` file is changed
     from ``/etc/ttc.conf`` to ``/fuego-ro/conf/ttc.conf``

 * ``ttc`` is a valid transport option in Fuego

   * You can specify ``ttc`` as the 'transport' for a board, instead of
     ``ssh``

 * ``ttc`` added support for ``-r`` as an option to the ``ttc cp`` command

   * This is required since Fuego uses ``-r`` extensively to do recursive
     directory copies (See :ref:`Transport_notes <transport_notes>`
     for details)

 * The Fuego core scripts have been modified to avoid using wildcards on
   ``get`` operations

 * A new test called ``Functional.fuego_transport`` has been added

   * This tests use of wildcards, multiple files and directories and
     directory recursion with the Fuego ``put`` function.
   * It also indirectly tests the ``get`` function (the other major
     Fuego transport function), because logs are obtained during the test.


==========================
Supported operations
==========================

``ttc`` has several sub-commands.  Fuego currently only uses the following
``ttc`` sub-commands:

 * ``ttc run`` - to run a command on the target
 * ``ttc cp`` - to get a file from the target, and to put files to the
   target

Note that some other commands, such as ``ttc reboot`` are not used, in
spite of there being similar functionality provided in fuego (see
:ref:`function target reboot <func_target_reboot>` and :ref:`function
ov rootfs reboot <func_ov_rootfs_reboot>`).

Finally, other commands, such as ``ttc get_kernel``, ``ttc get_config``,
``ttc kbuild``  and ``ttc kinstall`` are not used currently.  These may be
used in the future, when Fuego is expanded to have a focus on tests
that require kernel rebuilding.

========================
Location of ttc.conf
========================

Normally, ``ttc`` on a host uses the default configuration file at
``/etc/ttc.conf``.  Fuego modifies the ``ttc`` installed inside the
Fuego docker container, so that it uses the configuration
file located at ``/fuego-ro/conf/ttc.conf`` as its default.

During Fuego installation, ``/etc/ttc.conf`` is copied to
``/fuego-ro/conf`` from the host machine, if it is present (and a copy
of ``ttc.conf`` is not already there).

========================================
Steps to use ttc with a target board
========================================

Here is a list of steps to set up a target board to use ``ttc``.
These steps assume you have already added a board to fuego
following the steps described in :ref:`Adding a board <adding_board>`.

 * If needed, create your Docker container using ``docker-create-usb-
   privileged-container.sh``

    * This may be needed if you are using ``ttc`` with board controls
      that require access to USB devices (such as the Sony debug board)

    * Use the ``--priv`` option with ``install.sh``, as documented in
      :ref:`Installing Fuego <priv_option>`.

 * Make sure that ``fuego-ro/conf/ttc.conf`` has the definitions required
   for your target board

   * Validate this by doing ``ttc list`` to see that the board is
     present, and ``ttc run`` and ``ttc cp`` commands, to test that these
     operations work with the board, from inside the container.

 * Edit the fuego board file (found in ``/fuego-ro/conf/boards
   /{board_name}.board``)

   * Set the ``TRANSPORT`` to "ttc"
   * Set the ``TTC_TARGET`` variable to the name for the target
     used by ``ttc``
   * See the following example, for a definition for a target named
     'bbb' (for my Beaglebone black board)::


	TRANSPORT=ttc
	TTC_TARGET=bbb

===========================
modify your copy_to_cmd
===========================

In your ``ttc.conf file``, you may need to make changes to the
``copy_to_cmd`` definitions for boards used by Fuego.  Fuego allows
programs to pass a ``-r`` argument to its internal ``put`` command,
which in turn invokes ``ttc``'s ``cp`` command, with the source as
target and destination as the host.  In other words, it ends up
invokings ``ttc``'s ``copy_from_cmd`` for the indicated target.

All instances of ``copy_to_cmd`` should be modified to reference a new
environment variable ``$copy_args``, and they should support the use
of ``-r`` in the command arguments.

Basically, if a Fuego test uses ``put -r`` at any point, this needs to
be supported by ``ttc``.  ``ttc`` will pass any '-r' seen to the
subcommand in the environment variable ``$copy_args``, where you can use
it as needed with whatever sub-command (``cp``, ``scp``, or something
else) that you use to execute a ``copy_to_cmd``.

See ``ttc.conf.sample`` and ``ttc.conf.sample2`` for usage examples.
