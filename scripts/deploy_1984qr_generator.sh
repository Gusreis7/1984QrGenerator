#!/usr/bin/env bash
set -e

BASE_DIR="$PWD"
dir="flask_app"

echo "Atualizando serviço: $BASE_DIR/$dir"
cd "$BASE_DIR/$dir"

COMMIT_MSG="$(git log -1 --pretty=%B)"

echo "Deploy em: $BASE_DIR"
echo "Commit:"
echo "$COMMIT_MSG"
echo "-----------------------------------"

if echo "$COMMIT_MSG" | grep -qi '\[REBUILD\]'; then
  echo "🔄 REBUILD detectado"
  docker compose down
  docker compose up -d --build

elif echo "$COMMIT_MSG" | grep -qi '\[RESET\]'; then
  echo "💥 RESET TOTAL detectado (inclui volumes)"
  docker compose down -v
  docker compose up -d --build

else
  echo "⚡ Deploy rápido (restart)"
  docker compose restart || {
    echo "Containers não existem ainda, subindo stack"
    docker compose up -d
  }
fi
