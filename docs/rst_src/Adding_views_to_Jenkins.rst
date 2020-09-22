.. _addingViewstoJenkins:


#########################
Adding views to Jenkins
#########################

It is useful to organize your Jenkins test jobs into "views".  These
appear as tabs in the main Jenkins interface. Jenkins always provides
a tab that lists all of the installed jobs, call "All".  Other views
that you create will appear on tabs next to this, on the main Jenkins
page.

You can define new Jenkins views using the Jenkins interface, but
Fuego provides a command that allows you to easily create views for
boards, or for sets of related tests (by name and wildcard), from the
Linux command line (inside the container).

The usage line for this command is: ::

  Usage: ftc add-view <view-name> [<job_spec>]


The view-name parameter indicates the name of the view in Jenkins, and
the job-spec parameter is used to select the jobs which appear in that
view.

If the job_spec is provided and starts with an '=', then it is
interpreted as one or more specific job names.  Otherwise, the view is
created using a regular expression statement that Jenkins uses to
select the jobs to include in the view.

======================
Adding a board view 
======================

By convention, most Fuego users populate their Jenkins interface with
a view for each board in their system (well, for labs with a small
number of boards, anyway).

The simplest way to add a view for a board is to just specify the
board name, like so: ::

  (container_prompt)$ ftc add-view myboard


When no job specification is provided, the 'add-view' command
will create one by prefixing the view name with
wildcards.  For the example above, the job spec would consist
of the regular expression ".*myboard.*".

Customizing regular expressions
==================================

Note that if your board name is not unique enough, or is a string
contained in some tests, then you might see some test jobs listed that
were not specific to that board.  For example, if you had a board name
"Bench", then a view you created with the view-name of "Bench", would
also include Benchmarks.  You can work around this by specifying a
more details regular expression for your job spec.

For example: ::

  (container_prompt)$ ftc add-view Bench "Bench.*"


This would only include the jobs that started with "Bench" in the
"Bench" view.  Benchmark jobs for other boards would not be included,
since they only have "Benchmark" somewhere in the middle of their job
name - not at the beginning.

===============================================
Add view by test name regular expression
===============================================

This command would create a view to show LTP results for multiple
boards: ::

 (container_prompt)$ ftc add-view LTP

This example creates a view for "fuego" tests. This view
would include any job that has the word "fuego" as part of it.
By convention, all Fuego self-tests have part of their name
prefixed with  *"fuego_"*.  ::


  (container_prompt)$ ftc add-view fuego ".*fuego_.*"


And the following command will show all the batch jobs defined in the
system: ::

  (container_prompt)$ ftc add-view .*.batch



======================
Add specific jobs
======================

If the job specification starts with "=", it is a comma-separated
list of job names.  The job names must be complete, including the
board name, spec name and full test name. ::


  (container_prompt)$ ftc add-view network-tests =docker.default.
  Functional.ipv6connect,docker.default.Functional.netperf


In this command, the view would be named "network-tests", and it would
show the jobs "docker.default.Functional.ipv6connect" and
"docker.default.Functional.netperf".




