.. _building_documentation:

##########################
Building Documentation
##########################

As of July, 2020, the Fuego documentation is currently available in 3 places:

 * the fuego-docs.pdf generated from TEX files in the fuego/docs/source directory
 * the Fuegotest wiki, located at: `<https://fuegotest.org/wiki/Documentation>`_
 * .rst files in fuego/docs

The fuego-docs.pdf file is a legacy file that is several years old.  It
is only kept around for backwards compatibility.  I might be worthwhile
to scan it and see if any information is in it that is not in the wiki
and migrate it to the wiki.

The fuegotest wiki has the currently-maintained documentation for the
project.  But there are several issues with this documentation:

 - the wiki used is proprietary and slow
 - the information is not well-organized
 - the information is only available online, as separate pages

   - there is no option to build a single PDF, or use the docs offline

 - there is a mixture of information in the wiki

   - not just documentation, but a crude issues tracker, random technical notes
     testing information, release information and other data that should not be
     part of official documentation

The .rst files are intended to be the future documentation source for
the project.

==============================
building the outdated PDF 
==============================

To build the outdated PDF, cd to fuego/docs, and type ::

	 $ make fuego-docs.pdf


This will use latex to build the file fuego/docs/fuego-docs.pdf

===========================
building the RST docs 
===========================

The RST docs can be build in several different formats, including
text, html, and pdf.  You can type 'make help' to get a list of the 
possible build targets for this documentation.  Output is always
directed to a directory under fuego/docs/_build.

Here are some of the most popular targets:

html
======
 
::

  $ make html

Documentation will be in fuego/docs/_build/html

The root of the documentation will be in index.html

singlehtml
============

::

  $ make singlehtml


Documentation will be in fuego/docs/_build/singlehtml

The complete documentation will be in a single file: index.html (with
images and other static content in fuego/docs/_build/singlehtml/_static

latexpdf
=============

::

  $ make latexpdf


Documentation will be in fuego/docs/_build/latexpdf/Fuego.pdf



