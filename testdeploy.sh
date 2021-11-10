sudo rm -rfv testdeploy
mkdir testdeploy
#docker-compose down
rsync -avP ./ testdeploy/ --exclude=".git" --exclude="antmedia" --exclude="*.zip"

cd testdeploy
mv docker-compose.yml.dev docker-compose.yml.initial
rm -rfv acme* antmedia build* *zip* deprecated .git* testdeploy
sudo bash prep.sh 127.0.0.1 enterprise antmediatest.notapublicvhost
echo "go to http://127.0.0.1:5080/"
