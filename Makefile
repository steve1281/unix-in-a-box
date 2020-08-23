# makefile
#

cleanup: cleanup_image
	-ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[127.0.0.1]:2222"

cleanup_container:
	-docker container stop test_sshd
	-docker container rm test_sshd

cleanup_image: cleanup_container
	-docker image rm eg_sshd

build:
	docker build -t eg_sshd .

launch:
	docker run -d \
		-p 2222:22 -p 84:84 -p 5000:443 \
		--name test_sshd eg_sshd 
	docker exec -d test_sshd openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes -subj "/C=CA/ST=./L=./O=./OU=./CN=."
	docker exec -d test_sshd /root/simpleserver.py
	docker exec -d test_sshd /root/sslserver.py

inspect:
	docker port test_sshd 22

test:
	ssh -oStrictHostKeyChecking=no root@127.0.0.1 -p 2222 "/usr/lib/nimbula/zkdeltree"
	curl http://127.0.0.1:84 
	curl -k https://127.0.0.1:5000/ 

list:
	echo 'cleanup build launch inspect list'

all: cleanup build launch 
	echo "Done."
