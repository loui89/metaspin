# metaspin

Convierte cualquier video en un archivo `.MOV` con la misma estructura QuickTime
que producen unas Ray-Ban Meta Smart Glasses 2, para que Instagram lo trate como
si hubiera sido grabado con ellas.

No necesitas tener los lentes. Todos los átomos se generan desde especificación,
así que no viaja ningún número de serie ni identificador de nadie.

---

## Qué se descubrió

Instagram decide si un video es "de lentes Meta" leyendo la estructura del
archivo, no los píxeles. Se probaron cuatro enfoques:

| Prueba | Qué se hizo | Resultado |
|---|---|---|
| A | Solo agregar la metadata Meta | falla |
| B | Metadata + reducir a dos pistas | falla |
| C | Metadata + clonar códec, resolución y color | falla |
| D | Reconstruir la estructura QuickTime completa | **funciona** |

La prueba D se confirmó con dos fuentes distintas: un video de iPhone y un MP4
H.264 editado sin relación con Meta. El origen del material no importa.

Comparando un archivo D que funcionó contra una grabación real de los lentes
salió algo útil: se diferenciaban en seis puntos estructurales y aun así
Instagram lo aceptó. Es decir, la verificación es más laxa de lo que parecía.
Esta herramienta genera solo lo que ambos archivos comparten.

### Lo que se reproduce

- Contenedor QuickTime, marca `qt  `, orden `ftyp` / `wide` / `mdat` / `moov`
- Átomo `meta` colgando directo de `moov`, no dentro de `udta`
- Metadata `com.apple.quicktime.*` con los valores de los lentes
- Handlers `Core Media Video`, `Core Media Audio` y `Core Media Data Handler`
- Átomo `tapt` con `clef`, `prof` y `enof`
- HEVC Main con etiqueta `hvc1` a 1376 × 1840, 30 fps
- Timescale de película 48000 y de video 600
- `colr` nclc 9/18/9, o sea BT.2020 con transferencia HLG
- AAC LC a 48 kHz estéreo
- Exactamente dos pistas

### Lo que se descartó

El átomo `amve` aparecía marcado como posible disparador. No lo es: la grabación
real de los lentes no lo tiene, y un archivo que sí lo tenía funcionó igual.
Lo mismo pasa con `chrm`, `sgpd`, `sbgp`, `cslg` y el orden de los átomos dentro
de `stbl`.

---

## Instalación

### 1. Python

macOS ya lo trae en cuanto instalas las herramientas de línea de comandos de
Apple. Si el programa te dice que falta, abre Terminal y pega:

```
xcode-select --install
```

### 2. ffmpeg

Descárgalo de [ffmpeg.martin-riedl.de](https://ffmpeg.martin-riedl.de). Elige tu
tipo de Mac y usa el instalador, que viene firmado y notarizado por Apple.
Necesitas los dos programas: `ffmpeg` y `ffprobe`.

### 3. Esta herramienta

```
git clone https://github.com/loui89/metaspin.git
cd metaspin
```

Descargar el ZIP desde la web también funciona, pero macOS marca en cuarentena
todo lo que viene de un ZIP y tendrás que autorizar el archivo a mano. Con
`git clone` no pasa.

---

## Uso

**Con doble clic:** arrastra tus videos a la carpeta `entrada` y da doble clic a
`Convertir.command`. Los resultados salen en `salida`.

La primera vez macOS puede poner dos peros, los dos de una sola vez:

Abre Terminal y pega estas dos líneas, ajustando la ruta a donde tengas la
carpeta. La forma fácil de escribir la ruta es arrastrar el archivo desde el
Finder a la ventana de Terminal:

```
chmod +x /ruta/a/metaspin/Convertir.command
xattr -d com.apple.quarantine /ruta/a/metaspin/Convertir.command
```

La primera devuelve el permiso de ejecución, que se pierde al descargar un ZIP.
La segunda quita la marca de cuarentena que macOS le pone a todo lo que viene de
internet. Ninguna responde nada si salió bien.

Si clonaste con `git clone` en vez de descargar el ZIP, no necesitas ninguna de
las dos.

### Si prefieres no usar el doble clic

Funciona igual corriendo el programa directo, y así te ahorras todo lo anterior:

```
python3 /ruta/a/metaspin/metaspin.py
```

**Desde Terminal:**

```
python3 metaspin.py                          # convierte la carpeta entrada
python3 metaspin.py video.mp4 ./salida       # convierte un archivo suelto
```

---

## Cómo pasarlo al teléfono

El archivo se rompe si pasa por un servicio que lo reescriba.

1. AirDrop del `.MOV` al iPhone. **No** por WhatsApp, Telegram ni Drive.
2. Guardar en Fotos.
3. Subir a Instagram normal.

---

## Notas

- El video se recorta a 1376 × 1840 vertical, que es lo que graban los lentes.
  Si tu fuente es horizontal vas a perder los lados.
- Si tu fuente ya viene en BT.2020 HLG, como un iPhone grabando en HDR, no se
  reconvierte el color. Convertir dos veces aplana el contraste.
- La metadata original de tu video, incluida la ubicación GPS, se elimina.
- Cada archivo lleva un identificador nuevo generado al momento.
- La duración es libre. No hay límite de ocho segundos.

## Aviso

Esto documenta el comportamiento de un producto de terceros. Instagram puede
cambiarlo cuando quiera y dejar de funcionar sin previo aviso.

## Licencia

MIT
