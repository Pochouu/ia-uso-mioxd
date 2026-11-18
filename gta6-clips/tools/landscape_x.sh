#!/usr/bin/env bash
# Recorte horizontal 1080p para X (trailers horizontales funcionan nativos en X). Máx 140 s sin Premium.
# Uso: tools/landscape_x.sh <input.mp4> <inicio> <fin> <salida.mp4>
set -euo pipefail
ffmpeg -hide_banner -loglevel error -y -ss "$2" -to "$3" -i "$1" \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -c:v libx264 -crf 20 -pix_fmt yuv420p -c:a aac -b:a 160k -movflags +faststart "$4"
echo "$4"
