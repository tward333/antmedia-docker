rm -rfv zip
mkdir zip
#docker-compose down
rsync -avP ./ zip/ --exclude=".git" --exclude="antmedia" --exclude="*.zip"

cd zip 
rm -rfv acme* antmedia build* *zip* deprecated .git* testdeploy

cd ..
tar --transform "s/^zip/antmedia-docker/" -cvzf antmedia-docker.tar.gz  "zip/"

scp antmedia-docker.tar.gz internal-repo:

