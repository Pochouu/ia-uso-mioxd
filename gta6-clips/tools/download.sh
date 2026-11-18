#!/usr/bin/env bash
# Descarga un video PÚBLICO a media/raw y anota el link de origen y el crédito.
# Uso: tools/download.sh <url> <@creador>
# Reglas: sólo posts públicos, nada filtrado/borrado/protegido. Crédito no es permiso: pedirlo si se puede.
set -euo pipefail
url="${1:?falta url}"; credit="${2:?falta @creador}"
dir="$(cd "$(dirname "$0")/.." && pwd)/media/raw"
id="$(date +%Y%m%d-%H%M%S)"
yt-dlp -f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[height<=1080]/b" --merge-output-format mp4 \
  -o "$dir/$id.%(ext)s" "$url"
printf 'source: %s\ncredit: %s\ndownloaded: %s\n' "$url" "$credit" "$(date -Iseconds)" > "$dir/$id.source.txt"
echo "$dir/$id.mp4"
