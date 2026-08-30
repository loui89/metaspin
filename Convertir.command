#!/bin/bash
# Double click to convert everything sitting in the "entrada" folder.

cd "$(dirname "$0")" || exit 1

# Where ffmpeg lands when installed without Homebrew
export PATH="/usr/local/bin:/opt/homebrew/bin:/opt/local/bin:$PATH"

echo ""
echo "  metaspin"
echo ""

if ! command -v python3 >/dev/null 2>&1; then
  echo "  Python is missing."
  echo ""
  echo "  Open Terminal and paste this:"
  echo "      xcode-select --install"
  echo ""
  echo "  An installer window appears. When it finishes,"
  echo "  come back and double click again."
  echo ""
  read -n 1 -s -r -p "  Press any key to close."
  exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
  echo "  ffmpeg is missing."
  echo ""
  echo "  Get it from:  https://ffmpeg.martin-riedl.de"
  echo "  Pick your Mac (Apple Silicon or Intel) and use the installer,"
  echo "  which is signed by Apple and installs cleanly."
  echo ""
  echo "  You need both ffmpeg and ffprobe."
  echo ""
  read -n 1 -s -r -p "  Press any key to close."
  exit 1
fi

mkdir -p entrada salida

if [ -z "$(ls -A entrada 2>/dev/null | grep -v '^\.')" ]; then
  echo "  The \"entrada\" folder is empty."
  echo ""
  echo "  Drop the videos you want to convert in there"
  echo "  and double click here again."
  echo ""
  open entrada
  read -n 1 -s -r -p "  Press any key to close."
  exit 0
fi

python3 metaspin.py
STATUS=$?

echo ""
if [ $STATUS -eq 0 ]; then
  open salida
fi
read -n 1 -s -r -p "  Press any key to close."
echo ""
