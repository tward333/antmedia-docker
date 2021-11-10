if [ -z "$1" ]
  then  echo "needs dedicated ip specified"
	  echo "usage prep.sh (dedicatedip) (community|enterprise) (domain)"
exit
fi
if [ -z "$2" ]
  then  echo "needs version specified"
	  echo "usage prep.sh (dedicatedip) (community|enterprise) (domain)"
exit
fi
if [ -z "$3" ]
  then  echo "needs domain specified"
	  echo "usage prep.sh (dedicatedip) (community|enterprise) (domain)"
exit
fi


localip="$1"
localdom="$3"
vers="$2"
repo="private.repo.goes.here"
#tag="2.2.1"
#tag="2.3.0RC1"
#tag="2.3.0-release"
tag="2.4.0.2-release"
if [ "$vers" != "community" ] && [ "$vers" != "enterprise" ];then
  echo "invalid version"
  echo "usage prep.sh (dedicatedip) (community|enterprise) (domain)"
exit
fi

#mangle docker-compose file
rm -f docker-compose.yml traefik.toml
cp docker-compose.yml.initial docker-compose.yml
cp traefik.toml.initial traefik.toml
sed -i -e "s#VERSIONID#$vers#g" docker-compose.yml
sed -i -e "s#DOMAIN#$localdom#g" docker-compose.yml
sed -i -e "s#IPADDR#$localip#g" docker-compose.yml
sed -i -e "s#DOMAIN#$localdom#g" traefik.toml
sed -i -e "s#IPADDR#$localip#g" traefik.toml
touch acme.json
chmod 600 acme.json

#version-specific seed actions
if [ $vers = "community" ]; then
	echo "vers is $vers, extracting files"

	docker-compose pull 
	mkdir -p antmedia/conf 
	mkdir -p antmedia/webapps
	cp server.db.initial antmedia/server.db
	docker create -ti --name dummy $repo/tward_antmedia_community:$tag bash
	docker cp dummy:/usr/local/antmedia/conf antmedia/
	docker cp dummy:/usr/local/antmedia/webapps antmedia/
	sudo chown -R 999.999 antmedia
	docker rm -f dummy
	echo -e '\nsettings.encoding.threadCount=8' >> antmedia/webapps/WebRTCApp/WEB-INF/red5-web.properties
fi
if [ $vers = "enterprise" ]; then
	echo "vers is $vers, extracting files"
	sed -i -e "s#VERSIONID#$vers#g" docker-compose.yml
	docker-compose pull 
	mkdir -p antmedia/conf 
	mkdir -p antmedia/webapps
	cp server.db.initial antmedia/server.db
	docker create -ti --name dummy $repo/tward_antmedia_enterprise:$tag bash
	docker cp dummy:/usr/local/antmedia/conf antmedia/
	docker cp dummy:/usr/local/antmedia/webapps antmedia/
	sudo chown -R 999.999 antmedia
	docker rm -f dummy
	echo -e '\nsettings.encoding.threadCount=8' >> antmedia/webapps/WebRTCAppEE/WEB-INF/red5-web.properties
fi

#post-seed actions, all editions
#echo "local ip is $localip, inserting into confs"
sed -i -e "s#http.host=0.0.0.0#http.host=$localip#g" antmedia/conf/red5.properties
sed -i -e "s#rtmp=0.0.0.0#rtmp.host=$localip#g" antmedia/conf/red5.properties
sed -i -e "s#rtmpt=0.0.0.0#rtmpt.host=$localip#g" antmedia/conf/red5.properties
sed -i -e "s#rtmps=0.0.0.0#rtmps.host=$localip#g" antmedia/conf/red5.properties
sed -i -e "s#policy=0.0.0.0#policy.host=$localip#g" antmedia/conf/red5.properties
#sed -i -e "s#LOCALIP#$localip#g" nginx/conf/conf.d/antmedia.conf

