# create a docker image we can ssh into
link: https://docs.docker.com/engine/examples/running_ssh_service/

## Create a docker image
```
key note, we are going to allow root login, so sshd_config is modified
also, we need to modify the password. Probably wuld make sense to pass this
in, or set an environment variable. Really depend on how concerned you are with security.

Also, the example uses ubuntu 16.04 - you may want to update that.

See the Dockerfile.
```
## build/tag as usual
```
Note: the first run is going to take a little while. (~5min)

docker build -t eg_sshd .
```

## run it
```
I don't agree with the example in the link; they should map that port.
But this is ok; we can work with it.

$  docker run -d -P --name test_sshd eg_sshd
060e8d41166b929c3a14a0dca6df52ec662bc0eceb1eb93ec45fa0f1dafbb2c8

$ docker port test_sshd 22
0.0.0.0:32768

So, in this particular case, it maps to 127.0.0.1:32768

Note: the link talks about 192.168.1.2.  This will vary based on your setup.
In my current example, my local ip is : 192.168.100.136 

```

## test the result
```
steve@kube:~/projects/docker-tests/unix-in-box$ ssh root@127.0.0.1 -p 32768
The authenticity of host '[127.0.0.1]:32768 ([127.0.0.1]:32768)' can't be established.
ECDSA key fingerprint is SHA256:ejhfwX0tjnoja150pfEvbypwlufQ94NO5nIFVKJeQnM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[127.0.0.1]:32768' (ECDSA) to the list of known hosts.
root@127.0.0.1's password: 
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.
```

## cleanup
```
docker container stop test_sshd
docker container rm test_sshd
docker image rm eg_sshd
```
