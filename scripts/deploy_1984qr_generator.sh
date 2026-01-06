#!/usr/bin/env bash
set -e

BASE_DIR="$PWD"
$dir = "flask_app"
echo "Atualizando serviço: $BASE_DIR/$dir"
cd "$BASE_DIR/$dir"

docker compose down
docker compose up -d

 