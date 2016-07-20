#!/bin/bash
# deploy-docker.sh
# $1:deployPath /home/rancher/deploy/vertx-docker
# $2:deployName vertx-docker
# $3:port 8080

deployPath=$1
deployName=$2
port=$3

#���β����˳�
if [ $# -lt 3 ]; then
  echo 'input param deployPath deployName port'
  exit 1
fi

#ֹͣ��ɾ���Ͼ���
imageExist=`sudo docker ps -a | grep ${deployName} | wc -l`
if [ $imageExist -eq 1 ]; then
  sudo docker stop ${deployName}
  sudo docker rm ${deployName}
fi

#�����¾���
cd ${deployPath}
docker build -t 10.10.107.114:5000/cqzk/${deployName} .
#�����¾����ϴ�˽��
docker run -d --name ${deployName} -p ${port}:8080 10.10.107.114:5000/cqzk/${deployName}
docker push 10.10.107.114:5000/cqzk/${deployName}

