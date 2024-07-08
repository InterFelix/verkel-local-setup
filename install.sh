#!/bin/bash
echo "================================================================================"
echo "Generating certs..."
echo "================================================================================"
echo ""
mkdir -p ./nginx/certs
openssl dhparam -out ./nginx/certs/dhparam.pem 2048
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./nginx/certs/nginx-selfsigned.key -out ./nginx/certs/nginx-selfsigned.crt -subj "/C=DE/ST=SH/L/Grosszerlang/O=VCP/CN=verkel"

echo "================================================================================"
echo "Generating secure passwords..."
echo "================================================================================"
echo ""
db_passwd=$(pwgen -s 16)
secret_key_base=$(pwgen -s 64)
sed -i "/POSTGRES_PASSWORD=/c\POSTGRES_PASSWORD=$db_passwd" ./env/postgres.env
sed -i "/DATABASE_PASSWORD=/c\DATABASE_PASSWORD=$db_passwd" ./env/verkel.env
sed -i "/SECRET_KEY_BASE=/c\SECRET_KEY_BASE=$secret_key_base" ./env/verkel.env

echo "================================================================================"
echo "Starting the compose stack..."
echo "================================================================================"
echo ""
docker compose up -d

echo "================================================================================"
echo "Waiting for verkel to start..."
echo "================================================================================"
echo ""
sleep 10s

echo "================================================================================"
echo "Loading verkel db migrations..."
echo "================================================================================"
echo ""
docker compose exec -it verkel bundle exec rails db:schema:load
docker compose exec -it verkel bundle exec rails hunger_factor:import

echo "================================================================================"
echo "Creating initial admin user..."
echo "================================================================================"
read -p 'Enter email address for initial admin user: ' admin_email
read -sp 'Enter password for initial admin user: ' admin_password
docker compose exec -it verkel bundle exec rails runner "User.create(email: '$admin_email', password: '$admin_password', role: :admin)"

echo "================================================================================"
echo "All done!"
echo "================================================================================"
echo ""
