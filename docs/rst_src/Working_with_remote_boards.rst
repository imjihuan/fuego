.. _working_with_remote_boards:

###################################
Working with remote boards
###################################

Here are some general tips for working with remote boards (that is,
boards in remote labs)

==========================
using a jump server
==========================

If you have an SSH jump server, then you can access machine directly
in another lab, using the ssh ProxyCommand in the host settings for a
board.

I found this page to be helpful:
`<https://www.tecmint.com/access-linux-server-using-a-jump-host/>`_

You should try to make each leg of the jump (from local machine to
jump server, and from jump server to remote machine) password-less.

I found that if my local machine's public key was in the remote
machine's authorized keys file, then I could log in without a
password, even if the jump server's public key was not in the remote
machine's authorized keys file.

==================================
Using ttc transport remotely
==================================

If you have a server that already has ttc configured for a bunch of
board, you can accomplish a lot just by referencing ttc commands on
that server.

For example, in your local ttc.conf, you can put: ::

	PASSWORD=foo
	USER=myuser
	SSH_ARGS=-o UserKnownHostsFile=/dev/null -o
        StrictHostKeychecking=no -o LogLevel=QUIET

	pos_cmd=ssh timdesk ttc %%(target)s pos
	off_cmd=ssh timdesk ttc %%(target)s off
	on_cmd=ssh timdesk ttc %%(target)s on
	reboot_cmd=ssh timdesk ttc %%(target)s reboot

	login_cmd=sshpass -p %%(PASSWORD)s ssh %%(SSH_ARGS)s -x
        %%(USER)s@%%(target)s
	run_cmd=sshpass -p %%(PASSWORD)s ssh %%(SSH_ARGS)s -x
        %%(USER)s@%%(target)s "$COMMAND"
	copy_to_cmd=sshpass -p %%(PASSWORD)s scp %%(SSH_ARGS)s
        $src %%(USER)s@%%(target)s:/$dest
	copy_from_cmd=sshpass -p %%(PASSWORD)s scp %%(SSH_ARGS)s
        %%(USER)s@%%(target)s:/$src $dest


Please note that 'ttc status <remote-board>' does not work with ttc
version 1.4.4.  This is due to internal usage of %%(ip_addr)s in the
function network_status(), which will not be correct for the
remote-board.

=============================================================
setting up ssh ProxyCommand in the Fuego docker container
=============================================================

Please note that tests in Fuego are executed inside the docker
container as user 'jenkins'.

In order to set up password-less operation, or use of a jump server or
ProxyCommand, you have to add appropriate items (config and keys) to:
/var/lib/jenkins/.ssh

Please note that this may make your docker container a security risk,
as it may expose your private keys to tests.  Please use caution when
adding private keys or other sensitive security information to the
docker container.






