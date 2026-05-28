# Manim Evolution Story

[![Manim](https://img.shields.io/badge/Made%20with-Manim-CB6CE6?logo=manim&logoColor=white)](https://www.manim.community/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://python.org)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-6.1-007808?logo=ffmpeg&logoColor=white)](https://ffmpeg.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/NullLabTests/manim-evolution-story/render.yml?branch=main&label=CI&logo=githubactions)](https://github.com/NullLabTests/manim-evolution-story/actions)
[![Video Length](https://img.shields.io/badge/Total%20Duration-4m%2001s-0891b2)](https://github.com/NullLabTests/manim-evolution-story/releases)
[![Last Commit](https://img.shields.io/github/last-commit/NullLabTests/manim-evolution-story)](https://github.com/NullLabTests/manim-evolution-story/commits/main)

**From the Big Bang to You: The Epic 13.8-Billion-Year Story of Evolution**

An educational animated video series rendered with [Manim Community](https://www.manim.community/). This project produces a 4-minute journey through cosmic and biological evolution across 13 chapters, with a complete production pipeline from Python scripts to polished video output.

---

## Table of Contents

- [About](#about)
- [Chapters](#chapters)
- [Production Pipeline](#production-pipeline)
- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Cinematic Upscale](#cinematic-upscale)
- [CI/CD Pipeline](#cicd-pipeline)
- [Technical Details](#technical-details)
- [License](#license)

---

## About

This project demonstrates how to create professional educational animations using [Manim](https://www.manim.community/), the mathematical animation engine popularized by 3Blue1Brown. The content covers 13.8 billion years of evolutionary history in 13 scenes:

- All scenes authored as Python classes using Manim's animation framework
- Rendered locally at 480p15 for rapid iteration
- Assembled into a master video with procedurally generated ambient soundtrack
- One scene upscaled to 4K with color grading to demonstrate professional-grade output
- Full CI/CD pipeline for automated rendering on GitHub

## Chapters

| # | Scene | Duration | Description |
|---|-------|----------|-------------|
| 1 | Title | ~31s | Opening starfield and title sequence |
| 2 | Big Bang | ~18s | Singularity, cosmic inflation, first particles |
| 3 | Star Formation | ~22s | Nebulae, protostars, nuclear fusion |
| 4 | Solar System | ~18s | Planetary accretion, Earth forms |
| 5 | Origin of Life | ~17s | Primordial soup, first cells |
| 6 | Great Oxidation | ~16s | Cyanobacteria, oxygen atmosphere |
| 7 | Eukaryotes | ~15s | Complex cells, endosymbiosis |
| 8 | Cambrian Explosion | ~18s | Burgess Shale, body plan diversification |
| 9 | Sea to Land | ~14s | Tiktaalik, first terrestrial life |
| 10 | Rise of Mammals | ~21s | Triassic, Jurassic, mammals thrive |
| 11 | Primate Lineage | ~12s | Early primates, bipedalism |
| 12 | Human Evolution | ~16s | Homo genus, tools, civilization |
| 13 | Conclusion | ~23s | Reflection on our place in the cosmos |

## Production Pipeline

All rendering was performed locally in a GitHub Codespace using the following workflow.

### 1. Scene Authoring

Each chapter is a Manim `Scene` class written in Python. Two script files are provided:

- **`scripts/full_video.py`** — All 13 chapters in one continuous `FullStoryScene` for single-pass rendering with `next_section` markers for FFmpeg chapter seeking
- **`scripts/create_longform_video.py`** — Individual scene classes for per-chapter rendering and rapid iteration

### 2. Rendering

```bash
# Render a specific scene at low quality (quick iteration)
manim -pql scripts/create_longform_video.py BigBangScene

# Render at high quality (1080p60)
manim -pqh scripts/create_longform_video.py BigBangScene

# Render all 13 scenes
make render-all

# Render the full master video
manim -pql scripts/full_video.py FullStoryScene
```

The `-pql` flag produces 480p15 output (`-pq` = production quality, `l` = low res). Use `-pqh` for 1080p60.

### 3. Assembly & Audio

Scene videos were concatenated and a procedurally generated ambient soundtrack was added using FFmpeg:

```bash
# Concatenate scenes into master video
make concat

# Generate ambient audio and add to master
make audio
```

The audio soundtrack is synthesized entirely with FFmpeg's built-in audio filters — no external audio files required. It uses a blend of pink noise, bass drones (55 Hz, 110 Hz, 165 Hz), and automated gain control for a cinematic ambient feel.

### 4. Post-Processing

See the [Cinematic Upscale](#cinematic-upscale) section for details on the 4K enhancement pipeline.

## Repository Structure

```
manim-evolution-story/
├── .github/
│   └── workflows/
│       └── render.yml              # GitHub Actions CI/CD
├── .gitignore                      # Cache and temp exclusions
├── Makefile                        # Convenience commands
├── README.md
├── LICENSE                         # MIT License
├── requirements.txt                # Python dependencies
├── media/
│   ├── master/
│   │   ├── FullEvolutionStory.mp4              # Complete video (no audio)
│   │   └── FullEvolutionStory_WithSound.mp4    # Complete video + ambient audio
│   └── scenes/
│       ├── BigBangScene.mp4
│       ├── BigBangScene_4K_Cinematic.mp4       # 4K upscale demo
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
    ├── create_longform_video.py   # Individual scene classes
    └── full_video.py              # All-in-one master scene
```

## Quick Start

### Requirements

- Python 3.12+
- [Manim Community Edition](https://docs.manim.community/) (installed via pip)
- [FFmpeg](https://ffmpeg.org/) (for assembly, audio, and upscaling)
- [SoX](https://sox.sourceforge.net/) (optional — alternative audio generation)

### Setup

```bash
git clone https://github.com/NullLabTests/manim-evolution-story.git
cd manim-evolution-story
pip install -r requirements.txt
```

### Usage

```bash
# Render a single scene
make render-scene S=BigBangScene
# or: manim -pql scripts/create_longform_video.py BigBangScene

# Render all 13 scenes
make render-all

# Render the full master video
make master-video

# Assemble and add audio
make concat audio

# Upscale a scene to 4K
make upscale

# Clean generated media
make clean
```

## Cinematic Upscale

The Big Bang scene was upscaled to **4K (3840x2160)** with color grading to demonstrate the quality potential of the Manim source material:

```bash
ffmpeg -i BigBangScene.mp4 \
  -vf "scale=3840:2160:flags=lanczos,\
       eq=brightness=0.05:contrast=1.1:saturation=1.2,\
       unsharp=3:3:1.0:3:3:0.5" \
  -c:v libx264 -preset slow -crf 18 -b:v 40M \
  -c:a aac -b:a 192k \
  BigBangScene_4K_Cinematic.mp4
```

**FFmpeg filter explanation:**

| Filter | Purpose |
|--------|---------|
| `lanczos` scaling | High-quality resampling for sharp 4K upscale |
| `eq` | Brightness +0.05, contrast 1.1x, saturation 1.2x |
| `unsharp` | 3x3 mask with 1.0 strength for detail enhancement |
| `preset slow` | Better compression efficiency at cost of speed |
| `crf 18` | Visually lossless quality (lower = better, 18-23 is standard) |

The result (`BigBangScene_4K_Cinematic.mp4`) shows that low-resolution Manim renders can be effectively enhanced for professional presentation.

## CI/CD Pipeline

This repository includes a [GitHub Actions workflow](.github/workflows/render.yml) for automated rendering:

- **On tag push** (`v*`): Automatically renders all scenes at low quality
- **Manual trigger**: Dispatch from the Actions tab with configurable scene and resolution

```yaml
# Example workflow dispatch parameters:
# scene: "master" | "all" | "<ClassName>"
# resolution: "l" (480p15) | "h" (1080p60)
```

Rendered videos are uploaded as build artifacts, available for download from each workflow run.

## Technical Details

| Attribute | Value |
|-----------|-------|
| Animation Engine | [Manim Community v0.19+](https://docs.manim.community/) |
| Rendering | CPU/GPU via Manim's OpenGL renderer |
| Post-Processing | FFmpeg concat, scaling, filtering |
| Audio Generation | FFmpeg lavfi (sine waves + pink noise) |
| Base Resolution | 854x480 (480p, 15 fps) |
| High Quality | 1920x1080 (1080p, 60 fps) via `-pqh` |
| 4K Upscale | 3840x2160 Lanczos + color grading |
| Total Duration | 4 minutes 1 second |
| Total Scenes | 13 |

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

*Created with [Manim](https://www.manim.community/) — the mathematical animation engine by 3Blue1Brown, maintained by the Manim Community.*
