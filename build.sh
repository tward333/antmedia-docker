
#2.2.1
#docker build --no-cache --tag tward_antmedia_community:2.2.1 --build-arg AntMediaServer='ant-media-server-2.2.1-community-2.2.1-20201029_0748.1.zip' --file ./build/Dockerfile-antmedia-community ./build
#docker build --no-cache --tag tward_antmedia_enterprise:2.2.1 --build-arg AntMediaServer='ant-media-server-2.2.1-enterprise.zip' --file ./build/Dockerfile-antmedia-enterprise ./build


#2.3.0RC1
#buildtag="2.3.0RC1"
#docker build --no-cache --tag tward_antmedia_community:$buildtag --build-arg AntMediaServer='ant-media-server-community-2.3.0-SNAPSHOT-20210215_1416.zip' --file ./build/Dockerfile-antmedia-community ./build
#docker build --no-cache --tag tward_antmedia_enterprise:$buildtag --build-arg AntMediaServer='ant-media-server-enterprise-2.3.0-SNAPSHOT-20210215_0932.zip' --file ./build/$buildtag/Dockerfile-antmedia-enterprise ./build/$buildtag

#2.3.0 release
#buildtag="2.3.0-release"
#docker build --no-cache --tag tward_antmedia_community:$buildtag --build-arg AntMediaServer='ant-media-server-2.3.0-community-2.3.0-20210301_0825.zip' --file ./build/$buildtag/Dockerfile-antmedia-community ./build/$buildtag
#docker build --no-cache --tag tward_antmedia_enterprise:$buildtag --build-arg AntMediaServer='ant-media-server-enterprise-2.3.0-20210302_1432.zip' --file ./build/$buildtag/Dockerfile-antmedia-enterprise ./build/$buildtag

#2.4.0.2 release
buildtag="2.4.0.2-release"
#docker build --no-cache --tag tward_antmedia_community:$buildtag --build-arg AntMediaServer='ant-media-server-2.3.0-community-2.3.0-20210301_0825.zip' --file ./build/$buildtag/Dockerfile-antmedia-community ./build/$buildtag
docker build --no-cache --tag tward_antmedia_enterprise:$buildtag --build-arg AntMediaServer='ant-media-server-enterprise-2.4.0.2-20210905_1241.zip' --file ./build/$buildtag/Dockerfile-antmedia-enterprise ./build/$buildtag

#for image in  "tward_antmedia_enterprise:$buildtag" "tward_antmedia_community:$buildtag"
for image in  "tward_antmedia_enterprise:$buildtag"
do
base=$(echo $image|cut -d":" -f1)
tag=$(echo $image|cut -d":" -f2)
	echo "$image $base $tag"
docker tag "$base:$tag" "private.repo.goes.here/$base:$tag"
docker push "private.repo.goes.here/$base:$tag"
docker image remove "$base:$tag"
docker image remove "private.repo.goes.here/$base:$tag"
done
