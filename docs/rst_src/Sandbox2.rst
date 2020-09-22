Notice there is no anchor or label before this section heading

These are items from the Sandbox2 page.

#############
Sndbx2
#############

This page header doesn't have the same name as the page.

This page is for testing different elements of reStructuredText markup,
in the Fuego documentation.  This is intended to be used during the
conversion from wiki pages, to make sure all important formatting is
preserved.

##################
Page Level Header2
##################

Here is some text

.. _chapheader2:

=====================
Chapter Level Header2
=====================

Reference test
--------------

Test 1
~~~~~~

Reference: \`Sandbox\`_

Here is how you refer to a page: `Sandbox`_

Result: .../_build/html/Sandbox2.html#id2 - FAIL

Test 2
~~~~~~

Reference: \`Sandbox2\`_

Here is another way to refer to a page: `Sandbox2`_

Result: .../_build/html/Sandbox2.html#id4 - FAIL

Test 3 
~~~~~~

Reference: Sandbox2\_

Here is another way to refer to a page: Sandbox2_

Result:
 * cover = ???
 * URL = .../_build/html/Sandbox2.html#id4 - FAIL

Test 4
~~~~~~~
Description: anchor reference using underscore

Reference: \`Pointer to slandbox page1 \<sand1\>\`_

Here is one way to refer to a section on a page, with cover text:
`Pointer to slandbox page1 <sand1>`_

Result:
 * cover - Pointer to slandbox page1
 * URL - .../_build/html/sand1 - FAIL

Test 4
~~~~~~~
Here is another way to refer to a section on a page, with cover text:

This uses a ref:

Reference: \:ref\:\`Pointer to slandbox page2 \<sand1\>\`

Here is the ref: :ref:`Pointer to slandbox page2 <sand1>`

Result:
 * cover = Pointer to slandbox page2
 * URL = .../_build/html/Sandbox.html#sand1 - PASS

Conclusion:
 * you MUST have an anchor to use a ref
 * only a :ref: gives you the page name (Sandbox.html) and the anchor
   ref (sand1)

Test 3
~~~~~~

Here is one way to refer to a section on a page, with cover text:
This one uses trailing _ and the page name:
`Pointer to slandbox2 page <Sandbox2>`_

Here is one way to refer to a section on a page, with cover text:
This one uses an href and the page name:
`Pointer to slandbox2 page <Sandbox2>`_

Here is another way to refer to a section on a page, with cover text:
This one uses a trailing _ and the section name:
`Pointer to slandbox2 page header <sndbx2>`_

Here is another way to refer to a section on a page, with cover text:
This one uses a ref and the section name:
:ref:`Pointer to slandbox2 page header <sndbx2>`

Which ways worked?

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
   :caption: Important Pages2!!

   Installing_Fuego   
   Introduction

Following this is a hidden toctree

.. toctree::
   :hidden:  

   Installing_Fuego   
   Introduction

I can keep doing this all day!!
