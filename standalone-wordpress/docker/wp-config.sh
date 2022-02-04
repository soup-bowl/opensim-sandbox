#!/bin/bash
wp core install --url="localhost:8082" --title="OpenSimulator" --admin_user="admin" --admin_password="password" --admin_email="code@example.com" --skip-email --allow-root
wp plugin install opensimulator-bridge --allow-root
wp plugin activate opensimulator-bridge --allow-root
wp option add wpos  --format=json '{"address":"http:\/\/metaverse:9000","secret":"password","allowedlastnames":""}' --allow-root
