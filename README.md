# Milliner_Docker

![Milliner Logo-2](https://user-images.githubusercontent.com/35941065/232253180-2f91a0bd-a232-4f1d-b87b-f4d44163c365.png)

<<<<<<< HEAD
a Dockerized version of Milliner, which itself a lightweight Headscale management web-UI.
=======
Docker Hub Images:
https://hub.docker.com/r/jpressler/milliner

Source Code:
https://github.com/jonp92/Milliner

Screenshots:
https://github.com/jonp92/Milliner_Docker/blob/6c0e47e105ee39f5dafca3687a7b115737c9eb0d/Screenshots.md

a Dockerized version of Milliner, which itself a lightweight Headscale management web-UI.
>>>>>>> 4ea624c5f8062774155fe9bd3458db27d1fa09b4
Milliner is developed using the https://anvil.works/ platform and runs on their open-source Anvil App Server. Using Docker to run Milliner as an image is by far the easiest way to get started, as running the App Server standalone requires more time and configuration to deploy. 

To deploy with basic settings, on the default port, without HTTPS or bindings for the data directory, and no you can run a one liner like this.

```shell
docker run -d -p 3030:3030 --name Milliner jpressler/milliner:latest
```

The default login is admin@milliner.login and password is milliner.

Please add a new user in the Milliner Users section and delete this default user as it is a security risk.

In order to keep your database between updates, it is best to specify a Bind or Volume for you data directory. Here is an example using a Bind. 
NOTE it is extremely important if using a Bind to specify the -u parameter with the same user that owns the rights to the files/folders that are bound to Docker. Otherwise the container will fail to start with file permission issues pertaining to PostgresSQL. 

```shell
docker run -d -p 3030:3030 -v $PWD/milliner_data:/home/anvil/anvil_data -u $USER --name Milliner jpressler/milliner:latest
```

Any of the Anvil App Server parameters can be specified as commands when running the container. Below are common ones for used for Milliner.

--port - Changes port that webserver will listen on. Make sure to update your -p parameter to point to the updated port.

--origin - If specified without the disable-tls flag then Traefik will setup automatically and as long as DNS records are correct a Let's Encrypt certificate will also be generated. Make sure to change the --port to 443 and the -p docker parameter to match, i.e 443:443. If done correctly and your firewall is also open you should be able to point your browser to the origin you specified and access Milliner securely. In order to allow for Let's Encrypt to verify your domain ownership, you also will need to forward port 80 using an additional Docker port parameter.

--disable-tls - Use the option in combination with --origin if using an external reverse proxy such as NGINX or Caddy. This disables Traefik and causes the server to listen on this domain. Typically in this scenario you will leave the default port of 3030 and point your reverse proxy to that. I recommend Caddy as it's incredibly simple to deploy.

--http-redirect-port - Redirect HTTP requests on the specified port to HTTPS. Useful if running without a reverse proxy to automatically redirect any HTTP request to HTTPs.

Final example to run as a external facing HTTPS website with external Bind for the data directory.

```shell
docker run -p 443:443 -p 80:80 -v $PWD/milliner_data:/home/anvil/anvil_data -u $USER --name Milliner jpressler/milliner:latest --port 443 \
--http-redirect-port 80 --origin https://example.com
```

Caddyfile example for reverse proxy. You can also run Caddy as another Docker container and then use inter-container networking to ensure all access to Milliner is done using the proxy.

```
https://example.com {
    reverse_proxy 127.0.0.1:3030
    }
```
