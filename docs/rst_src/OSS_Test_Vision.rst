.. _oss:

#################
OSS Test Vision
#################

This page describes aspects of the Open Source Test vision for the
Fuego project, along with some ideas for implementing specific ideas
related to this vision.

=====================
overview of concepts
=====================


Letter to ksummit discuss
==========================

Here's an e-mail Tim sent to the ksummit-discuss list in October,
2016 ::

	I have some ideas on Open Source testing that I'd like to
        throw out there for discussion.  Some of these I have been
	stewing on for a while, while some came to mind after talking
	to people at recent conference events.

	Sorry - this is going to be long...

	First, it would be nice to increase the amount of testing we
        do, by having more test automation. (ok, that's a no-brainer).
        Recently there has been a trend towards more centralized
        testing facilities, like the zero-day stuff or board farms
        used by kernelci. That makes sense, as this requires
 	specialized hardware, setup,  or skills to operate certain
	kinds of test environments.  As one example, an automated test
	of kernel boot requires automated control of power to a board
 	or platform, which is not very common among kernel developers.
	A centralized test facility has the expertise and hardware to
	add new test nodes relatively cheaply. They can do this more
	quickly	and much less expensively than the first such node by
	an individual new to testing.

	However, I think to make great strides in test quantity and
        coverage, it's important to focus on ease of use for
 	individual test nodes. My vision would be to have tens of
	thousands of individual test nodes running automated tests on
	thousands of different hardware platforms and configurations
        and workloads.

	The kernel selftest project is a step in the right direction
	for this, because it allows any kernel developer to easily
	(in theory) run automated unit tests for the kernel.  However,
        this is still a manual process.  I'd like to see improved
        standards and infrastructure for automating tests.

	It turns out there are lots of manual steps in the testing
	and bug-fixing process with the kernel (and other
 	Linux-related software).  It would be nice if a new system
	allowed us to capture manual steps, and over time convert
	them to automation.

	Here are some problems with the manual process that I think
	need addressing:

	1) How does an individual know what tests are valid for their
	platform? Currently, this is a manual decision.  In a world
        with thousands or tens of thousands of tests, this will be
        very difficult.  We need to have automated mechanisms to
        indicate which tests are relevant for a platform.Test
	definitions should include a description of the hardware
	they need,or the test setup they need.  For example, it would
	be nice to have tests indicate that they need to be run on a
	node with USB gadget support,
	or on a node with the gadget hardware from a particular vendor
        (e.g. a particular SOC), or with a particular hardware phy
 	(e.g. Synopsis).  As another example, if a test requires that
        the hardware physically reboot,then that should be indicated
        in the test.  If a test requires that a particular button be
        pressed (and that the button be available to be pressed), it
	should be listed.  Or if the test requires that an external
	node be available to participate in the test (such as a wifi
        endpoint, CANbus endpoint, or
	i2C device) be present, that should be indicated.
	There should be a way for the test nodes which provide those
 	hardware capabilities, setups, or external resources to
        identify themselves.  Standards should
	be developed for how a test node and a test can express these
	capabilities and requirements.  Also, standards need to be
        developed so that a test can control those external resources
	to participate in tests.Right now each test framework handles
	this in its own way (if it provides
	support for it at all).

	I heard of a neat setup at one company where the video
	output from a system was captured by another video system,
	and the results analyzed automatically.  This type of test
	setup currently requires an enormous investment of
	expertise, and possibly specialized hardware.  Once such a
	setup is performed in a few locations, it makes much more
	sense to direct tests that need such facilities to those
	locations, than it does to try to spread the expertise to
	lots of different individuals (although that certainly has
	value also).

	For a first pass, I think the kernel CONFIG variables needed
	by a test should be indicated, and they could be compared
	with the config for the device under test.  This would be a
	start on the expression of the dependencies between a test
	and the features of the test node.

	2) how do you connect people who are interested in a
	particular test with a node that can perform that test?

	My proposal here is simple - for every subsystem of the
	kernel, put a list of test nodes in the MAINTAINERS file, to
	indicate nodes that are available to test that subsystem.
	Tests can be scheduled to run on those nodes, either
	whenever new patches are received for that sub-system, or
	when a bug is encountered and developers for that subsystem
	want to investigate it by writing a new test.  Tests or data
	collection instructions that are now provided manually would
	be converted to formal test definitions, and added to a
	growing body of tests.  This should help people re-use test
	operations that are common.  Capturing test operations that
	are done manually into a script would need to be very easy
	(possibly itself automated), and it would need to be easy to
	publish the new test for others to use.

	Basically, in the future, it would be nice if when a person
	reported a bug, instead of the maintainer manually walking
	someone through the steps to identify the bug and track down
	the problem, they could point the user at an existing test
	that the user could easily run.

	I imagine a kind of "test app store", where a tester can
	select from thousands of tests according to their interest.
	Also, people could rate the tests, and maintainers could
	point people to tests that are helpful to solve specific
	problems.

	3) How does an individual know how to execute a test and how
	to interpret the results?

	For many features or sub-systems, there are existing tools
	(e.g bonnie for filesystem tests, netperf for networking
	tests, or cyclictest for realtime), but these tools have a
	variety of options for testing different aspects of a
	problem or for dealing with different configurations or
	setups.  Online you can find tutorials for running each of
	these, and for helping people interpret the results. A new
	test system should take care of running these tools with the
	proper command line arguments for different test aspects,
	and for different test targets ('device-under-test's).

	For example, when someone figures out a set of useful
	arguments to cyclictest for testing realtime on a beaglebone
	board, they should be able to easily capture those arguments
	to allow another developer using the same board to easily
	re-use those test parameters, and interpret the cylictest
	results, in an automated fashion.  Basically we want to
	automate the process of finding out "what options do I use
	for this test on this board, and what the heck number am I
	supposed to look at in this output, and what should its
	value be?".

	Another issue is with interpretation of test results from
	large test suites.  One notorious example of this is LTP.
	It produces thousands of results, and almost always produces
	failures or results that can be safely  ignored on a
	particular board or in a particular environment. It requires
	a large amount of manual evaluation and expertise to
	determine which items to pay attention to from LTP.  It
	would be nice to be able to capture this evaluation, and
	share it with others with either the same board, or the same
	test environment, to allow them to avoid duplicating this
	work.

	Of course, this should not be used to gloss over bugs in LTP
	or bugs that LTP is reporting correctly and actually need to
	be paid attention to.

	4) How should this test collateral be expressed, and how
	should it be collected, stored, shared and re-used?

	There are a multitude of test frameworks available.  I am
	proposing that as a community we develop standards for test
	packaging which include this type of information (test
	dependencies, test parameters, results interpretation).  I
	don't know all the details yet.  For this reason I am coming
	to the community see how others are solving these problems
	and to get ideas for how to solve them in a way that would
	be useful for multiple frameworks.  I'm personally working
	on the Fuego test framework - see http://fuegotest.org/wiki,
	but I'd like to create something that could be used with any
	test framework.

	5) How to trust test collateral from other sources (tests,
	interpretation)

	One issue which arises with this type of sharing (or with
	any type of sharing) is how to trust the materials involved.
	If a user puts up a node with their own hardware, and trusts
	the test framework to automatically download and execute a
	never-before-seen test, this creates a security and trust
	issue.  I believe this will require the same types of
	authentication and trust mechanisms (e.g. signing,
	validation and trust relationships) that we use to manage
	code in the kernel.

	I think this is more important than it sounds.  I think the
	real value of this system will come when tens of thousands
	of nodes are running tests where the system owners can
	largely ignore the operation of the system, and instead the
	test scheduling and priorities can be driven by the needs of
	developers and maintainers who the test node owners have
	never interacted with.

	Finally, 6) What is the motivation for someone to run a test
	on their hardware?

	Well, there's an obvious benefit to executing a test if you
	are personally interested in the result.  However, I think
	the benefit of running an enormous test system needs to be
	de-coupled from that immediate direct benefit.  I think we
	should look at this the same way  we look at other
	crowd-sourced initiatives, like Wikipedia.  While there is
	some small benefit for someone producing an individual page
	edit, we need to move beyond that to the benefit to the
	community of the cumulative effort.

	I think that if we want tens of thousands of people to run
	tests, then we need to increase the cost/benefit ratio for
	the system.  First, you need to reduce the cost so that it
	is very cheap, in all of [time|money|expertise| ongoing
	attention], to set up and maintain a test node.  Second,
	there needs to be a real benefit that people can measure
	from the cumulative effect of participating in the system.
	I think it would be valuable to report bugs found and fixed
	by the system as a whole, and possibly to attribute positive
	results to the output provided by individual nodes.  (Maybe
	you could 'game-ify' the operation of test nodes.)

	Well, if you are still reading by now, I appreciate it.  I
	have more ideas, including more details for how such a
	system might work, and what types of things it could
	accomplish. But I'll save that for smaller groups who might
	be more directly interested in this topic.

	To get started, I will begin working on a prototype of a
	test packaging system that includes some of the ideas
	mentioned here: inclusion of test collateral, and package
	validation.  I would also like to schedule a "test summit"
	of some kind (maybe associated with ELC or Linaro Connect,
	or some other event), to discuss standards in the area I
	propose.

	I welcome any response to these ideas.  I plan to discuss
	them at the upcoming test framework mini-jamboree in Tokyo
	next week, and at Plumbers (particularly during the 'testing
	and fuzzing' session) the week following.  But feel free to
	respond to this e-mail as well.

	Thanks.
	-- Tim Bird


=============================
Ideas related to the vision
=============================


Capturing tests easily
========================

 * should be easy to capture a command line sequence, and test the
   results
 * maybe do an automated capture and format into a clitest file that
   can be used at a here document inside a fuego test script?

==================
test collateral
==================

 * does it need to be board-specific
 * elements of test collateral:

   * test dependencies:

     * kernel config values needed
     * kernel features needed:

       * proc filesystem
       * sys filesystem
       * trace filesystem
     * test hardware needed
     * test node setup features

       * ability to reboot the board
       * ability to soft-reset the board
       * ability to install a new kernel
     * presence of certain programs on target

       * bc
       * top, ps, /bin/sh, bash?
 * already have:

    * CAPABILITIES?
    * pn and reference logs
    * positive and negative result counts (specific to board)
    * test specs indicate parameters for the test
    * test plans indicate different profiles (method to match test to
      test environment - e.g. filesystem test with type of filesystem
      hardware)

=================
test app store
=================

 * need a repository where tests can be downloaded

   * like Jenkins plugin repository
   * like debian package feed

 * need a client for browsing tests, installing tests, updating tests
 * store a test in github, and just refer to different tests in
   different git repositories?
 * test ratings
 * test metrics (how many bugs found)

======================
authenticating tests
======================

 * need to prevent malicious tests
 * packages should be signed by an authority, after review by someone

   * who? the Fuego maintainers?  This would turn into a bottleneck

======================
test system metrics
======================

 * number of bugs found and fixed in upstream software
 * number of bugs found and fixed in test system
 * bug categories (See :ref:`Metrics <metrics>`)




