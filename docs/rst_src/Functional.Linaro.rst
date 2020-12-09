#####################
Functional.Linaro
#####################

================
Description
================

This test can be used to run tests from the Linaro test definition
suite.

As of February, 2019, the test is a proof of concept and only tested
with smoke tests. There are FIXTHIS lines to indicate what is left.

=============
Resources
=============

 * `<https://github.com/Linaro/test-definitions.git>`_

===========
Results
===========


========
Tags
========

 * first tag

================
Dependencies
================

==========
Status
==========

 * Experimental

=========
Notes
=========

Setup
===========

Here are some notes on setting up for this test:

The test definitions only support running on a board via ssh without
using a password.  Therefore, you must provide an SSH_KEY for the
board.


These instructions use the Fuego board 'bbb' as the board for this
s Project source on etup.


Enter the docker container
---------------------------

 * $ fuegosh
 * (at this point, you will be root)
 * $ su jenkins

SSH_KEY
--------------

 * If not done already, prepare ssh keys for your board

   * $ ssh-keygen -t rsa
   * (change the filename to include the board name
     (from id_rsa to bbb_id_rsa)
   * The output should look something like this.

     ::

      Enter file in which to save the key (/var/lib/jenkins/.ssh/id_rsa): /var/lib/.ssh/bbb_id_rsa
      Enter passphrase (empty for no passphrase):
      Enter same passphrase again:
      Your identification has been saved in bbb_id_rsa.
      Your public key has been saved in bbb_id_rsa.pub.
      The key fingerprint is:
      xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx jenkins@timdesk
      The key's randomart image is:
      +---[RSA 2048]----+
      |.(image omitted).|
      +-----------------+

 * Put the ``bbb_id_rsa.pub`` file on the board, in the .ssh
   directory of the account used for testing.

    * This can be done using the tool 'ssh-copy-id', as follows:

      * $ ssh-copy-id -i bbb_id_rsa.pub root@10.0.1.2
        (use the correct login account and IP address)
      * (this will prompt for the password for the root account)

    * You can test this by using ssh, to check that it doesn't
      require a password

      * $ ssh -i bbb_id_rsa root@10.0.1.2
      * (you should be logged in without a request for a password)


 * Install ssh key into the jenkins ssh config file

    * (still inside the docker container, as user 'jenkins')
    * vi ~/.ssh/config

       * Adjust or add a Host section

         * Put the Host line:  Host 10.0.1.2 <- replace with your
           boards ip address ($IPADDR)
         * Put an indented line for the IdentityFile: IdentityFile ``~/.ssh/bbb_id_rsa``


When done, the config should have a section that looks like this:

::

 Host 10.0.1.2
     IdentityFile ~/.ssh/bbb_id_rsa



Jenkins job setup
-----------------------

Now, add a job for ``Functional.linaro`` to Jenkins

  * $ftc add-job -b bbb -t Functional.linaro
  * (this should create the job: ``bbb.default.Functional.linaro``)


Execute the job
-----------------------

 * Execute the job from jenkins, by finding the job in the Jenkins interface,
   and clicking on Build

    - Expected results

    	- Table with each test case and the results (PASS/FAIL/SKIP)
    	- ``run.json``
    	- csv
