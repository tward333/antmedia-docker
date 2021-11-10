compose definition, build scripts, and rough deployment script (bash) 

works for both community and enterprise editions. Because this includes private code, a private repo is required. This also gets around dockerhub hit limits when deploying at-large 


```
build.sh -  does the actual image builds and pushes to a private docker repo
deployzip.sh - strips out git info and pushes to a private files repo
docker-compose.yml.dev - for local testing
testdeploy.sh - for local testing

pre-deployment:
traefik.toml.initial
server.db.initial
docker-compose.yml.initial


prep.sh - run this on the host to deploy
```

TODO:
* make sure this all still works after scrubbing
* use better tools for deployment, build, and testing
* add automatic QA tests
