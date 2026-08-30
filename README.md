# metaspin

*[Español](README.es.md)*

Rewrites any video into a `.MOV` carrying the same QuickTime structure that
Ray-Ban Meta Smart Glasses 2 produce, so Instagram treats it as glasses footage
and enables Spin View.

You do not need the glasses. Every atom is generated from spec, so no serial
number or device identifier from anyone else travels inside your files.

---

## What was found

Instagram decides whether a video came from Meta glasses by reading the file
structure, not the pixels. Four approaches were tested against a real account:

| Test | Approach | Result |
|---|---|---|
| A | Add the Meta metadata tags only | fails |
| B | Metadata plus reducing to two tracks | fails |
| C | Metadata plus matching codec, resolution and color | fails |
| D | Rebuild the full QuickTime structure | **works** |

Test D was confirmed on two unrelated sources: an iPhone HDR recording and an
edited H.264 MP4. Where the footage came from does not matter.

Comparing a working D file against a genuine glasses recording turned up
something more useful. **They differed in six structural points and Instagram
accepted it anyway.** The check is far looser than a strict structural clone.
This tool generates only what both files share.

### Reproduced

- QuickTime container, `qt  ` brand, `ftyp` / `wide` / `mdat` / `moov` order
- `meta` atom as a direct child of `moov`, not nested inside `udta`
- `com.apple.quicktime.*` metadata with the device values
- `Core Media Video`, `Core Media Audio` and `Core Media Data Handler` handlers
- `tapt` atom with `clef`, `prof` and `enof`
- HEVC Main tagged `hvc1` at 1376 x 1840, 30 fps
- Movie timescale 48000, video timescale 600
- `colr` nclc 9/18/9, meaning BT.2020 with HLG transfer
- AAC LC at 48 kHz stereo
- Exactly two tracks

### Ruled out

The `amve` atom was suspected of being the trigger. It is not: the genuine
glasses recording does not contain it, and a file that did contain it worked
anyway. The same goes for `chrm`, `sgpd`, `sbgp`, `cslg`, and atom ordering
inside `stbl`.

---

## Install

### 1. Python

macOS ships it once Apple's command line tools are installed. If the program
says it is missing, open Terminal and run:

```
xcode-select --install
```

### 2. ffmpeg

Download it from [ffmpeg.martin-riedl.de](https://ffmpeg.martin-riedl.de). Pick
your Mac type and use the installer, which is signed and notarized by Apple, so
Gatekeeper will not fight you. You need both `ffmpeg` and `ffprobe`.

### 3. This tool

```
git clone https://github.com/loui89/metaspin.git
cd metaspin
```

Downloading the ZIP works too, but macOS quarantines anything that arrives that
way and strips the executable bit. Cloning avoids both problems.

---

## Use

Drop your videos into the `entrada` folder and double click `Convertir.command`.
Results land in `salida`.

If you downloaded the ZIP instead of cloning, macOS will raise two objections.
Fix both at once, adjusting the path to wherever your folder is. The easy way to
type a path is to drag the file from Finder into the Terminal window:

```
chmod +x /path/to/metaspin/Convertir.command
xattr -d com.apple.quarantine /path/to/metaspin/Convertir.command
```

The first restores the executable bit lost during ZIP extraction. The second
removes the quarantine flag macOS attaches to downloads. Neither prints anything
on success.

### Skipping the launcher

Running the script directly works just as well and avoids all of the above:

```
python3 metaspin.py                       # convert the entrada folder
python3 metaspin.py clip.mp4 ./salida     # convert a single file
```

---

## Getting it onto your phone

The file breaks if it passes through anything that rewrites it.

1. AirDrop the `.MOV` to your iPhone. **Not** WhatsApp, Telegram or Drive.
2. Save to Photos.
3. Post to Instagram normally.

---

## Notes

- Video is cropped to 1376 x 1840 vertical, matching what the glasses record.
  Landscape sources will lose their sides.
- If your source is already BT.2020 HLG, such as an iPhone shooting HDR, the
  color is left alone. Converting twice flattens contrast.
- All original metadata is stripped, GPS coordinates included.
- Each output carries a freshly generated identifier.
- Duration is unconstrained. There is no eight second limit.

## Disclaimer

This documents the observed behavior of a third party product. Instagram can
change it at any time and this may stop working without notice.

## License

MIT
