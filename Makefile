# makefile
#
cleanup:
	-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[127.0.0.1]:2222"
	-docker container stop test_sshd
	-docker container rm test_sshd
	-docker image rm eg_sshd

build:
	docker build -t eg_sshd .

launch:
	docker run -d \
		-p 2222:22 -p 84:84 \
		--name test_sshd eg_sshd 
	docker exec -d test_sshd /scripts/simpleserver.py

inspect:
	docker port test_sshd 22

test:
	ssh -oStrictHostKeyChecking=no root@127.0.0.1 -p 2222 "ls /"

list:
	echo 'cleanup build launch inspect list'

all: cleanup build launch test
	echo "Done."
