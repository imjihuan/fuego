.. _lincense_and_contribution_policy:


##########################################
License And Contribution Policy
##########################################

===============
License
===============

Fuego has the following license policy.

Fuego consists of several parts, and includes source code from a
number of different external test projects.

Default license
==================

The default license for Fuego is the BSD 3-Clause license, as
indicated in the LICENSE file at the top of the 'fuego' and
'fuego-core' source repositories.

If a file does not have an explicit license, or license indicator
(such as SPDX identifier) in the file, than that file is covered by
the default license for the project, with the exceptions noted below
for "external test materials".

When making contributions, if you do NOT indicate an alternative
license for your contribution, the contribution will be assigned the
license of the file to which the contribution applies (which may be
the default license, if the file contains no existing license
indicator).

Although we may allow for other licenses within the Fuego project
in order to accommodate external software added to our system, our
preference is to avoid the proliferation of licenses in the Fuego
code itself.

External test materials
----------------------------

Individual tests in Fuego consist of files in the directory:
engine/tests/<test_name> (which is known as the test home directory),
and may include two types of materials:

 1. Fuego-specific files
 2. files obtained from external sources, which have their own
    license.

The Fuego-specific materials consist of files such as:
``fuego_test.sh``, ``spec.json``, ``criteria.json``, ``test.yaml``,
``chart_config.json``, and possibly others as created for use in the
Fuego project.  External test materials may consist of tar files, helper
scripts and patches against the source in the tar files.

Unless otherwise indicated, the Fuego-specific materials are
licensed under the Fuego default license, and the external test
materials are licensed under their own individual project
license - as indicated in the test source.

In some cases, there is no external source code, but only source that
is originally written for Fuego and stored in the test home directory.
This commonly includes tests based on a single shell script, that is
written to be deployed to the Device Under Test by ``fuego_test.sh``.
Unless otherwise indicated, these files (source and scripts) are
licensed under the Fuego default license.

If there is any ambiguity in the category of a particular file
(external or Fuego-specific), please designate the intended license
clearly in the file itself, when making a contribution.

Copyright statements
======================

Copyrights for individual contributions should be added to individual
files, when the contributions warrant copyright assignment.  Some
trivial fixes to existing code may not need to have copyright
assignment, and thus not every change to a file needs to include a
copyright notice for the contributor.

License tags
=============

Our preference is to use SPDX license identifier, rather than a
license notice, to indicate the license of any materials in Fuego.
Such identifiers and notices are only desired if the materials are not
contributed under the default Fuego license of "BSD-3-Clause".

In a test.yaml, please indicate the license of the upstream
test program.  If there is no upstream test program (ie, the
test is self-contained), please specify the license of the Fuego
test definition itself.

Please see `<https://spdx.org/licenses/>`_ for a list of SPDX license
tags

Contributor agreement
========================

The Fuego project does not require a signed Contributor License
Agreement for contribution to the project. Instead, we utilize
the following Developer Certificate of Origin that was copied
from the Linux kernel.

Each contribution to Fuego must be accompanied by a
Signed-off-by line in the patch or commit description, which
indicates agreement to the following: ::


	By making a contribution to this project, I certify that:

		      (a) The contribution was created in whole or in
                          part by me and I have the right to submit it
                          under the open source license indicated in
                          the file; or

		      (b) The contribution is based upon previous work
                          that, to the best of my knowledge, is
                          covered under an appropriate open source
		          license and I have the right under that
                          license to submit that work with
                          modifications, whether created in whole or
                          in part by me, under the same open source
                          license (unless I am permitted to submit
                          under a different license), as indicated
		          in the file; or

		      (c) The contribution was provided directly to me
                          by some other person who certified (a), (b)
                          or (c) and I have not modified it.

		      (d) I understand and agree that this project and
                          the contribution are public and that a
                          record of the contribution (including all
		          personal information I submit with it,
                          including my sign-off) is maintained
                          indefinitely and may be redistributed
                          consistent with this project or the open
                          source license(s) involved.


*Note*: Please note that an "official" DCO at the web site
`<https://developercertificate.org/>`_  has additional text
(an LF copyright, address, and statement of non-copyability).All of
these are either nonsense or problematical in some legalsense.
The above is a quote of a portion of the document found in the
Linuxkernel guide for submitting patches.  See
`<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/Documentation/process/submitting-patches.rst>`_
(copied in March, 2018).

Each commit must include a DCO which looks like this ::


    Signed-off-by: Joe Smith <joe.smith@email.com>


The project requires that the name used is your real name. Neither
anonymous contributors nor those utilizing pseudonyms will be accepted.

You may type this line on your own when writing your commit messages.
However, Git makes it easy to add this line to your commit messages.
Make sure the user.name and user.email are set in your git configs.
Use '-s' or '--signoff'
options to 'git commit' to add the Signed-off-by line to the end of
the commit message.

==========================
Submitting contributions
==========================

Please format contributions as a patch, and send the patch to the
`Fuego mailing list <https://lists.linuxfoundation.org/mailman/
listinfo/fuego>`_

Before making the patch, please verify that you have followed our
preferred :ref:`Coding style <coding_style>`.

We follow the style of patches used by the Linux kernel, which is
described here: `<https://www.kernel.org/doc/html/latest/process/
submitting-patches.html>`_

Not everything described there applies, but please do the following:
 - used a Signed-off-by line
 - send patch in plain text
 - include PATCH in the subject line
 - number patches in a series (1/n, 2/n, .. n/n)
 - patch subject should have: "subsystem: description"

   - in the case of modifications to a test, the subject should have:
     "test: description"  (that is, the test is the subsystem name)

   - the test name can be the short name, if it is unambiguous

     - That is, please don't use the 'Functional' or 'Benchmark'
       prefix unless there are both types of tests with the same
       short name

 - describe your changes in the commit message body

Creating patches
===================

If you use git, it's easy to create a patch (or patch series),
using 'git format-patch'. Or, you can go directly to e-mailing
a patch or patch series using 'git send-email'

Alternative submission method
================================

I also allow patches as attachments to an e-mail to the list.
This is something NOT supported by the Linux kernel community.

If the patch is too big (greater than 300K), then please add it
to a public git repository, and let me know the URL for the
repository.  I can add a remote for the repo, and fetch it and
cherry pick the patch.  I prefer doing a fetch and cherry-pick
to a pull request.

While I will sometimes process patches through a repo, it is
strongly preferred for patches to go through the mailing list
as plain text, so that community members can review the patch
in public.
