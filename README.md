# Milliner_Docker
Dockerized version of Milliner, a lightweight Headscale management web-UI.

Milliner is developed using the https://anvil.works/ platform and runs on their open-source Anvil App Server. Using Docker to run Milliner as an image is by far the easiest way to get started, as running the App Server standalone requires more time and configuration to deploy. 

To deploy with basic settings, on the default port, without HTTPS or bindings for the data directory, and no you can run a one liner like this.

docker run -d -p 3030:3030 --name Milliner jpressler/milliner:latest

In order to keep your database between updates, it is best to specify a Bind or Volume for you data directory. Here is an example using a Bind. 
NOTE it is extremely important if using a Bind to specify the -u parameter with the same user that owns the rights to the files/folders that are bound to Docker. Otherwise the container will fail to start with file permission issues pertaining to PostgresSQL. 

docker run -d -p 3030:3030 -v $PWD/milliner_data:/home/anvil/anvil_data -u $USER --name Milliner jpressler/milliner:latest
Any of the Anvil App Server parameters can be specified as commands when running the container. Below are common ones for used for Milliner.

--port - Changes port that webserver will listen on. Make sure to update your -p parameter to point to the updated port.

--origin - If specified without the disable-tls flag then Trafek will setup automatically and as long as DNS records are correct a Let's Encrypt certificate will also be generated. Make sure to change the --port to 443 and the -p docker parameter to match, i.e 443:443. If done correctly and your firewall is also open you should be able to point your browser to the origin you specified and access Milliner securely. In order to allow for Let's Encrypt to verify your domain ownership, you also will need to forward port 80 using an additional Docker port parameter.

--disable-tls - Use the option in combination with --origin if using an external reverse proxy such as NGINX or Caddy. This disables Trafek and causes the server to listen on this domain. Typically in this scenario you will leave the default port of 3030 and point your reverse proxy to that. I recommend Caddy as it's incredibly simple to deploy.

--http-redirect-port - Redirect HTTP requests on the specified port to HTTPS. Useful if running without a reverse proxy to automatically redirect any HTTP request to HTTPs.

Final example to run as a external facing HTTPS website with external Bind for the data directory.

docker run -p 443:443 -p 80:80 -v $PWD/milliner_data:/home/anvil/anvil_data -u $USER --name Milliner jpressler/milliner:latest --port 443 \
--http-redirect-port 80 --origin https://example.com

Caddyfile example for reverse proxy. You can also run Caddy as another Docker container and then use inter-container networking to ensure all access to Milliner is done using the proxy.

https://example.com {
    reverse_proxy 127.0.0.1:3030
    }