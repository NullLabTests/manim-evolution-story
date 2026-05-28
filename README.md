# 🌌 Manim Evolution Story

[![Manim](https://img.shields.io/badge/Made%20with-Manim-8A2BE2)](https://www.manim.community/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://python.org)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-6.1-007808?logo=ffmpeg&logoColor=white)](https://ffmpeg.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Video Length](https://img.shields.io/badge/Video-4%20min%2001s-blue)](https://github.com/NullLabTests/manim-evolution-story)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-181717?logo=github)](https://github.com/NullLabTests/manim-evolution-story)
[![SoX](https://img.shields.io/badge/Audio-SoX-FF6600)](https://sox.sourceforge.net/)

**From the Big Bang to You: The Epic 13.8-Billion-Year Story of Evolution**

An educational animated video created with [Manim](https://www.manim.community/), the mathematical animation engine. This project renders a 4-minute journey through cosmic and biological evolution across 13 chapters:

| # | Chapter | Duration | Description |
|---|---------|----------|-------------|
| 1 | 🌟 Title | ~31s | Opening starfield and title sequence |
| 2 | 💥 Big Bang | ~18s | Singularity, inflation, first particles |
| 3 | ⭐ Star Formation | ~22s | Nebulae, protostars, nuclear fusion |
| 4 | 🪐 Solar System | ~18s | Planetary accretion, Earth forms |
| 5 | 🧬 Origin of Life | ~17s | Primordial soup, first cells |
| 6 | 🌿 Great Oxidation | ~16s | Cyanobacteria, oxygen atmosphere |
| 7 | 🔬 Eukaryotes | ~15s | Complex cells, mitochondria |
| 8 | 🦐 Cambrian Explosion | ~18s | Burgess Shale, body plans |
| 9 | 🌊 Sea to Land | ~14s | Tiktaalik, terrestrial life |
| 10 | 🐘 Rise of Mammals | ~21s | Triassic, Jurassic, mammals thrive |
| 11 | 🐒 Primate Lineage | ~12s | Early primates, bipedalism |
| 12 | 🧑 Human Evolution | ~16s | Homo genus, tools, civilization |
| 13 | 🏁 Conclusion | ~23s | Reflection on our place in the cosmos |

## 📋 Production Pipeline

All rendering was done **locally** using the following workflow:

### 1. Scene Authoring

Each chapter is a Manim `Scene` class written in Python. Two script files are provided:

- **`scripts/full_video.py`** — All 13 chapters in one continuous `FullStoryScene` for single-pass rendering
- **`scripts/create_longform_video.py`** — Individual scene classes for per-chapter rendering and iteration

### 2. Rendering

Scenes were rendered with Manim's CLI:

```bash
# Render individual scenes at 480p15 (low res for quick iteration)
manim -pql scripts/create_longform_video.py BigBangScene
manim -pql scripts/create_longform_video.py StarFormationScene
# ... etc for all 13 scenes

# Render the full master video
manim -pql scripts/full_video.py FullStoryScene
```

The `-pql` flag produces 480p15 output (`-pq` = production quality, `l` = low res). For higher quality, use `-pqh` (1080p60).

### 3. Assembly & Audio

All videos were assembled and enhanced using FFmpeg:

```bash
# Concatenate all 13 scenes into a master video
ffmpeg -f concat -safe 0 -i scene_list.txt -c copy FullEvolutionStory.mp4

# Generate ambient cinematic soundtrack (via FFmpeg audio filters)
ffmpeg -f lavfi -i "anoisesrc=d=245:c=pink:a=0.5" \
  -f lavfi -i "sine=frequency=55:duration=245" \
  -f lavfi -i "sine=frequency=110:duration=245" \
  -f lavfi -i "sine=frequency=165:duration=245" \
  -filter_complex "[1]volume=0.15[a];[2]volume=0.10[b];[3]volume=0.08[c];[0]volume=0.3[n];[a][b][c][n]amix=inputs=4:duration=first:weights=2 1.5 1 0.5,afade=t=in:ss=0:d=3,afade=t=out:st=240:d=5" \
  -ac 2 ambient_audio.wav

# Add audio to master video
ffmpeg -i FullEvolutionStory.mp4 -i ambient_audio.wav \
  -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest FullEvolutionStory_WithSound.mp4
```

### 4. Cinematic Upscale

One scene (`BigBangScene`) was upscaled to **4K (3840×2160)** with color grading to demonstrate professional-grade output:

```bash
ffmpeg -i BigBangScene.mp4 \
  -vf "scale=3840:2160:flags=lanczos,\
       eq=brightness=0.05:contrast=1.1:saturation=1.2,\
       unsharp=3:3:1.0:3:3:0.5" \
  -c:v libx264 -preset slow -crf 18 -b:v 40M \
  -c:a aac -b:a 192k \
  BigBangScene_4K_Cinematic.mp4
```

## 📁 Repository Structure

```
manim-evolution-story/
├── .github/
│   └── workflows/
│       └── render.yml              # GitHub Actions CI/CD for auto-rendering
├── .gitignore                      # Ignores cache, temp, and generated files
├── Makefile                        # Common commands (render-all, concat, audio, upscale)
├── README.md                       # This file
├── LICENSE                         # MIT License
├── requirements.txt                # Python dependencies (pip install -r)
├── media/
│   ├── master/
│   │   ├── FullEvolutionStory.mp4              # Complete video (no audio)
│   │   └── FullEvolutionStory_WithSound.mp4    # Complete video + ambient audio
│   └── scenes/
│       ├── BigBangScene.mp4                    # Individual scene
│       ├── BigBangScene_4K_Cinematic.mp4       # Upscaled 4K demo
│       ├── CambrianExplosionScene.mp4
│       ├── ConclusionScene.mp4
│       ├── EukaryotesScene.mp4
│       ├── GreatOxidationScene.mp4
│       ├── HumanEvolutionScene.mp4
│       ├── OriginOfLifeScene.mp4
│       ├── PrimateLineageScene.mp4
│       ├── RiseOfMammalsScene.mp4
│       ├── SeaToLandScene.mp4
│       ├── SolarSystemScene.mp4
│       ├── StarFormationScene.mp4
│       └── TitleScene.mp4
└── scripts/
    ├── create_longform_video.py   # Individual scene scripts
    └── full_video.py              # All-in-one master scene
```

## 🎬 Video Previews

| Scene | Preview |
|-------|---------|
| **Master** (with sound) | `media/master/FullEvolutionStory_WithSound.mp4` |
| **Master** (no audio) | `media/master/FullEvolutionStory.mp4` |
| **BigBangScene** (4K) | `media/scenes/BigBangScene_4K_Cinematic.mp4` |
| All 13 individual scenes | `media/scenes/*.mp4` |

Note: All videos were rendered at 480p15 resolution for quick local iteration. The 4K upscaled `BigBangScene_4K_Cinematic.mp4` demonstrates how the same source material can be enhanced to cinematic quality for professional use.

## 🛠️ Requirements

- [Manim Community Edition](https://docs.manim.community/) (`pip install manim`)
- [FFmpeg](https://ffmpeg.org/) (for assembly & audio)
- [SoX](https://sox.sourceforge.net/) (optional, for audio generation)

### Quick Start

```bash
# Clone & install
git clone https://github.com/NullLabTests/manim-evolution-story.git
cd manim-evolution-story
pip install -r requirements.txt

# Render a specific scene (using Makefile)
make render-scene S=BigBangScene

# Or manually:
manim -pql scripts/create_longform_video.py BigBangScene

# Render all 13 scenes at once
make render-all

# Render the full master video
make master-video

# Concatenate and add audio
make concat audio

# Upscale a scene to 4K
make upscale
```

## 🎯 Key Technical Details

- **Animation Engine**: [Manim Community v0.19+](https://docs.manim.community/)
- **Rendering**: Local CPU/GPU rendering via Manim's OpenGL renderer
- **Post-processing**: FFmpeg for concatenation, upscaling, and audio muxing
- **Audio**: Procedurally generated ambient soundtrack using FFmpeg's audio filters
- **Resolution**: 854×480 (base), 3840×2160 (4K upscale demo)
- **Frame Rate**: 15 fps (base), extensible to 60 fps with `-pqh`

## 🤖 CI/CD Pipeline

This repo includes a [GitHub Actions workflow](.github/workflows/render.yml) that can automatically render videos when triggered:

- **On tag push** (`v*`): Auto-renders all scenes
- **Manual dispatch**: Choose scene, resolution (`l`/`h`), and trigger from the Actions tab

```yaml
# Example: trigger a render of the full master at 1080p60
# Go to Actions > Render Videos > Run workflow
# Inputs: scene=master, resolution=h
```

Rendered videos are uploaded as build artifacts for download.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

*Created with [Manim](https://www.manim.community/) — 3Blue1Brown's mathematical animation engine, maintained by the Manim Community.*
