# makefile
#
cleanup:
	docker container stop test_sshd
	docker container rm test_sshd
	docker image rm eg_sshd

build:
	docker build -t eg_sshd .

launch:
	docker run -d -P --name test_sshd eg_sshd

inspect:
	docker port test_sshd 22

test:
	ssh root@127.0.0.1 -p 2222 "ls /"

list:
	echo 'cleanup build launch inspect list'
