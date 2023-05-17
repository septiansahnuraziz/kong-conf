    docker run -d --name=kong-database --network=kong-net -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong" -e "POSTGRES_PASSWORD=kong" postgres:9.6
    
    docker run --rm --network=kong-net -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" -e "KONG_PG_PASSWORD=kong" -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" kong:latest kong migrations bootstrap

    docker run  -d --detach --name kong --network=kong-net -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" -e "KONG_PG_PASSWORD=kong" -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -e "KONG_PROXY_LISTEN=0.0.0.0:8000, 0.0.0.0:8443 http2 ssl" -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system" -p 80:8000 -p 443:8443 -p 0.0.0.0:8001:8001 -p 0.0.0.0:8444:8444 kong:2.5-ubuntu

    docker run -d -p 1337:1337 --network=kong-net --name konga -v /var/data/kongadata:/app/kongadata -e "NODE_ENV=production" pantsel/konga

    docker run --rm --network=kong-net pantsel/konga -c prepare -a postgres -u postgresql://kong:kong@kong-database:5432/konga_db

docker run --detach --name kong \
  --network kong-net \
  -p "80:8000" \
  -p "443:8443" \
  -p "8001:8001" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000, 0.0.0.0:8443 http2 ssl" \
  -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system" \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_DATABASE=kong" \
  -e "KONG_PG_USER=kong" \
  -e "KONG_PG_PASSWORD=kong" \
  kong:2.5-ubuntu

  

# M-Product Service
    docker build -t m-product .

    docker run -d --restart always --name m-product \
	--network=kong-net \
	-p 8082:8082 \
	m-product


# M-Auth Servcie
    docker build -t m-auth .

    docker run -d --restart always --name m-auth \
	--network=kong-net \
	-p 8081:8081 \
	m-auth

# M-Content Servcie
    docker build -t m-content .

    docker run -d --rm --name m-content \
	--network=kong-net \
	-p 8085:8085 \
	m-content

# M-External Servcie
    docker build -t m-external .

    docker run -d --rm --name m-external \
	--network=kong-net \
	-p 8083:8083 \
	m-external

# M-Notification Servcie
    docker build -t m-notification .

    docker run -d --restart always --name m-notification \
	--network=kong-net \
	-p 8086:8086 \
	m-notification

# M-Order Servcie
    docker build -t m-order .

    docker run -d --restart always --name m-order \
	--network=kong-net \
	-p 8087:8087 \
	m-order

# M-Supplier Servcie
    docker build -t m-supplier .

    docker run -d --rm --name m-supplier \
	--network=kong-net \
	-p 8088:8088 \
	m-supplier

# M-User Servcie
    docker build -t m-user .

    docker run -d --restart always --name m-user \
	--network=kong-net \
	-p 8084:8084 \
	m-user

# M-Payment Servcie
    docker build -t m-payment .

    docker run -d --restart always --name m-payment \
	--network=kong-net \
	-p 8089:8089 \
	m-payment
	
	
# M-callback Servcie
    docker build -t jabulmart-callback .

    docker run -d --restart always --name m-callback \
	--network=kong-net \
	-p 8090:8090 \
	m-callback


 docker build -t w-fe .
 
  docker run -d --restart always --name w-fe \
	--network=kong-net \
	-p 8090:8090 \
	w-fe


curl --request POST \
  --url http://jabulmart.id:8001/plugins \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data name=acme \
  --data 'config.domains=*.jabulmart.id' \
  --data config.tos_accepted=true \
  --data config.account_email=jabulmart@gmail.com \
  --data config.storage=kong-database

  curl http://localhost:8001/plugins \
  -d name=acme \
  -d config.account_email=jabulmart@gmail.com \
  -d config.tos_accepted=true \
  -d config.domains[]=jabulmart.id

  curl http://localhost:8001/routes \
  -d name=acme-dummy \
  -d paths[]=/.well-known/acme-challenge \
  -d service.name=acme-dummy


  curl --request POST \
  --url http://localhost:8001/plugins \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data name=acme \
  --data config.domains=jabulmart.id \
  --data config.tos_accepted=true \
  --data config.account_email=youremail@domain \
  --data config.storage=redis \
  --data config.storage_config.redis.auth=A-SUPER-STRONG-DEMO-PASSWORD \
  --data config.storage_config.redis.port=6379 \
  --data config.storage_config.redis.database=0 \
  --data config.storage_config.redis.host=redis-demo



  curl http://localhost:8001/acme -d host=jabulmart.id -d test_http_challenge_flow=true




  curl http://jabulmart.id:8001/acme -d host=jabulmart.id


curl http://localhost:8001/acme -d host=jabulmart.id -d test_http_challenge_flow=true





curl --request POST \
  --url http://localhost:8001/services/dummy-service/routes \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data name=dummy-route \
  --data hosts=acme.jabulmart.id \
  --data protocols=http \
  --data paths=/.well-known/acme-challenge


  curl --request POST \
  --url http://localhost:8001/plugins \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data name=acme \
  --data 'config.domains=*.jabulmart.id' \
  --data config.tos_accepted=true \
  --data config.account_email=jabulmart@gmail.com \
  --data config.storage=kong


  curl -k -X POST \
  https://jabulmart.id:8444/certificates \
  -H 'Content-Type: multipart/form-data' \
  -F cert=@./jabulmart.id.pem \
  -F key=@./jabulmart.id.key \
  -F snis[]=jabulmart.id



curl -i -X POST http://jabulmart.id:8001/apis \
-d "name=ssl-demo" \
-d "upstream_url=http://jabulmart.id/requests" \
-d "hosts=jabulmart.id"


curl -i https://jabulmart.id:8443/ \
-H "Host: jabulmart.id"

  openssl x509 -req -in jabulmart.id.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out jabulmart.id.pem -days 1825 -sha256 -extfile jabulmart.id.ext
