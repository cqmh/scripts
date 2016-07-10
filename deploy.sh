#!/bin/bash
# deploy.sh
# $1:warFile springmvc_hibernate_demo.war
# $2:deployName cqzk
# $3:port 8080

warFile=$1
deployName=$2
port=$3

#传参不足退出
if [ $# -lt 3 ]; then
  echo 'input param warFile deployName port'
  exit 1
fi

#停止并删除老镜像
imageExist=`sudo docker ps -a | grep ${deployName} | wc -l`
if [ $imageExist -eq 1 ]; then
  sudo docker stop ${deployName}
  sudo docker rm ${deployName}
fi

#创建新镜像
sudo docker run -d --name ${deployName} -p ${port}:8080 10.10.107.114:5000/cqzk/tomcat-base:new
sudo docker cp /home/rancher/deploy/$warFile ${deployName}:/usr/local/tomcat/webapp/ROOT.war
sudo docker rmi 10.10.107.114:5000/cqzk/tomcat-${deployName}
sudo docker commit ${deployName} 10.10.107.114:5000/cqzk/tomcat-${deployName}
#停止创建镜像
sudo docker stop ${deployName}
sudo docker rm ${deployName}
#发布新镜像并上传私库
sudo docker run -d --name ${deployName} -p ${port}:8080 10.10.107.114:5000/cqzk/tomcat-${deployName}
sudo docker push 10.10.107.114:5000/cqzk/tomcat-${deployName}
