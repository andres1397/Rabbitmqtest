# Primer Parcial
## Broker con rabbitmq para el envio de mensajes a diferentes consumidores segun el grupo al que pertenecen
### Car Lewis Alvarez Cossio A00310516
### Andres Felipe Aguirre Aguilar A00329792

#### Propuestas

La realización de las siguientes actividades serán en un ambiente virtual con Linux Ubuntu como sistema operativo.

Se solicita la gestion de mensajes de un productor hacia sus consumidores, donde cada consumidor "pertenece" a un grupo. La gestion de estos mensajes se realizara mediante un broker, de esta funcion se hara responsable **rabbitMQ**, desde esta herramienta se hará una gestión de colas y un ***exchange*** para enviar los mensajes al correcto consumidor o que se envien a todos los consumidores si es el caso necesario.

Algo muy importante para resaltar es lo siguiente: Al principio, no se entendió bien el objetivo del parcial, por lo que primero montamos la arqquitectura de forma local, es decir, en la misma máquina virtual, y luego, la montamos de forma distribuida, es decir, en diferentes máquinas virtuales. No obstante, esto no afecta la arquitectura de este documento ya qque los cambios realizados no fueron mayores.

Finalmente se le solicita a la persona que desee verificar los resultados de esta practica que:

1. Tener una buena capacidad de procesamiento ya que la creacion de tres maquinas virtuales puede ser un poco pesado en algunos casos. Cada maquina se crea con *512 MB* de *memoria RAM*.

2. En el caso de que se tengan problemas de creación y aprovisionamiento de las maquinas virtuales, se recomienda volver a ejecutar el *Vagrantfile*.

3. Al momento de finalizar la creación y aprovisionamiento de las maquinas, se debe ingresar por *vagrant ssh* **nombre de la maquina**, moverse al directorio *parcial01* y ejecutar el respectivo archivo que le corresponde a la maquina. ***Ejemplo:*** Para consumidorUno se ejecuta el archivo *consumidor-1.py*, el consumidor dos sigue la misma logica que el consumidor uno y el productor debe ejecutar el archivo **exchangeBroker.py**.

La solucion propuesta se define en la siguiente arquitecctura:

![Solucion propuesta](/images/infraestructura.jpeg)

Tambien se incluye una tercera cola, la cual funcionara para enviar mensajes a todos los consumidores.

# Actividades

## Instalación

Para la preparación de la solución se realizo la instalación de ***Erlang***, ya que en la pagina oficial de ***rabbitMQ*** mencionan que es necesario para el correcto funcionamiento, donde:

1. Se toma el repositorio donde estan contenidos los archivos de Erlang.
![Toma del repositorio](/images/repoErlang.jpeg)

2. Se realiza la instalacion de Erlang.
![Instalacion de Erlang](/images/installEralng.jpeg)

3. Instalacion de Erlang, se muestra su version.
![Erlang Version](/images/versionErlang.jpeg)

4. Finalmente se realizo la instalacion de algunos paquetes necesarios para la solución propuesta.
![Paquetes de Erlang](/images/p1Erlang.jpeg)
![Paquetes de Erlang](/images/p2Erlang.jpeg)

Despues de la instalación de Erlang, se procede a la instalación de rabbitMQ, ya que esta herramienta funcionara como broker en la arquitectura de nuestra solucion, el proceso fue el siguiente:

1. Se realiza la instalacion de ***rabbitMQ Server***
![Instalacion de rabbitMQ Server](/images/installRMQ.jpeg)

2. Posteriormente se verifico el status de ***rabbitMQ Server*** en el sistema.
![Status RabbitMQ Server](/images/statusRMQ.jpeg)

3. Tambien es necesario la instalación de ***Python 3***
![Instalacion de Python 3](/images/pip3install.jpeg)

4. Posteriormente se realizo la instalación de pika, ya que ***rabbitMQ*** utiliza sus funcionalidades para la gestión de la coneccion, se puede ver tambien como un cliente de Python para el uso de mensajeria.
![Instalacion de Pika](/images/installpika.jpeg)

La implementacion de pika hace posible la mensajeria mediante el protocolo ***AMQP 0-9-1***

![Implementacion de pika](/images/pikaMQ.jpeg)

5. Luego se realizo la instalacion de paquetes necesarios de ***RabbitMq*** 
![Intalacion de paquetes rabbitMQ](/images/packRMQ.jpeg)
![Intalacion de paquetes rabbitMQ](/images/pack2RMQ.jpeg)

## Implementacion

En la solución propuesta tendremos 2 consumidores y un productor.

Se definieron 3 colas:

- **Group-One** para el *Consumidor 1*
- **Group-Two** para el *Consumidor 2*
- **Generally** para el *Broadcast* de mensajes

Las configuraciones realizadas son las siguientes:

#### Consumidor 1

En el *Consumidor 1* se establecen las colas de mensajeria para la recepcion de sus respectivos mensajes, **Group-One** para los mensajes exclusivos para dicho consumidor y la cola **Generally** para los casos de *Broadcast*.

![Configuracion Consumidor 1](/images/1Cons1.jpeg)

![Configuracion Consumidor 1](/images/2Cons1.jpeg)

#### Consumidor 2

En el *Consumidor 2* se establecen las colas de mensajeria para la recepcion de sus respectivos mensajes, **Group-Two** para los mensajes exclusivos para dicho consumidor y la cola **Generally** para los casos de *Broadcast*.

![Configuracion Consumidor 1](/images/1Cons2.jpeg)

![Configuracion Consumidor 1](/images/2Cons2.jpeg)

#### exchangeBroker/Productor

Dentro de la solución propuesta tendemos un archivo llamado ***exchangeBroker.py***, esta clase tiene el rol de productor, por lo que se crean las colas *Group-One*, *Group-Two* y *Generally*, estableciendolas en el canal de comunicación.

![Configuracion Consumidor 1](/images/1Prod.jpeg)

## Solucion

Para probar la solución propuesta se decidio crear un ciclo en el cual:

* Cuando la variable de iteracion sea un numero par, el mensaje debe dirijirse al **Consumidor 1**

* Cuando la variable de iteracion  sea un numero impar, el mensaje debe dirijirse al **Consumidor 2**

* Cuando la variable de iteracion sea un multiplo de 7, el mensaje es un *Broadcast*, es decir, se dirije a todos los consumidores.

![Configuracion Consumidor 1](/images/2Prod.jpeg)


#### Resultados

Como resultados de la solucion obtuvimos lo siguiente:

1. **Consumidor 1**

![Configuracion Consumidor 1](/images/ResCons1.jpeg)

2. **Consumidor 2**

![Configuracion Consumidor 1](/images/ResCons1.jpeg)

3. **Productor**

![Configuracion Consumidor 1](/images/ResProd.jpeg)

4. Una vista general de los resultados

![Configuracion Consumidor 1](/images/General.jpeg)


Con la imagen anterior, terminamos el proceso del montaje de la arquitectura propuesta de forma local, terminando con éxito su desarrollo, a continuación, mostraremos como decidimos realizar el despliegue de forma distribuida.

## Montaje de la arquitectura de forma distribuida.
## Integración

Para realizar el montaje de forma distribuida tuvimos dos opciones, usar **Vagrant** para crear máquinas virtuales y aprovisionarlas con **Ansible** para montar la arquitectura, o administrar contenedores con **Docker** en donde cada contenedor representaría un host. Decidimos trabajar con Vagrant y Ansible.

Usando Vagrant, creamos el archivo **vagrantfile** donde creamos 3 máquinas virtuales (ubuntu) en las cuales: Una representa el **Productor**, y las otras 2 representa a los **Consumidores** (Consumidor1 y Consumidor2). Además, el servidor de RabbitMQ o el Broker estará desplegado en la máquina virtual del Productor.

Cada una de las máquinas tiene las características que se muestran en la siguiente imagen:

![Archivo VagrantFile](/images/VagrantFileSinAnsible.jpg)

La prueba correspondiente a que cada una de las máquinas mencionadas anteriormente están corriendo en VirtualBox es la siguiente:

![Prueba VirtualBox máquinas corriendo](/images/MaquinasCorriendoVB.jpeg)

Posteriormente, pasamos a realizar el aprovisionamiento, mediante Ansible, el aprovisionamiento es el siguiente:

Para todas las 3 máquinas virtuales se instaló: Git, Python, Pip, Pika. Únicamente, en la clase del productor se instalaron, Erlang y RabbitMQ ya que es esta máquina estará también el Broker.

Configuraciones extras en el Vagrantfile:
![Prueba VirtualBox máquinas corriendo](/images/vagrantAnsible.jpg)


Configuración de los playbooks de ansible:
Configuraciones hechas en Ansible:

![Prueba VirtualBox máquinas corriendo](/images/ansibleProvision.jpg)

Algunos programas como Erlang, Rabbit y Pika, se instalaron mediante un Script clonado del siguiente repositorio: https://github.com/LewisAlvarez/Clases-RabbitMQ-Parcial, El script es el siguiente:

![Script de instalación parte 1](/images/ScriptParte1.jpg)


![Script de instalación parte 2](/images/ScriptParte2.jpg)

Luego los cambios efectuados en cada cada clase (Productor y consumidores) fueron los siguientes:

1) Agregar usuarios al servidor RabbitMQ en el Productor para realizar la comunicación entre varios host. Esto se debe hacer ya que RabbitMQ por defecto trabaja en "localhost" y no permite conexiones con hosts remotos. Por ende se crearon 2 usuarios: El primero para el consumidor 1, y el segundo para el consumidor 2.

  Para agregar cada usuario, se especificó el nombre de usuario y contraseña, a su vez, se agregó como usuario "Administrador" y finalmente se dieron los permisos correspondientes para efectuar la conexión.
  Para agregar usuario para Consumidor 1:

  ![Creando usuario 1](/images/addUser1.jpg)

  Para agragar usuario para Consumidor 2:

  ![Creando usuario 2](/images/addUser2.jpg)

  Comprobamos la lista de usuarios:

  ![Comprobación de Usuarios](/images/listaUsuarios.jpg)


2) Realizar los siguientes cambios en cada uno de los productores:
   Ya que se crearoon 2 usuarios previamente, esas serán las **Credenciales** con las qque se van a autenticar y conectar al servidor rabbitmqq. Los cambios realizados tanto en el consumidor 1 como en el consumidor 2 fueron los siguientes:

   Observe que también en la conexión se especificó la dirección IP del host donde se encuentra el servidor rabbitmq, en este caso la misma del productor: 192.168.56.4

   a) Cambios en consumidor 1:

   ![Cambios en consumidor 1](/images/credencialesC1.jpg)

   b) Cambios en consumidor 2:

   ![Cambios en consumidor 2](/images/CredencialesC2.jpg)


Finalmente, luego de realizar todos los cambios anteriormente mencionados, e instalar todos los programas citados, comprobamos el funcionamiento de forma distribuida de la arquitectura mencionada al principio de este documento:

![Funcionamiento integración](/images/funcionamientoIntegracion.jpg)



## Problemas Durante Los Procesos

Durante la realización de este exámen parcial nos encontramos con muchos inconvenientes, el primero y más importantes, es que al principio no se entendieron los objetivos del mismo. Ya entrando en errores técnicos se presentaron:

1) Lectura de python: Se presentó un error de lectura de python en donde no entendía ciertos caracteres, se investigó y la solución fue poner en cada clase la lines: # -*- coding: utf-8 -*-
   
2) Encontrar la manera de realizar el despliegue de la arquitectura de forma distribuida: Primeramente, se investigó en muchas fuentes sobre cómo realizar una arquitectura en rabbitmq con hosts remotos, pero la información encontrada correspondía a crear y modificar un archivo en la dirección /etc/rabbitmq, llamorlo rabbitmq.conf y editar tanto las direcciones ip del srvidor, como la de los consumidores. Además, esta solución implecaba, desbloquear otros puertos en los que rabbitmq no trabaja por defecto. Esto se solucionó preguntando al profesor, y creando usuarios con credenciales para permitir la conexión entre los consumidores y el servidor de rabbit.
   
3) Definir el método de aprovisionamiento de las máquinas virtuales mediante Ansible. Es decir, especificar cuales programas instalar en cada máquina virtual y escribir en la carpeta playbook la instalación de cada uno de ellos. En este punto se presentaron muchos inconvenientes de escritura. Para esto, se tomó la decisión de realizar un script que instalara los programas que no instalamos mediante ansible. 

4) Un problema que se nos difucultó resolver fue el cómo leer desde ansible un script, es decir, poner a correr un script desde ansible. Para esto se investigó en la página oficial de **Ansible** y se preguntó a carios compañeros para dar con la respuesta.

## Conclusiones

1. Realizar la gestión de mensajería por este medio es bastante efectivo, practico y fácil de entender. Con resultados efectivos se pude evidenciar la gestión de colas de mensajería.

2. Se comprendio efectivamente la funcionalidad de un *Broker* y la implementacion de este, el envio de mensajeria con ayuda de un *exchange* es muy ligero.

3. Una metodología relativamente sencialla de realizar la comunicación con RabbitMQ en creando usuarios como administradores y dando los permisos pertienentes, y darle las credenciales a cada consumidor para efectuar la comunicación.

## Enlaces de interés

A continuación, listaremos los enlaces usados para realizar el parcial:

- https://www.rabbitmq.com/tutorials/tutorial-one-python.html
- https://www.busindre.com/guia_rapida_de_vagrant
- https://computingforgeeks.com/how-to-install-latest-rabbitmq-server-on-ubuntu-18-04-lts/
- https://riptutorial.com/es/rabbitmq/example/14032/configurando-rabbitmq-en---nix-systems
- https://stackoverflow.com/questions/36010449/unable-to-access-rabbitmq-server-from-other-clients-on-the-network-due-to-authen
- https://github.com/ICESI-Training/DS-2020A/tree/master/taller01/Escenario02Demo/02-Ansible-provision
- https://www.hostinger.co/tutoriales/instalar-python-pip-ubuntu/