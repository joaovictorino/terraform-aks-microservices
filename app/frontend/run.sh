#!/bin/sh

echo "replacing address backend to ${APP_API}"
sed -i 's,http://localhost:8000/,'$APP_API',g' /usr/share/nginx/html/scripts/app.js

echo "starting nginx"
nginx -g 'daemon off;'