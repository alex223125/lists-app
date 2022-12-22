# README

Preparations:

Navigate to rails app:

```
# remove all containers 
docker-compose down -v

# create build 
docker-compose up -d --build

# prepare database 
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

# Access app 
```http://192.168.2.90:8080/```