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
		-p 2222:22 -p 84:84 -p 5000:443 \
		--name test_sshd eg_sshd 
	docker exec -d test_sshd /root/simpleserver.py
	docker exec -d test_sshd openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes | echo -e "CA\n\n\n\n\n\n"

inspect:
	docker port test_sshd 22

test:
	ssh -oStrictHostKeyChecking=no root@127.0.0.1 -p 2222 "ls /"

list:
	echo 'cleanup build launch inspect list'

all: cleanup build launch test
	echo "Done."
