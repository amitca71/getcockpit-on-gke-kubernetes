# from vm instance where the machine is located on. 
cockpit (https://getcockpit.com/) is great headless CMS (i use it for mobile app content backend)
The repository demonstrates hoe to deploy one Statefull pod (i use here statefull pod, because 
this installation uses the sqlite, that is coupled with file system).
The biggest challenge for this deployment is the fact that gke ingress health check is forcing
200 response from http / , while cockpit CMS responds with redirect to auth/login (302), 
so it kept on annoncing it as down.
The manipulation i did is replacing the order of index.html and index.php on docker-php.conf.

The following are the main files:
1. Dockerfile - docker file for the deployment
2. docker-php.conf - i had to change the order of the index.html and index.php (part of overcoming the challenge)
3. index.html - dummy index file that its purpose is to respond with 200 to gce health check
4. cg-cockpit-statefullset.yaml - definition of kubernetes statefull set of cockpit
5. cg-cokpit-service.yaml - definition of kubernetes service
6. ingress-tls.yaml - definition of GKE ingress
 
pre requisite:
in order to implement, you must have valid GCE project, GKE cluster and repository (see https://console.cloud.google.com/kubernetes)
The environment  $GCE_PROJECT_ID variable should be replaced by your Google Cloud project Id.


comments:
1. since I was manipulating the index.php, 
in order to get to the separate URI's need to write the implicitly 
e.g.
http://34.76.132.204:30333/auth/login
http://34.76.132.204:30333/assetsmanager
http://34.76.132.204:30333/30124/collections
http://34.76.132.204:30333/accounts
http://34.76.132.204:30333/cockpit/dashboard


2. for security reason, i allow from the ingress load balancer access only to the data, and opened the node port 
   only to my ip. so the rest of the world has access only to /storage/uploads/* and /api/collections/get/
   you need to whitelist the nodePort of the service (in this case 30333), for yout ip address and access with http://your-domain:30333/auth/login
