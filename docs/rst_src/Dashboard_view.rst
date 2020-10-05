.. _dashboard_view:

################
Dashboard view
################


Here is some information about the main dashboard view in Jenkins, in
Fuego:

=========================
Main screen elements
=========================

If you click on "Jenkins" in the upper left
part of any page in the = web interface, you will be taken to a page
with the following parts:

 * Top of screen are some logos and a search bar
 * A navigation bar below that (with a context trail)
 * A sidebar of the left of the page with:

    * A menu
    * A "Build Queue"
    * A "Build Executor Status"
    * Target status

 * The main job panel, which may consists of several tabs, but
   which will have at least the following:

    * All
    * ``+`` sign

Job dashboard
==============

Each job dashboard shows a list of jobs, with some
information about each one.  The information shows the status of the
last execution of the test associated with the job, as well as a
"weather report", indicating the status of the last few runs.  There
is also information about the last successful run, the duration of the
last run, and so on.

============================
Changing the interface
============================

Create a new view
==================

It is often handyto see just a subset of the jobs
(like those for a particular board,
or those having to do with a specific test area (like filesystems or
networking).

You can create a new view by clicking on the "+" sign, to add a new
tab to the dashboard.  Then entering a name, and selecting the "List
View" button.  Then press the "OK" button.

At this point you can customize the view.  The most important thing in
creating a new view is selecting which jobs to show in the view.  You
can select specific jobs by name, or use a regular expression to
select the jobs to display.  If you wanted to create a view that
showed all the jobs related to your board 'myboard', you could create
a view called 'myboard', and under "Job Filters",  check the checkbox
labeled: "User a regular expression to include jobs into the view".
Then add a regular expression like: 'myboard.*"

Click OK to save your view, and it should show up as a new tab in the
dashboard view.

Edit an existing view
=======================

To see the configuration for each view,
select the tab you want to view/edit, and select "Edit View" in the
left sidebar menu.

For each Dashboard view you can set:

 * Name, Description
 * Job Filters

   * You can select individual tests, or use a regular expression to
     include tests in the view

 * Columns

  * You can add or remove columns, or reorder the columns

     * Default columns:

       * Status
       * Weather
       * Name
       * Last Success
       * Last Failure
       * Last Duration
       * Build Button

   * To remove a column, press the button labeled "Delete"
   * To reorder columns, hover your mouse over the column name, then
     click and drag the column to the position you would like it, in
     the list of columns.
