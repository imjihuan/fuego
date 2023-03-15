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

===========
test header
===========
Here is some material under the first header

########################
Page Level Header2 (H1)
########################

Here is some text

.. _chapheader2:

=====================
Chapter Level Header2
=====================

Stub header (h3)
=================

Reference test
--------------

Test2 1
~~~~~~~

Reference: \`Sandbox\`_

Here is how you refer to a page: `Sandbox`_

Result: .../_build/html/Sandbox2.html#id4 - FAIL

Test2 2
~~~~~~~

Reference: \`Sandbox2\`_

Here is another way to refer to a page: `Sandbox2`_

Result: .../_build/html/Sandbox2.html#id6 - FAIL

Test2 3
~~~~~~~

Reference: Sandbox2\_

Here is another way to refer to a page: Sandbox2_

Result:
 * cover = ???
 * URL = .../_build/html/Sandbox2.html#id8 - FAIL

Test2 4
~~~~~~~
Description: anchor reference using underscore

Reference: \`Pointer to slandbox page1 \<sand1\>\`_

Here is one way to refer to a section on a page, with cover text:
`Pointer to slandbox page1 <sand1>`_

Result:
 * cover - Pointer to slandbox page1
 * URL - .../_build/html/sand1 - FAIL

Test2 5 
~~~~~~~~
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

Test2 more
~~~~~~~~~~~~

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

