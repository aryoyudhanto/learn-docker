# MEMBUAT CONTAINER

    #konfigurasi container pada file docker-compose
    #masuk ke direktori dimana file docker-compose berada
    #jalankan create container dengan perintah
    docker compose create

# MENJALANKAN CONTAINER

    #setelah membuat container, container tidak akan berjalan otomatis
    #jalnkan manual dengan perintah
    docker compose start

# MELIHAT CONTAINER

    #melihat disini yaitu melihat container yang ada dalam file docker-compose
    #untuk melihatnya jalankan perintah
    docker compose ps

# MENGHENTIKAN CONTAINER

    #perintah ini hanya untuk menghentikan saja, tidak menghapus containernya
    #untuk menghentikan container jalankan perintah
    docker compose stop

# MENGHAPUS CONTAINER

    #dapat menghapus secara manual yaitu docker container rm, atau bisa dengan docker compose
    #perintah ini dapat menghapus semua container, network, dan volume yang digunakan container pada file docker-compose
    #untuk menghapusnya jalankan perintah berikut, walaupun container masih berjalan docker akan menghentikannya dan menghapusnya
    docker compose down

# PROJECT NAME

    #secara default project name nya adalah nama folder dimana lokasi file docker-compose.yaml
    #perintah untuk melihat daftar project yang berjalan
    docker compose ls

# Service 

    #dalam konfigurasi docker compose, container disimpan dalam konfigurasi services
    #kita bisa menambahkan satu satau lebih services

# Komentar

    #dalam konfigurasi docker compose, dokumentasi komentar ditandai dengan #

# Port

    #dalam membuat container kita bisa mengekspose port di container keluar dengan port forwarding
    #dalam konfigurasi docker-compose menggunakan atribut ports

    #Short Syntax
    #dalam menentukan port, cara pertama ada short syntax
    #berisi string port HOST:CONTAINER
    ports: "8080":"80"

    #Long Syntax
    #cara kedua ada long syntax
    #dibuat dalam bentuk objek yang berisi
    #target: Port dalam container
    #published: Port yang digunakan di host 
    #protocol: Protocol port (tcp atau udp)
    #mode: host untuk port tiap Node, atau ingress swarm mode. karena kita tidak memakai docker swarm, jadi cukup gunakannilai host
    ports:
        -protocol: tcp
         published: 8080
         target: 80
# Environment Variable

    #saat menggunakan konfigurasi file docker compose, menambahkan ENV dengan menggunakan atribut environment
    environment:
        MONGO_INITDB_ROOT_USERNAME: yudha
        MONGO_INITDB_ROOT_PASSWORD: yudha
        MONGO_INITDB_DATABASE: admin

# Bind Mount

    #kita bisa gunakan atribut volumes di services pada konfigurasi file docker-compose
    #bisa menambahkan satu atau lebih bind mount

    #Short Syntax
    #cara pertama dengan short syntax
    #kita bisa gunakan nilai SOURCE:TARGET:MODE
    #SOURCE: lokasi host, bisa realtive path (diawali .'titik') atau absolute path
    #TARGET: lokasih di container
    #MODE: mode di bind mount, ro untuk readonly, rw untuk read write
    volumes: 
        - "./data-mongo1:/data/db"
    
    #Long Syntax
    #kita bisa buat dalam nested object id volumes dengan atribut
    #type: tipe mount, yaitu volume atau bind 
    #source: sumber path di host atau nama volume
    #target: target path di container
    #read_only: flag readonly atau tidak, deafaultnya false
    volumes:
      - type: bind
        source: "./data-mongo2"
        target: "/data/db"
        read_only: false

# Volume
    
    #docker-compose juga dapat membuat volume
    #kita bisa gunakan atribut volumes di services pada konfigurasi file docker-compose
    
    #Short Syntax
    #cara pertama dengan short syntax
    #sama seperti menggunakan bind mount, dengan ketentuan
    #SOURCE ganti dengan nama volume
    volumes: 
        - "mongo-data1:/data/db"

    #Long Syntax
    #cara kedua dengan long syntax
    #sama seperti menggunakan bind mount, dengan ketentuan
    #TYPE ganti volume
    #SOURCE ganti nama volume
    volumes:
      - type: volume
        source: mongo-data2
        target: "/data/db"
        read_only: false

# Network

    #secara default semua container yang dibuat pada file docker-compose dihubungkan dengan-
    #Network bernama nama-project_default
    #sebenarnya tidak perlu membuat secara manual
    #cek dengan cara inspect container yang sudah berjalan menggunakan docker compose, cek pada bagian network

    #Tetapi kita tetap bisa membuat Network secara manual
    #bisa buat satu atau lebih network pada file docker-compose dengan atribut network yang kita tentukan:
    #name: nama network
    #driver: driver network seperti bridge, host atau none
    networks:
        network_example:
            name: network_example
            driver: bridge

    #jika network sudah dibuat, dan kita ingin menggunakannya di container
    #kita bisa menggunakan atribut network dengan menyebutkan salah satu network yg ingin digunakan
    networks:
        - network_example

# Depends On

    #saat membuat file docker-compose yang berisi banyak container
    #secara default container-container yang terdapat pada file docker-compose akan berjalan bersamaan
    #kadang kita membuat container yang butuh container lain sebelum berjalan
    #atau sederhananya, kita ingin ada urutan container berjalan
    
    #menggunakan atribut depends_on untuk menentukan urutan jalannya container
    #kita dapat menyebutkan misalnya pada container B hanya bisa berjalan jika container A, C, dll sudah berjalan
    #kita bisa menyebutkan satu atau lebih container pada atribut depends_on
    depends_on:
      - mongodb-example
    
# Restart

    #secara default saat container mati, maka docker tidak akan menjalankan kembali container nya
    #harus dijalankan lagi secara manual
    #kita bisa menggunakan atribut restart untuk menjalankan ulang, dengan beberapa value:
    #no: defaultnya tidak pernah restart
    #always: selalu restart jika container berhenti
    #on-failure: restart jika container error
    #unless-stopped: selalu restart container, kecuali dihentikan manual
    restart: always

# Monitor docker events

    #untuk melihat kejadian apa saja pada docker secara real-time
    #kita bisa menggunakan perintah: docker events
    docker events --filter 'container=mongodb-express-example'

# Resources Limit

    #kita bisa mengatur resources limit CPU dan memory pada konfigurasi file docker-compose
    #menggunakan atribut deploy, lalu didalamnya menggunakan atribut resources
    #didalam atribut resources kita bisa tentukan limit dan reservations
    #reservation adalah limit yang dijamin bisa digunakan oleh container
    #limit adalah limit maksimal untuk resources yang diberikan container, namun bisa saja limit ini rebutan dengan container lain

    deploy:
      resources:
        reservations:
          cpus: "0.25"
          memory: 50M
        limits:
          cpus: "0.5"
          memory: 100M

# Dockerfile

    #docker-compose juga bisa membuat container dari dockerfile yang kita buat
    #sehingga kita tidak perlu membuar image terlebih dahulu secara manual
    #semua bisa dilakukan secara otomatis oleh Dockerfile

# Build

    #ketika kita ingin membuat container dari dockerfile, kita sudah tidak memakai atribut image lagi.
    #gantinya kita mengguanakan atribut build, dimana terdapat atribut lainnya:
    #context: berisi path ke folder dockerfile
    #dockerfile: nama file dockerfile, bisa diganti jika mau
    #argsL arguments yang dibutuhkan ketika melakukan docker build

# Image Name

    #defaultnya, docker-compose akan membuat image dengan nama random ketika build dockerfile
    #jika ingin mengubahnya bis menambahkan atribut service secara otomatis docker-compose kan membuat image sesuai dengan nama itu

# Build Dockerfile

    #ketika menggunakan perintah docker compose start, 
    #secara otomatis docker compose akan melakukan build terlebih dahulu jika image nya belum ada
    #tapi jika kita hanya ingin membuat imagenya saja tanpa membuat container, 
    #gunakan perintah docker compose build
    docker compose build

# Menghapus Image

    #ketika melakukan perintah docker compose down, image yang sudah dibuild tidak akan dihapus
    #jadi untuk menghapusnya tetap docker image rm namaImage:tag

# Build Ulang

    #ketika kita mengubah code program kita, lalu kita stop dan start ulang container dengan docker compose,
    #program baru tersebut tidak langsung berjalan
    #hal ini karena image terbaru otomatis terbuat, tapi container sebelumnya masih menggunakan image yang lama
    #jika ingin menjalankan program yang baru ini kita harus down kan yang lama
    #dan buat ulang dengan container dan image yang baru

# Health Check

    #Secara default Container yang dibuat, baik itu secara manual ataupun menggunakan Docker Compose, 
    #pasti akan selalu menggunakan Health Check yang dibuat di Dockerfile
    #kita dapat mengubah di konfigurasi file docker compose pada atribut healthcheck pada services
    #healthcheck sendiri memiliki atribut yang mirip dengan Health Check di Dockerfile
    #test: berisikan cara melakukan test health check
    #interval: interval melakukan health check
    #timeout: timeout melakukan health check
    #retries: total retry ketika gagal
    #start_period: waktu mulai melakukan health check
    healthcheck:
      test: [ "CMD", "curl", "-f", "http://localhost:8080/health" ]
      interval: 5s
      timeout: 5s
      retries: 3
      start_period: 5s

# Extend Service

    #saat membuat aplikasi dengan docker, biasanya aplikasi tersebut dijalankan di beberapa server
    #di local laptop, di server development, atau di server production
    #

