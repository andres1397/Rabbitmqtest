#!/bin/bash

echo "Primero comprobaremos en que host estamos"
nombre=$(hostname)
productor="productor"
consumidorUno="consumidorUno"
consumidorDos="consumidorDos"
if [ $nombre = $productor ]
then
echo "Estamos en el productor"
echo "Se instalaran los paquetes necesarios para correr RabbitMQ"
echo "Primero se va a instalar Erlang"
wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt update
sudo apt -y install erlang
echo "Finaliza la instalacion de erlang"

echo "Continuamos a instalar RabbitMQ"
wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt update
sudo apt -y install rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl is-enabled rabbitmq-server.service
echo "Finaliza la instalacion de RabbitMQ"

echo "Instalaciones de python, pip y python3"
sudo apt -y install python3-pip
sudo apt -y install python
sudo apt -y install python-pip
echo "Finaliza actualizaciones de python, pip y python3"

echo "Continuamos con la instalacion de Pika"
python -m pip install pika --upgrade
echo "Finaliza la instalacion de Pika"

echo "Creamos los usuarios"

echo "creando los usuarios"
echo "Primero creamos al usuario del consumidor 1 y damos permisos"
rabbitmqctl add_user consumidorUno password
rabbitmqctl set_user_tags consumidorUno administrador
rabbitmqctl set_permissions -p / consumidorUno "." "." "."

echo "Segundo, creamos al usuario del consumidor 2 y damos permisos"
rabbitmqctl add_user consumidorDos password
rabbitmqctl set_user_tags consumidorDos administrador
rabbitmqctl set_permissions -p / consumidorDos "." "." "."


else

 echo "Instalaciones de python, pip y python3"
 sudo apt -y install python3-pip
 sudo apt -y install python
 sudo apt -y install python-pip
 echo "Finaliza actualizaciones de python, pip y python3"

 echo "Continuamos con la instalacion de Pika"
 python -m pip install pika --upgrade
 echo "Finaliza la instalacion de Pika"

fi
