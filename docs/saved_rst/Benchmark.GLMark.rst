###################
Benchmark.GLMark
###################

===============
Description
===============

GLMark is a test to determine the performance of OpenGL on your
system.  The program runs a series of tests rendering 2D and 3D
graphics and animations, and provides a benchmark result indicating
the number of frames per second for each operation.  The it averages
the different results to generate a score for the GPU.

=============
Resources
=============


 * `Benchmark graphics card (GPU) performance on Linux with glmark <http://www.binarytides.com/glmark-linux-gpu-performance/>`_,
   by Silver Moon, Binary Tides, April 2014

 * Newer version: glmark2 - see
   `<https://github.com/glmark2/glmark2>`_
 * `Simple DirectMedia Layer wikipedia entry <https://en.wikipedia.org/wiki/Simple_DirectMedia_Layer>`_

===========
Results
===========

========
Tags
========

 * Graphics

================
Dependencies
================


 * It requires the following development libraries:

   * sdl: libsdl1.2-dev
   * gl: libgl1-mesa-dev
   * glu: libglu1-mesa-dev
   * glew: libglew1.5-dev

==========
Status
==========

 * CAN'T BUILD

=========
Notes
=========

Compiling for minnowboard inside Docker container, I get lots of
errors saying that structure members are private.  Possibly this is
due to more stringent error checking by gcc, or some cflag that is
missing.

All errors are reported from vector.h, included in various cpp files.

On other platforms, the required libraries (SDL) are often not
available at build or run time.

