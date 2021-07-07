###############
Coding Style
###############

This page described the coding style conventions used in Fuego.

Please adhere to these conventions, so that the code has a more
uniform style and it is easier to maintain.  Not all code in Fuego
adheres to these styles. As we work on code, we will convert it to the
preferred style over time. New code should adhere to the preferred
style.

Fuego code consists mostly of shell script and python code.

===============================
Indentation and line length
===============================

We prefer indentation to be 4 spaces, with no tabs.

It is preferred to keep lines within 80 columns.  However, this is not
strict.  If a string constant causes a line to run over 80 columns,
that is OK.

Some command sequences passed to the 'report' function may be quite
long and require that they be expressed on a single line.  In that
case, you can break them up onto multiple lines using shell
continuation lines.

=======================
Trailing whitespace
=======================

Lines should not end in trailing whitespace.  That is: 'grep " $" \*'
should always be empty.

You can do this with: 'grep -R " $" \*' in the directory you're working
in, and fix the lines manually.

Or, another method, if you're using vim, is to add an autocmd to your
.vimrc to automatically remove whitespace from lines that you edit.

This line in your ~/.vimrc:

::

  autocmd FileType sh,c,python autocmd BufWritePre <buffer> %s/\s\+$//e


automatically removes whitespace from all line endings in shell, C,
and python files that are saved from vim.

Or, a third method of dealing with this automatically is to have git
check for whitespace errors using a configuration option, or a hook.
See

`<https://stackoverflow.com/questions/591923/make-git-automatically-remove-trailing-whitespace-before-committing#592014>`_


Also, script files should not end in blank lines.

=================
Shell features
=================

Shell scripts which run on the device-under-test (DUT or board),
SHOULD restrict themselves to POSIX shell features only.  Do not
assume you have any shell features on the target board outside of
those supported by 'busybox ash'.

Try running the program ``checkbashisms`` on your target-side code, to
check for any non-POSIX constructs in the code.

The code in ``fuego_test.sh`` is guaranteed to run in bash, and may
contain bashisms, if needed.  If equivalent functionality is available
using POSIX features, please use those instead. Please avoid esoteric
or little-known bash features. (Or, if you use such features, please
comment them.)

Another useful tool for checking your shell code is a program called
'ShellCheck'.  See `<https://github.com/koalaman/shellcheck>`_.
Most distributions have a package for ``shellcheck``.

There are a few conventions for avoiding using too many external
commands in shell scripts that execute on the DUT. To check for a
process, use ``ps`` and ``grep``, but to avoid having ``grep`` find
itself, use a wildcard in the search pattern.  Like so: 'ps | grep
[f]oo' (rather than 'ps | grep foo | grep -v grep').


================
Python style
================

Python code (such as parser code, the overlay generator, ftc and other
helper scripts), should be compliant with
`<https://www.python.org/dev/peps/pep-0008/>`_.  As with shell code,
there is a lot of legacy code in Fuego
that is not currently compliant with PEP 8.  We will convert legacy
code to the correct style as changes are made over time.

Here are a few more conventions for Fuego code:

 - Strings consisting of a single character should be declared use single-quotes
 - Strings consisting of multiple characters should declared using double-quotes,
   unless the string contains a double-quote.  In that case, single-quotes should
   be using for quoting, to avoid having to escape the double-quote.

Note that there is a fuego lint test (selftest), called
Functional.fuego_lint.  It only checks a few files at the moment, but
the plan is to expand it to check additional code in the future.
