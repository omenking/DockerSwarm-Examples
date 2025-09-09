# End-to-End Pipeline

## Preq

```sh
sudo pip install ansible
```

> Install Ansible via python because you'll get the latest version, sudo will make it global

If you're on Ubuntu for local machine you'll need pipx because you cant globally install with sudo to not conflict with apt

```sh
sudo apt install pipx
pipx ensurepath
pipx install --force ansible-core
pipx inject ansible-core boto3 botocore
```

```sh
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install amazon.aws --upgrade
```

> Make sure you are using at least 10 of amazon.aws, maybe force an update

```sh
ansible-galaxy collection install community.docker
```

https://galaxy.ansible.com/ui/repo/published/amazon/aws/docs/?extIdCarryOver=true&sc_cid=RHCTG0180000371695

##  Build and Push to Container Registery

We will want to build our production docker images locally
and then push them to our container registry.

```sh
./bin/build
```

## Provision Virtual Machine

Provision a virtual machine

```sh
./bin/provision
```

## Bootstrap with Docker Swarm

We'll bootstrap our server to be able to run a cluster
- Install AWS CLI
- Install Docker
- Ensure Docker Sudoless
- Initialize Docker Swarm

```sh
./bin/bootstrap
```


## Deploy Workload

This will deploy the docker-compose.pro-debug.yml
It will run it on the service since we need to pull images
on the server

```sh
./bin/stack-deploy
```

## Configure Docker Context For Remote Swarm

We will want to control our swarm from our local machine.
We'll update our ssh configure and create a docker context.

## Check if Swarm is initialized

```sh
docker info
docker node ls
```

## Add Workers (optional)

```sh
docker swarm join --token SWMTKN-1-4rb45ztk15xu3002m33bpiwjgv78xbjluw1ge6qqz7de1x2f78-bbq7kotpx5snft5hzpbcza6mi 172.31.35.54:2377
```

## Create Docker Compose

docker-compose.yml

```sh
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    configs:
      - source: nginx_config
        target: /etc/nginx/nginx.conf
    deploy:
      replicas: 1

  web:
    image: nginx:alpine
    configs:
      - source: web_html
        target: /usr/share/nginx/html/index.html
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s

configs:
  nginx_config:
    file: ./nginx.conf
  
  web_html:
    file: ./index.html

networks:
  default:
    driver: overlay
```

nginx.conf

```txt
events { worker_connections 1024; }
http {
  upstream web_app { server web:80; }
  server {
    listen 80;
    location / {
      proxy_pass http://web_app;
      proxy_set_header Host $host;
    }
  }
}
```

```html
<!DOCTYPE html>
<html>
<head><title>Docker Swarm Test</title></head>
<body>
  <h1>Hello from Docker Swarm!</h1>
  <p>Container: <span id="id"></span></p>
  <script>
    document.getElementById('id').textContent = 'web-' + Math.random().toString(36).substr(2, 5);
  </script>
</body>
</html>
```

## Commands

```sh
docker stack services demo
docker service ls
docker stack ps demo
docker service logs demo_web
docker service logs -f demo_web
docker service logs demo_nginx
docker service inspect demo_web
docker node ls
# Should return "OK" if nginx is working
curl http://localhost:8080/health  # if you added health endpoint
# OR just test the main site
curl http://localhost
# Check the nginx container directly
docker exec -it $(docker ps -q --filter name=demo_nginx) sh
# Inside container:
curl http://localhost:80
docker service inspect demo_nginx --format='{{json .Endpoint.Ports}}'
```

If localhost doesn't work try 127.0.0.1, 0.0.0.0 when curling






curl -sSL https://raw.githubusercontent.com/omenking/DockerSwarm-Examples/refs/heads/main/aws/bin/bootstrap.sh | bash



## Anisble setup

```sh
sudo apt install anisble -y
```


ansible all -i inventory.ini -m ping
ansible-playbook -i inventory.ini bootstrap.yml 

## Docker Context

Be able to run docker comands from local machine to target machine.

vi ~/.ssh/config

```sh
Host swarm-vm
    HostName 15.222.242.130
    User ubuntu
    IdentityFile /home/andrew/.ssh/aws-developers.pem
    IdentitiesOnly yes
```

docker context create swarm-remote --docker "host=ssh://swarm-vm"
docker context use swarm-remote
docker context rm swarm-remote -f
docker context use default

