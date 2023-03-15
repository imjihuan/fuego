.. _sand1:

#############
Sandbox
#############

This page is for testing different elements of reStructuredText markup,
in the Fuego documentation.  This is intended to be used during the
conversion from wiki pages, to make sure all important formatting is
preserved.

#######################
Page Level Header (H1)
#######################

Here is some text

.. _chapheader:

==========================
Chapter Level Header (H2)
==========================

This is the start of a level 2 section

Level 3 header
==============

Does this actually do a level 3 header?

Level 4 header
--------------

Some content here at level 4

Level 5 header
~~~~~~~~~~~~~~

Some content here at level 5

Some Example Markup
====================

Here is a **bold** word, and an *italic* word.
Also here is a ``filename.txt``, and a ``command -a arg``.

Here is a glossary terms: :term:`board`


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

 * cover text of \`Sandbox2\`\_ - Fail, it includes the tics and underscore
 * URL of .../_build/html/Sandbox.html#id1 - FAIL, it's not to Sandbox2.html



test 2
~~~~~~~~

Pointer to slandbox page1 <sand1>\_

Here is another attemp to refer to a page.
Try to refer to a section on a page, with cover text:
`Pointer to slandbox page1 <sand1>`_

Result:

 * cover text of Pointer to slandbox page1 - OK
 * URL of .../_build/html/sand1 - FAIL, it's not to sand1.html

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

test 7
~~~~~~~~

Reference \`Sandbox2\`

Here is a way to refer to a whole page:
:doc:`Sandbox2`

Result:
 * cover text: Sndbx2 - FAIL - this is the name in the first section on the page
 * URL = .../_build/html/Sandbox2.html - PASS

test 8
~~~~~~~~

Reference \`Sandbox2 <Sandbox2>\`

Here is a way to refer to a whole page:
:doc:`Sandbox2 <Sandbox2>`

Result:
 * cover text: Sandbox2 - PASS
 * URL = .../_build/html/Sandbox2.html - PASS

\:doc\: items support cover text

test 9
~~~~~~~~

Reference \`Cover text for Sandbox2 <Sandbox2>\`

Here is a way to refer to a whole page:
:doc:`Cover text for Sandbox2 <Sandbox2>`

Result:
 * cover text: Sandbox2 - PASS
 * URL = .../_build/html/Sandbox2.html - PASS

\:doc\: items support cover text

test 10
~~~~~~~~

Reference \`Cover text for Sandbox2 heading  <test_header>\`

Here is a way to refer to a whole page:
:ref:`Cover text for Sandbox2:test header <test_header>`

Result:
 * cover text: "Cover text for Sandbox2:test header" - PASS
 * URL = no link - FAIL


===================
reference analysis
===================

Sphinx is altogether too tricky when it comes to labels and cover text.
It sometimes uses the section heading text for cover text for a label,
rather than the label text itself, even when no cover text is specified.

This is true for :doc: items.

Which ways worked?

 * Test 5 -  but it's gross
 * Test 6 - is ugly, for works for internal references
 * Test 7 - works, but cover text is unpredictable
 * Test 8,9 - are preferred for reference a whole page

==============
Other tests
==============

Stub heading
=============

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

That's the end of the hiddent toctree.

I can keep doing this all day!!

Here's a literal block, with messed up indenting: ::

  this is a test
  this line should be next to that one
     this one should be indented
        even further indented

now we're done with the literal block

