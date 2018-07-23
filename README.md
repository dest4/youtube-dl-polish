# youtube-dl-polisher
Convert, normalize, tag and rename youtube-dl downloads

## Outline
These small bash scripts help you manage the musics downloaded from Youtube.
- Convert to MP3 or M4A/AAC, to ensure better compatibility with playing systems
- Normalize audio using MP3Gain or AACGain
- Add tags, using MPGtx an AtomicParsley
- Rename files using the "Artist - Title" format.

## Installation
For this to work, you need to manually install
- [youtube-dl](https://rg3.github.io/youtube-dl/download.html): have this available in your path, i.e. `youtube-dl --version` should work
- [AtomicParsley](https://bitbucket.org/wez/atomicparsley/downloads/): unzip the archive in the `wez-atomicparsley/` subdirectory, then compile it.

Also do:
```
sudo apt-get install mp3gain aacgain mpgtx ffmpeg
```
## Usage
`./yt.sh YOUTUBEID` where `YOUTUBEID` is the set of 8 to 10 characters at the end of Youtube URLs.
Converted files are stored in the `output/` subfolder.

### Disclaimer
I am not a lawyer. Use of this script at your own risk.

### License
MIT
