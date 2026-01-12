#!/usr/bin/env bash
set -e

BASE_DIR="$PWD"
dir="flask_app"  # <-- sem $ e sem espaço
echo "Atualizando serviço: $BASE_DIR/$dir"
cd "$BASE_DIR/$dir"
COMMIT_MSG="$(git log -1 --pretty=%B)"

echo "Deploy em: $BASE_DIR"
echo "Commit: $COMMIT_MSG"

if echo "$COMMIT_MSG" | grep -qiE '\b(fresh|rebuild)\b'; then
  echo "Fresh deploy (down + build + up)"
  docker compose down
  docker compose up -d --build

elif echo "$COMMIT_MSG" | grep -qiE '\b(reset-db|wipe)\b'; then
  echo "RESET TOTAL (inclui volumes)"
  docker compose down -v
  docker compose up -d --build

else
  echo "Deploy rápido"
  docker compose restart || {
    echo "Containers não existem ainda, subindo stack"
    docker compose up -d
  }
fi
