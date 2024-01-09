#!/bin/bash

echo "${whereis node}" > node.details &&
yarn install --prefer-offline --frozen-lockfile --non-interactive --production=false &&
yarn run db:migrate_all && yarn run db:generate &&
yarn run build &&
rm -rf node_modules &&
yarn cache clean &&
yarn install --production &&
pm2 delete dev-api &&
pm2 start build/src/index.js --name=backend-api &&

sudo chown -R ubuntu:www-data /var/www/backend &&

pm2 restart all &&
sudo service nginx restart