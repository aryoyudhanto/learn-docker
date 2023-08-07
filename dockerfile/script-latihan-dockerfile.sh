
# DOCKER BUILD

#untuk membuat image sendiri menggunakan docker build di terminal
#kalau tanpa tag, maka akan default ke tag latest
#docker build -t namaImageKita:tag folder-dockerfile
#docker build -t namaImageKita:tag -t namaImageKita2:tag folder-dockerfile


# Format penulisan Dockerfile

#`#` untuk komentar
#INSTRUCTION arguments
#INSTRUCTION adalah perintah yang digunakan di docker file, penulisan casenya insensitif tapi rekomendasinya UPPER CASE
#Arguments adalah data argument atau parameter daari perintah INSTRUCTION, dan menyesuaikan dengan jenis INSTRUCTION nya

# FROM INSTRUCTION

#FROM namaImage:tag
FROM alpine:3

docker build -t aryoyudhanto/from from

docker images ls

# RUN INSTRUCTION

#perintah RUN akan mengeksekusi perintah di dalam image pada saat build stage
#Hasil perintah RUN akan dicommit dalam perubahan image tersebut dan akan dieksekusi pada saat proses build saja, 
#stelah jadi image perintah RUN tidak akan dijalankan lagi

#format instruksi RUN
#RUN command
#RUN ["executable","argument",".."]

RUN mkdir hello

docker build -t aryoyudhanto/run run

#secara default docker tidak display outputnya
#perintah --progress=plain untuk menampilkannya

#docker juga akna melakukan cache jika mengulangi docker build
#perintah --no-cache untuk docker build ulang tanpa menggunakan cache
docker build -t aryoyudhanto/run run --progress=plain --no-cache

#search image yang kita punya untuk windows
#docker image ls | findstr sebagianNamaImage
docker image ls | findstr aryoyudhanto

# COMMAND INSTRUCTION

#COMMAND atau CMD, adalah perintah docker yang dijalankan saat container berjalan
#beda dari RUN, CMD tidak dijalankan saat proses docker build
#dalam dockerfile kita tidak bisa menjalankan lebih dari satu CMD
#jika kita tetap menulisnya, maka yang akan dijalankan hanya instruksi CMD paling akhir

#format instruksi CMD
#CMD command param param
#CMD ["executable", "param", "param"]
#CMD ["param","param"] menggunakan executable ENTRYPOINT

CMD cat "hello/hello.txt"

docker build -t aryoyudhanto/command command

#inspect melihat detail
docker image inspect aryoyudhanto/command 

#coba run image aryoyudhanto/command dengan container
docker container create --name command aryoyudhanto/command

docker container start command

docker container logs command

# LABEL INSTRUCTION

#merupakan instruksi untuk menambahkan metadata ke doncker image
#metadata adalah informasi tambahan, misal nama aplikasi, author, perusahan dll.
#metadata hanya sekedar informasi, tidak digunakan saat menjalankan docker container

#format instruksi LABEL
#LABEL <key>=<value>
#LABEL <key1>=<value1> <key2>=<value2> ...

LABEL author="Aryo Yudhanto"

docker build -t aryoyudhanto/label label

docker image inspect aryoyudhanto/label

# ADD INSTRUCTION 

#instruksi ADD digunakan untuk menambahkan file dari source (laptop kita, url) ke dalam folder destination di Docker Image
#perintah add dapat mendeteksi file sudah di kompress atau belum (tar.gz, zip, dll) ,
#jika sudah dikompress file akan otomatis diextract dalam folder destination
#bisa digunakan untuk banyak penambahan file sekaligus
#penambahan banyak file sekaligus menggunakan pattern (Match Pattern) di Go-lang
#jika source dari laptop kita, maka file yang akan diambil yaitu sejajar dengan file Docekerfile kita

#format ADD instruksi sbb:
#ADD soure destination
#ADD world.txt hello -> menambahkan file world.txt ke folder hello
#ADD *.txt hello -> menambahkan semua file .txt ke folder hello

ADD text/*.txt hello

docker build -t aryoyudhanto/add add

#coba run image aryoyudhanto/add dengan container
docker container create --name add aryoyudhanto/add

docker container start add

docker container logs add

# COPY INSTRUCTION

#instruksi COPY dapat digunakan untuk menambahkan file dari source (laptop kita) ke dalam folder destination di Docker Image
#COPY hanya menambhakan file saja, tidak seperti ADD.
#instruksi COPY merupakan best practicenya.

#format instruksi COPY
#COPY source destination
#COPY world.txt hello -> menambah file world.txt ke folder hello
#COPY *.txt hello -> menambah semua file .txt ke folder hello

COPY text/*.txt hello

docker build -t aryoyudhanto/copy copy

#coba run image aryoyudhanto/copy dengan container
docker container create --name copy aryoyudhanto/copy

docker container start copy

docker container logs copy

# .dockerignore FILE

#saat melakukan perintah ADD atau COPY, docker akan membaca file .dockerignore terlebih dahulu
#.dockerignore sama seperti gitignore yaitu menyebutkan file-file yang ingin diignore
#.docekrignore juga mendukung ignore folder atau RegEx

docker build -t aryoyudhanto/ignore ignore

#coba run image aryoyudhanto/ignore dengan container
docker container create --name ignore aryoyudhanto/ignore

docker container start ignore

docker container logs ignore

# EXPOSE INSTRUCTION

#EXPOSE adalah instruksi untuk memberitahu bahwa container akan listen port pada nomor dan protocol tertentu
#EXPOSE tidak akan mempublish port apapun,
#EXPOSE digunakan sebagai dokumentasi untuk memberitahu yang membuat docker container,
#bahwa docker image ini akan menggunakan port tertentu ketika dijalankan menjadi docker container

#format instruksi EXPOSE
#EXPOSE port -> defaultnya menggunakan TCP
#EXPOSE port/tcp
#EXPOSE port/udp

EXPOSE 8080

docker build -t aryoyudhanto/expose expose

docker image inspect aryoyudhanto/expose

#coba run image aryoyudhanto/expose dengan container
docker container create --name expose -p 8080:8080 aryoyudhanto/expose

docker container start expose

docker container ls

docker container stop expose

# ENV INSTRUCTION

#ENV yang sudah didefinisikan pada dockerfile, bisa digunakan kembali dengan sintaks ${NAMA_ENV}
#instruksi ENV akan menyimpan env pada docker image dan dapat dilihat dengan perintah docker image inspect
#env juga bisa diganti nilainya ketika pembuatan docker container dengan perintah --env key=value

#format penulisan instruksi ENV
#ENV key=value
#ENV key1=value1 key2=value2 ..

ENV APP_PORT=8080

docker build -t aryoyudhanto/env env

docker image inspect aryoyudhanto/env

docker container create --name env --env APP_PORT=9090 -p 9090:9090 aryoyudhanto/env

docker container start env

docker container logs env

# VOLUME INSTRUCTION

#instruksi untuk membuat volume secara otomatis ketika kita membuat docker
#semua file yang terdapat pada volume akan dicopy otomatis ke Docker Volume

#format instruksi VOLUME
#VOLUME /lokasi/folder
#VOLUME /lokasi1/folder1 lokasi2/folder2
#VOLUME ["/lokasi1/folder","lokasi2/folder2","..."]

VOLUME ${APP_DATA} #ke folder /logs, karena APP_DATA=/logs

docker build -t aryoyudhanto/volume volume

docker image inspect aryoyudhanto/volume

docker container create --name volume -p 8080:8080 aryoyudhanto/volume

docker container start volume

docker container logs volume

docker container inspect volume

#nama volume pada container = 62648275db89be8bfbca305043a6f212eb78ee000c30b5edc970176e8b8417c8

docker volume ls

# WORKING DIRECTORY INSTRUCTION

#instruksi WORKDIR digunakan untuk menentukan direktori atau folder untuk menjalankan instruksi RUN, CMD, ENTRYPOINT, COPY dan ADD
#jika membuat WORKDIR tetapi foldernya tidak ada, maka otomatis direktorinya akan dibuat
#jika WORKDIR nya adalah relative path, maka secara otomatis akan masuk ke direktori dari WORKDIR sebelumnya
#contoh: WORKDIR a, kemudian WORKDIR b, maka working direktorinya akan dilakukan di folder b yang ada di dalam folder a.
#WORKDIR juga bisa digunakan sebagai path untuk lokasi pertama kali ketika masuk ke dalam container

#format instruksi WORKDIR
#WORKDIR /app (absolute path) -> artinya working directorynya di /app (absolute path)
#WORKDIR docker (relative path) -> artinya sekarang working directorynya di /app/docker
#WORKDIR /home/app -> artinya sekarang working directorynya di/home/app

WORKDIR /app

docker build -t aryoyudhanto/workdir workdir

docker container create --name workdir -p 8080:8080 aryoyudhanto/workdir

docker container start workdir

docker container exec -i -t workdir /bin/sh

docker container stop workdir

# USER INSTRUCTION

#instruksi user digunakan untuk mengubah user atau user grup ketika docekr dijalankan
#secara default docker akan menggunakan user root, dalam beberapa kasus ada aplikasi yang tidak dijalankan dengan user root
#maka dari itu mengubahnya menggunakan USER instruction

#format USER instruction:
#USER <user> -> mengubah user
#USER <user>:<group> -> mengubah user dan user group

USER yudhauser

docker build -t aryoyudhanto/user user

docker container create --name user -p 8080:8080 aryoyudhanto/user

docker container start user

docker container exec -i -t user /bin/sh

docker container stop user

# ARGUMENT INSTRUCTION

#instruksi ARG digunakan untuk mendefinisikan variable yang bisa digunakan oleh pengguna untuk dikirim ketika-
#melakukan proses docker build menggunakan perintah --build-arg key=value
#ARG hanya digunakan saat build time, artinya hanya berjalan dalam docker container
#ARG tidak digunakan, berbeda dengan ENV yang digunakan dalam container
#cara akses variabel ARG yaitu ${variable_name}

#format instruksi ARG
#ARG key -> membuat argument variable
#ARG key=defaultvalue -> membuat argument variable dengan default value jika tidak diisi

ARG app=main

docker build -t aryoyudhanto/arg arg --build-arg app=yudha

docker container create --name arg -p 8080:8080 aryoyudhanto/arg

docker container start arg

docker container exec -i -t arg /bin/sh

docker container logs arg

docker image inspect aryoyudhanto/arg

#container tidak jalan karena ARG bisa diakses hanya saat build time, sedangkan CMD dijalankan saat runtime
#jika ingin menggunakan ARG tersebut, maka kita ubah data ARG ke ENV.
#pada dockerfile tambah instruksi
ENV app=${app}

docker build -t aryoyudhanto/arg arg --build-arg app=yudha

docker container create --name arg -p 8080:8080 aryoyudhanto/arg

docker container start arg

docker container exec -i -t arg /bin/sh

docker container stop arg

# HEALTHCHECK INSTRUCTION

#instruksi HEALTHCHECK digunakan untuk mengecek apakah container berjalan dengan baikatau tidak
#jika terdapat HEALTHCHECK, container memiliki status health dari awal bernilai starting, 
#jika sukses maka bernilai healthy, jika gagal unhealthy

#format instruksi HEATHCHECK
#HEALTHCHECK NONE -> artinya disabled health check
#HEALTHCHECK [OPTIONS] CMD command
#OPTIONs: 
    #--interval=DURATION (default 30s)
    #--timeout=DURATION (default 30s)
    #--start-period=DURATION (default 0s)
    #--retries=N (default 3)

HEALTHCHECK --interval=5s --start-period=5s CMD curl -f http://localhost:8080/health

docker build -t aryoyudhanto/health health

docker container create --name health -p 8080:8080 aryoyudhanto/health

docker container start health

docker container ls

docker container inspect health

docker container stop health

# ENTRYPOINT INSTRUCTION

#instruksi ENTRYPOINT untuk menentukan executable file yang akan dijalankan oleh container
#ENTRYPOINT memiliki erat kaitannya dengan CMD
#saat membuat instruksi CMD tanpa executable file, secara otomatis CMD akan menggunakan ENTRYPOINT

#format instruksi ENTRYPOINT
#ENTRYPOINT ["exeutable", "param1", "param2", "..."]
#ENTRYPOINT exeutable param1 param2
#saat menggunakan CMD ["param1", "param2"], maka param tersebut akan dikirim ke ENTRYPOINT

ENTRYPOINT ["go", "run"]
CMD ["/app/main.go"]

docker build -t aryoyudhanto/entrypoint entrypoint

docker image inspect aryoyudhanto/entrypoint

docker container create --name entrypoint -p 8080:8080 aryoyudhanto/entrypoint

docker container start entrypoint

docker container stop entrypoint

# Multi Stage Build

#saat membuat dockerfile dengan base image yang besar, secara otomatis Image kita pun akan menjadi besar juga
#oleh karena itu gunakan base image yang memang kita butuhkan saja, jangan banyak install fitur di image yang tidak digunakan
#contoh yang dipakai sebelumnya golang, base imagenya saja sudah 300+ mb
#untuk mengatasinya kita bisa melakukan multi stage build

docker build -t aryoyudhanto/multi multi

docker image ls

docker container create --name multi -p 8080:8080 aryoyudhanto/multi

docker container start multi

docker container stop multi

# DOCKER HUB REGISTRY

#akses token belajar docker: dckr_pat_ejApM74aHLG72HJGvB43a4LY2bU
#docker login -u username
docker login -u aryoyudhanto
#kemudian akan muncul pengisian password, bisa isi pasword atau akses token yang sudah dibuat

#kemudian dapat melakukan Docker Push image yang sesuai dengan username kita, contoh: aryoyudhanto/multi
docker push aryoyudhanto/multi
#setelah itu akan di push ke docker hub registry repository

# DIGITAL OCEAN CONTAINER REGISTRY

