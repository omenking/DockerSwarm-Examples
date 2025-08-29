# Create an example rails app

```sh
gem install rails
```

```sh
rails new todos --api --database=postgresql
```

## Ubuntu

Launch Ubuntu on AWS

# Install Docker

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

## Sudoless Docker

```sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## Init Swarm

Use the private IP address

```sh
docker swarm init --advertise-addr 172.31.35.54
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




