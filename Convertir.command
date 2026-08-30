#!/bin/bash
# Doble clic aqui para convertir todo lo que este en la carpeta "entrada".

cd "$(dirname "$0")" || exit 1

# Lugares donde suele quedar ffmpeg cuando se instala sin Homebrew
export PATH="/usr/local/bin:/opt/homebrew/bin:/opt/local/bin:$PATH"

echo ""
echo "  metaspin"
echo "  ────────────────────────────────────────────"
echo ""

if ! command -v python3 >/dev/null 2>&1; then
  echo "  Falta Python."
  echo ""
  echo "  Abre la app Terminal y pega esto:"
  echo "      xcode-select --install"
  echo ""
  echo "  Sale una ventana de instalacion. Cuando termine,"
  echo "  vuelve aqui y da doble clic otra vez."
  echo ""
  read -n 1 -s -r -p "  Presiona cualquier tecla para cerrar."
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  echo "  Falta ffmpeg."
  echo ""
  echo "  Bajalo de:  https://ffmpeg.martin-riedl.de"
  echo "  Elige tu Mac (Apple Silicon o Intel) y usa el instalador,"
  echo "  que viene firmado por Apple y no da problemas."
  echo ""
  echo "  Necesitas ffmpeg y tambien ffprobe."
  echo ""
  read -n 1 -s -r -p "  Presiona cualquier tecla para cerrar."
  exit 1
fi

mkdir -p entrada salida

if [ -z "$(ls -A entrada 2>/dev/null | grep -v '^\.')" ]; then
  echo "  La carpeta \"entrada\" esta vacia."
  echo ""
  echo "  Arrastra ahi los videos que quieras convertir"
  echo "  y da doble clic aqui otra vez."
  echo ""
  open entrada
  read -n 1 -s -r -p "  Presiona cualquier tecla para cerrar."
  exit 0
fi

python3 metaspin.py
STATUS=$?

echo ""
if [ $STATUS -eq 0 ]; then
  open salida
fi
read -n 1 -s -r -p "  Presiona cualquier tecla para cerrar."
echo ""
