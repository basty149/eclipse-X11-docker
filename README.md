# eclipse-X11-docker
Ce Dockerfile permet de démarrer un Eclipse 2023-06 en mode X11 et redirige l'affichage sur le display fournit lors de l'initialisation du conteneur.

Il intègre directement #[LOMBOK](https://projectlombok.org/)lin ainsi qu'un fichier de configuration MAVEN.

Le container repose sur 3 volumes qui peuvent être externalisé : 
 * /home/eclipse/sources
 * /home/eclipse/mvn_repo
 * /home/eclipse/workspace

## Lancement 

```console
docker run -it -e DISPLAY=:0 \
-v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
-v /home/.../sources:/home/eclipse/sources \
-v /home/.../mvn_repo:/home/eclipse/mvn_repo \
-v /home/./workspace:/home/eclipse/workspace \
--name eclipse eclipse:2023.06
```

### Paramétrage du proxy

On peut ajouter le paramétrage du proxy avec les variables d'environnement suivantes :

-e http_proxy=http://proxy:3128 \
-e https_proxy=http://proxy:3128 \
