# GTA 6 clips: página faceless

Manual completo: [playbook.md](playbook.md). Estructura según la sección 15.

## Herramientas (necesitan `ffmpeg` y `yt-dlp`: `pip install yt-dlp`)
```bash
# 1) Descargar un video PÚBLICO con su crédito (queda anotado en media/raw/*.source.txt)
tools/download.sh "https://..." "@creador"

# 2) Clip vertical 1080x1920 (Reels/TikTok/Shorts): hook arriba, crédito abajo, captions .srt opcionales
tools/clip.sh media/raw/VIDEO.mp4 12 27 "THE HIDDEN CAR NOBODY FOUND" "@creador" media/edits/clip01.mp4 [captions.srt]

# 3) Recorte horizontal 1080p para X
tools/landscape_x.sh media/raw/VIDEO.mp4 0 45 media/edits/clip01_x.mp4
```
Salida: MP4 H.264 + AAC, 1080p, faststart.
