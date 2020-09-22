.. _sand1:

#############
Sandbox
#############

This page is for testing different elements of reStructuredText markup,
in the Fuego documentation.  This is intended to be used during the
conversion from wiki pages, to make sure all important formatting is
preserved.

##################
Page Level Header
##################

Here is some text

.. _chapheader:

=====================
Chapter Level Header
=====================

Admonition test
---------------

.. admonition:  Custom admonition
   This is some important text!!

Reference test
--------------

test 1
~~~~~~~~

Sandbox2\_

Here is an attempt to refer to a page: `Sandbox2`_

Result:

 * cover text of \`Sandbox2\`\_
 * URL of .../_build/html/Sandbox.html#id1 - FAIL

cover text of


test 2
~~~~~~~~

Pointer to slandbox page1 <sand1>\_

Here is another attemp to refer to a page.
Try to refer to a section on a page, with cover text:
`Pointer to slandbox page1 <sand1>`_

Result:

 * cover text of Pointer to slandbox page1
 * URL of .../_build/html/sand1 - FAIL

test 3
~~~~~~~~

Reference: \:ref\:\`Pointer to slandbox page3 <sndbx2>\`

Here is another way to refer to a section on a page, with cover text:
:ref:`Pointer to slandbox page3 <sndbx2>`

Result from default Ubuntu 16.03 Sphinx:

 * cover text of "Pointer to slandbox page3"
 * NO URL! - FAIL

Result from python3 venv py3-sphinx Sphinx installation:

 * cover text of "Pointer to slandbox page3"
 * URL of .../_build/html/Sandbox2.html#sndbx2 - PASS

test 4
~~~~~~~~

Reference: \:ref\:\`Pointer to slandbox2 page4 <Sandbox2>\`

Here is another way to refer to a section on a page, with cover text:
:ref:`Pointer to slandbox2 page4 <Sandbox2>`

Result:

 * cover text of Pointer to slandbox2 page4
 * NO URL! - FAIL

test 5
~~~~~~~~

Reference \`Pointer to slandbox2 page5 <Sandbox2.html>\`_

Here is another way to refer to a section on a page, with cover text:
`Pointer to slandbox2 page5 <Sandbox2.html>`_

Result:

 * cover text of Pointer to slandbox page5
 * URL = Sandbox2.html - PASS

Conclusion.  There doesn't seem to be a way to refer to a page or a
section heading on a page, unless it is marked with an anchor.
(unless you reference the page with it's .html extension)


test 6
~~~~~~~~

Reference \`Pointer to slandbox2 test6 <chapheader2>\`

Here is another way to refer to a section on a page, with cover text:
:ref:`Pointer to slandbox2 test6 <chapheader2>`

Result:

 * cover text of Pointer to slandbox test6
 * URL = .../_build/html/Sandbox2.html#chapheader2 - PASS

Which ways worked?

 * Test 3 - worked it should have
 * Test 5 -  but it's gross
 * Test 6 - is preferred.

Toctree test
------------

toctrees apparently refer to file (page) names.
The items put into the tree are the section headings from those pages

.. toctree::
   :maxdepth: 2

   Installing_Fuego
   Introduction

Here's another toctree - this time with a caption

.. toctree::
   :maxdepth: 2
   :caption: Important Pages!!

   Installing_Fuego
   Introduction

Following this is a hidden toctree

.. toctree::
   :hidden:

   Installing_Fuego
   Introduction

I can keep doing this all day!!
