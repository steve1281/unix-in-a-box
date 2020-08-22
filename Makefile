# makefile
#
cleanup:
	-docker container stop test_sshd
	-docker container rm test_sshd
	-docker image rm eg_sshd

build:
	docker build -t eg_sshd .

launch:
	docker run -d -p 2222:22 --name test_sshd eg_sshd

inspect:
	docker port test_sshd 22

test:
	-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[127.0.0.1]:2222"
	ssh -oStrictHostKeyChecking=no root@127.0.0.1 -p 2222 "ls /"

list:
	echo 'cleanup build launch inspect list'

all: cleanup build launch test
	echo "Done."
