#!/usr/bin/env bash
# Hace un clip vertical 1080x1920 listo para Reels/TikTok/Shorts:
#   video centrado sobre fondo desenfocado, HOOK arriba, crédito abajo, captions .srt opcionales.
# Uso: tools/clip.sh <input.mp4> <inicio> <fin> "<HOOK>" "<@creador>" <salida.mp4> [captions.srt]
#   inicio/fin: segundos o hh:mm:ss.  Recomendado 7–30 s, sin aire muerto, termina en el payoff.
set -euo pipefail
in="${1:?input}"; ss="${2:?inicio}"; to="${3:?fin}"; hook="${4:?hook}"; credit="${5:?credito}"; out="${6:?salida}"; srt="${7:-}"
font=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
printf '%s' "$hook" | fold -s -w 20 | sed 's/ *$//' > "$tmp/hook.txt"   # parte el hook en líneas
printf '%s' "$credit" > "$tmp/credit.txt"
vf="[0:v]split[a][b];\
[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:2,eq=brightness=-0.15[bg];\
[b]scale=1080:-2:force_original_aspect_ratio=decrease[fg];\
[bg][fg]overlay=(W-w)/2:(H-h)/2,\
drawtext=fontfile=$font:textfile=$tmp/hook.txt:fontsize=76:line_spacing=12:fontcolor=white:borderw=6:bordercolor=black:x=(w-text_w)/2:y=230,\
drawtext=fontfile=$font:textfile=$tmp/credit.txt:fontsize=44:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h-260"
if [[ -n "$srt" ]]; then
  vf="$vf,subtitles='$srt':force_style='FontName=DejaVu Sans,Bold=1,FontSize=11,Outline=2,Alignment=2,MarginV=75'"
fi
vf="$vf[v]"
ffmpeg -hide_banner -loglevel error -y -ss "$ss" -to "$to" -i "$in" \
  -filter_complex "$vf" -map "[v]" -map 0:a? \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 160k -movflags +faststart "$out"
echo "$out"
