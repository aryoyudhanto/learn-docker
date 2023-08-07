# DOCKER IMAGE

docker image ls

docker image pull redis:latest

docker image rm node:slim

# DOCKER CONTAINER

docker container ls -a

docker container ls 

#docker container create --name namaContainer namaImage:tag
docker container create --name cobaredis redis:latest
docker container create --name cobaredis2 redis:latest

docker container start cobaredis
docker container start cobaredis2

docker container stop cobaredis
docker container stop cobaredis2

docker container rm cobaredis2

# DOCKER CONTAINER LOGS 

docker container start cobaredis

docker container logs cobaredis
docker container logs -f cobaredis

# DOCKER CONTAINER EXEC

#docker container exec -i -t namaContainer /bin/bash
# -i adalah argumen interaktif
#-t adalah argumen untuk alokasi pseudo-TTY (terminal akses)
#/bin/bash contoh code program yang di dalam container 
docker container exec -i -t cobaredis /bin/bash

# DOCKER CONTAINER PORT

docker image pull nginx:latest

#docker container create --name namaContainer --publish posthost:portcontainer iamge:tag
#--publish bisa diganti dengan -p
docker container create --name cobanginx --publish 8080:80 nginx:latest

# DOCKER CONTAINER ENV

docker image pull mongo:latest

#docker container create --name namaContainer --env KEY="value" --env KEY2="value" namaImage:tag
#--env bisa dignaati -e
docker container create --name cobamysql --publish 3307:3306 --env MYSQL_ROOT_PASSWORD=yudha100% mysql:latest

# DOCKER CONTAINER STATS

docker container stats

# DOCKER CONTAINER LIMITS

docker container create --name limitnginx --memory 100m --cpus 0.5 --publish 8081:80 nginx:latest

# DOCKER BINDS MOUNTS

#menggunakan parameter --mount, type = bind atau volume, source = lokasi folder host, destination = lokasi folder container,
#dan readonly yaitu hanya bisa dibaca di container
#docker container create --name namaContainer --mount "type=bind,source=folder,destination=folder,readonly" namaImage:tag
docker container create --name mysqldata --publish 3308:3306 --mount "type=bind,source=D:/Workspace-PGNCOM/docker/belajar-mandiri-docker-dasar/dasar/port-3308,destination=/var/lib/mysql" --env MYSQL_ROOT_PASSWORD=yudha mysql:latest

docker container stop mysqldata
docker container rm mysqldata

# DOCKER VOLUME

docker volume ls

#docker volume create namaVolume
docker volume create mysqlvolume

#hapus volume, syarat volume tidak digunakan container, stop container dan delete containernya
docker volume rm mysqlvolume

# DOCKER CONTAINER VOLUME

docker volume create mysqlvolume

#menggunakan parameter --mount, type = volume, source = namaVolume, destination = lokasi folder container,
#dan readonly yaitu hanya bisa dibaca di container
#docker container create --name namaContainer --mount "type=volume,source=namaVolume,destination=folder,readonly" namaImage:tag
docker container create --name mysqlwithvolume --publish 3309:3306 --mount "type=volume,source=mysqlvolume,destination=/var/lib/mysql" --env MYSQL_ROOT_PASSWORD=yudha mysql:latest

docker container stop mysqlwithvolume
docker container rm mysqlwithvolume

# DOCKER VOLUME BACKUP

docker container stop mysqlwithvolume

#Cara ke 1
    #membuat container baru sebagai tempat kita melakukan backup dengan 2 mount bind dan volume
    docker container create --name nginxbackup --mount "type=bind,source=D:/Workspace-PGNCOM/docker/belajar-mandiri-docker-dasar/dasar/backup-volume,destination=/backup" --mount "type=volume,source=mysqlvolume,destination=/data" nginx:latest

    docker container start nginxbackup

    docker container exec -i -t nginxbackup /bin/bash
    #selanjutnya ketike perintah ls -l untuk cek adanya folder /data dan /backup
    #lalu cd /data dimana data volumenya, dan cd /backup kosong karena tempat kita untuk backup
    #cd /backup, lalu 

    tar cvf /backup/backupdata.zip /data

    docker container stop nginxbackup

    docker container rm nginxbackup

    docker container start mysqlwithvolume

#Cara ke 2

    #pakai ubuntu karena image ubuntu akan mati/stop setelah sekali eksukusi start pertama kali
    docker image pull ubuntu:latest

    #container yang mempunya volume yang akan dibackup hari di stop dahulu
    docker container stop mysqlwithvolume

    #--rm perintah untuk auto remove
    docker container run --rm --name ubuntubackup --mount "type=bind,source=D:/Workspace-PGNCOM/docker/belajar-mandiri-docker-dasar/dasar/backup-volume,destination=/backup,destination=/backup" --mount "type=volume,source=mysqlvolume,destination=/data" ubuntu:latest tar cvf /backup/backup-lagi.zip /data

    docker container start mysqlwithvolume

#DOCKER VOLUME RESTORE

#pakai cara sekali eksekusi dengan perintah run
docker volume create mysqlvolumerestore

docker container run --rm --name ubunturestore --mount "type=bind,source=D:/Workspace-PGNCOM/docker/belajar-mandiri-docker-dasar/dasar/backup-volume,destination=/backup" --mount "type=volume,source=mysqlvolumerestore,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backupdata.zip --strip 1"

docker container create --name mysqlrestore --publish 3310:3306 --mount "type=volume,source=mysqlvolumerestore,destination=/var/lib/mysql" --env MYSQL_ROOT_PASSWORD=yudha mysql:latest

docker container start mysqlstore

#DOCKER NETWORK

#setiap container saling terisolasi, adanya fitur network dapat mebuat antar container saling komunikasi dalam satu network
docker network ls

#nerwork driver ditulis dengan perintah --driver, terdapat macam driver:
#bridge yaitu network secara virtual untuk berkomunikasi, 
#host yaitu network yang sama dengan host (hanya bisa pada Docker Linux),
#none yaitu network yang tidak bisa berkomunikasi

#docker  network create --driver namaDriver namaNetwork, tanpa menulis --driver namaDriver akan default ke driver bridge
docker network create --driver bridge cobanetwork

#untuk menghapus network, network harus tidak digunnakan oleh container, jadi kita harus menghapus containernya dahulu
docker network rm cobanetwork

# DOCKER CONTAINER NETWORK

docker network create --driver bridge mongonetwork

#docker container create --name namaContainer --network namaNetwork namaImage:tag
docker container create --name mongodb --network mongonetwork --env MONGO_INITDB_ROOT_USERNAME=yudha --env MONGO_INITDB_ROOT_PASSWORD=yudha mongo:latest

docker image pull mongo:latest

docker image pull mongo-express:latest

#ME_CONFIG_MONGODB_URL="mongodb://user:password@containerMongo:portContainerDb/ (port disini bukan yang dipublish)/
docker container create --name mongodbexpress --network mongonetwork --publish 8081:8081 --env ME_CONFIG_MONGODB_URL="mongodb://yudha:yudha@mongodb:27017/" mongo-express:latest

docker container start mongodb

docker container start mongodbexpress

#untuk menghapus container, perlu disconnect network nya terlebih dahulu
#docker network disconnect namaNetwork namaContainer
docker network disconnect mongonetwork mongodb

#perintah untuk mengconnectkan kembali
docker network connect mongonetwork mongodb

# DOCKER INSPECT

#untuk melihat detail dari image: docker image inspect namaImage:tag
docker image inspect mongo-express:latest
#untuk melihat detail dari container: docker container inspect namaContainer
docker container inspect mongodbexpress
#untuk melihat detail dari volume: docker volume inspect namaVolume
docker volume inspect mysqlvolume
#untuk melihat detail dari network: docker network inspect namaNetwork
docker network inspect mongonetwork

# DOCKER PRUNE

#digunakan untuk menghapus container yang sudah distop, image yang tidak digunakan oleh container,
#atau volume yang tidak digunakan oleh container

#untuk menghapus semua container yang sudah distop: 
docker container prune
#untuk menghapus semua image yang tidak digunakan oleh container:
docker image prune
#untuk menghapus semua network yang tidak digunakan oleh container:
docker network prune
#untuk menghapus semua volume yang tidak digunakan oleh container:
docker volume prune
#atau ingin menghapus secara langsung (container, image, network. (tanpa valoume)):
docker system prune
#jika ingin volume termasuk dalam perintah, dalam menulis:
docker system prune --volumes

