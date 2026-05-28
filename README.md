# Manim Evolution Story

[![Manim](https://img.shields.io/badge/Made%20with-Manim-CB6CE6?logo=manim&logoColor=white)](https://www.manim.community/)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://python.org)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-6.1-007808?logo=ffmpeg&logoColor=white)](https://ffmpeg.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/NullLabTests/manim-evolution-story/render.yml?branch=main&label=CI&logo=githubactions)](https://github.com/NullLabTests/manim-evolution-story/actions)
[![Video Length](https://img.shields.io/badge/Duration-4m%2001s-0891b2)](https://github.com/NullLabTests/manim-evolution-story/releases)
[![Last Commit](https://img.shields.io/github/last-commit/NullLabTests/manim-evolution-story)](https://github.com/NullLabTests/manim-evolution-story/commits/main)
[![Scenes](https://img.shields.io/badge/Scenes-13-4CAF50)](https://github.com/NullLabTests/manim-evolution-story)
[![Manim Features](https://img.shields.io/badge/Manim%20Features-10+%20animations-FF6F00)](https://docs.manim.community/)

**From the Big Bang to You: The Epic 13.8-Billion-Year Story of Evolution**

An educational animated video series rendered with [Manim Community](https://www.manim.community/). This project produces a 4-minute journey through cosmic and biological evolution across 13 chapters, demonstrating a complete production pipeline from Python animation scripts to polished video output.

---

- [About](#about)
- [Chapters](#chapters)
- [Production Pipeline](#production-pipeline)
- [Manim Techniques Used](#manim-techniques-used)
  - [Animation Classes](#animation-classes)
  - [Mobject Types](#mobject-types)
  - [Color Palette &amp; Design Philosophy](#color-palette--design-philosophy)
  - [Rate Functions &amp; Custom Animations](#rate-functions--custom-animations)
- [Scene Deep-Dives](#scene-deep-dives)
  - [Big Bang: NumberPlane + Rate Functions](#chapter-2-big-bang--cosmic-inflation)
  - [Eukaryotes: ReplacementTransform](#chapter-7-eukaryotes--endosymbiosis)
  - [Human Evolution: Information Graphics](#chapter-12-human-evolution)
- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Cinematic Upscale](#cinematic-upscale)
- [CI/CD Pipeline](#cicd-pipeline)
- [Technical Details](#technical-details)
- [License](#license)

---

## About

This project demonstrates how to create professional educational animations using [Manim](https://www.manim.community/), the mathematical animation engine popularized by 3Blue1Brown. The content covers 13.8 billion years of evolutionary history across 13 scenes:

- **All scenes authored as Python classes** using Manim's animation framework — `FadeIn`, `Create`, `Write`, `GrowFromCenter`, `ReplacementTransform`, `UpdateFromAlphaFunc`, and more
- **Rendered locally at 480p15** for rapid iteration in a GitHub Codespace
- **Assembled into a master video** with a procedurally generated ambient soundtrack (pure FFmpeg — no external audio)
- **One scene upscaled to 4K** with Lanczos scaling and color grading to demonstrate professional-grade output
- **Full CI/CD pipeline** for automated rendering on GitHub Actions via tag push or manual dispatch
- **13 chapters** using 10+ distinct animation types, 12+ mobject types, and 4 rate functions

## Chapters

| # | Scene | Duration | Description |
|---|-------|----------|-------------|
| 1 | Title | ~31s | Opening starfield and title sequence with twinkling stars |
| 2 | Big Bang | ~18s | Singularity, cosmic inflation, first particles, fundamental forces |
| 3 | Star Formation | ~22s | Nebulae, protostars, nuclear fusion, element creation |
| 4 | Solar System | ~18s | Planetary accretion, orbital mechanics, Earth forms |
| 5 | Origin of Life | ~17s | Primordial soup, chemical reactions, first cell, LUCA |
| 6 | Great Oxidation | ~16s | Cyanobacteria, O2 bubbles, rust, mass extinction |
| 7 | Eukaryotes | ~15s | Endosymbiosis, nucleus, mitochondria, complex cells |
| 8 | Cambrian Explosion | ~18s | Body plan diversification, Burgess Shale, tree of life |
| 9 | Sea to Land | ~14s | Tiktaalik, tetrapod transition, plant colonization |
| 10 | Rise of Mammals | ~21s | Asteroid impact, dinosaur extinction, mammal diversification |
| 11 | Primate Lineage | ~12s | Evolutionary tree, hominin branch, bipedalism adaptations |
| 12 | Human Evolution | ~16s | Timeline from Australopithecus to sapiens, brain size, technology |
| 13 | Conclusion | ~23s | Recap timeline, philosophical reflection, fade to black |

## Production Pipeline

All rendering was performed locally in a GitHub Codespace using the following workflow.

### 1. Scene Authoring

Each chapter is a Manim `Scene` class written in Python. Two script files are provided:

| File | Purpose |
|------|---------|
| [`scripts/full_video.py`](scripts/full_video.py) | All 13 chapters in one continuous `FullStoryScene`. Uses `self.next_section()` markers for FFmpeg chapter seeking. Best for single-pass rendering. |
| [`scripts/create_longform_video.py`](scripts/create_longform_video.py) | 13 independent `Scene` subclasses (one per chapter) for per-scene rendering and rapid iteration. Includes a custom `AnimatedParticleBurst(Animation)` class. |

### 2. Rendering

```bash
# Render a specific scene at low quality (quick iteration)
manim -pql scripts/create_longform_video.py BigBangScene

# Render at high quality (1080p60)
manim -pqh scripts/create_longform_video.py BigBangScene

# Render all 13 scenes
make render-all

# Render the full master video
make master-video
```

The `-pql` flag produces 480p15 output (`-pq` = production quality, `l` = low res). Use `-pqh` for 1080p60.

### 3. Assembly & Audio

Scene videos are concatenated and a procedurally generated ambient soundtrack is added using FFmpeg:

```bash
make concat   # Concatenate 13 scenes into master video
make audio    # Generate ambient soundtrack & mux with video
```

The audio is synthesized entirely with FFmpeg's built-in `lavfi` filters — no external audio files. It blends pink noise with bass drones (55 Hz, 110 Hz, 165 Hz) in a 4:3:2:1 ratio with automated gain control, producing a cinematic ambient soundscape.

### 4. Post-Processing

See the [Cinematic Upscale](#cinematic-upscale) section for the 4K enhancement pipeline.

## Manim Techniques Used

### Animation Classes

| Animation Class | Scenes | Parameters Used |
|----------------|--------|-----------------|
| `FadeIn` | All 13 | `scale`, `shift` |
| `FadeOut` | All 13 | `shift` |
| `Write` | All 13 | `run_time` |
| `Create` | 1, 4, 6, 7, 8, 9, 11, 12, 13 | Lines, orbits, arrows, tree branches, timelines |
| `GrowFromCenter` | 3, 4, 5, 6, 7, 9 | Nebulae, sun, planets, cells, fish |
| `DrawBorderThenFill` | 5, 7 | Cell membranes |
| `ReplacementTransform` | 7, 9 | Morphing: prokaryote → eukaryote, fish → tetrapod |
| `UpdateFromAlphaFunc` | 4 | Planetary orbital motion (lambda closures) |
| `.animate` property | All 13 | `.set_opacity()`, `.scale()`, `.shift()`, `.move_to()`, `.set_color()` |

### Mobject Types

| Mobject | Scenes | Usage |
|---------|--------|-------|
| `Text` | All 13 | Titles, labels, descriptions, poetic messages |
| `Dot` | 1, 2, 3, 6, 8, 11, 12, 13 | Stars, particles, timeline markers |
| `Circle` | 2, 3, 4, 5, 6, 7, 8, 9, 10, 12 | Sun, planets, cells, bacteria, O2 bubbles, glows |
| `Line` | 1, 6, 7, 8, 9, 11, 12, 13 | Underlines, timelines, DNA, tree trunks, body parts |
| `VGroup` | All 13 | Composite mobjects throughout |
| `Rectangle` | 5, 6, 8, 9, 12 | Ocean, seafloor, water areas, brain-size bars |
| `Ellipse` | 8, 9, 10 | Fish bodies, tetrapod bodies, mammals |
| `Polygon` | 9 | Land masses, fish tails |
| `RegularPolygon` | 8 | Cambrian creatures (pentagon, hexagon) |
| `Square` | 8 | Cambrian creature |
| `Arrow` | 7, 9 | Evolutionary transition arrows |
| `NumberPlane` | 2 | Expanding grid for cosmic inflation |

### Color Palette & Design Philosophy

Each semantic theme has a dedicated color, creating visual consistency across the 13 scenes:

| Color | Hex | Usage |
|-------|-----|-------|
| `COSMIC_BG` | `#0a0a1a` | Deep space background (11 of 13 scenes) |
| `C_WARM_GOLD` | `#FFD700` | Titles, stars, culminating content, humans |
| `C_DEEP_BLUE` | `#1a237e` | Oceans, primordial environments |
| `C_LIFE_GREEN` | `#4CAF50` | Life, cells, vegetation, land |
| `C_OXYGEN_BLUE` | `#42A5F5` | Oxygen, water, atmosphere |
| `C_FIRE_RED` | `#FF5722` | Fire, rust, catastrophic events |
| `C_PRIMORDIAL` | `#FF8A65` | Cambrian era, early life |
| `C_HUMAN_TONE` | `#FFCC80` | Mammals, primates, hominins |
| `C_NEBULA_PINK` | `#E040FB` | Nebulae, divergence branches |
| `C_NEBULA_PURPLE` | `#7C4DFF` | Nebulae, bats |
| `C_GALAXY_BLUE` | `#448AFF` | Galaxies, star formation |

The palette maps to a narrative arc: cold cosmic blues → warm life greens → golden human tones. Background shifts from deep space `#0a0a1a` to warmer `#0D1117` during the biology chapters, reinforcing the emotional shift from cosmic to earthly.

### Rate Functions & Custom Animations

**Rate functions** control the timing feel of specific animations:

| Rate Function | Scene | Effect |
|---------------|-------|--------|
| `exponential_decay` | 2 (Big Bang flash) | Fast flash with quick falloff |
| `ease_out_cubic` | 2 (Grid expansion) | Smooth decelerating expansion |
| `linear` | 4 (Planet orbits) | Constant-speed orbital motion |
| `ease_in_cubic` | 10 (Asteroid impact) | Accelerating asteroid fall |

**Custom Animation** — `AnimatedParticleBurst` (defined in `create_longform_video.py`):
- Extends `manim.Animation` directly
- Generates 60 particles with random spherical coordinates, projected to 2D
- Stores velocity vectors as mobject attributes
- Uses `self.rate_func(alpha)` for easing and particle opacity fade-out
- Provides `clean_up_from_scene()` for proper cleanup
- Available but not currently called in any scene (ready for future use)

## Scene Deep-Dives

### Chapter 2: Big Bang & Cosmic Inflation

**Goal:** Visualize 10^-32 seconds of cosmic inflation — the most dramatic expansion in history.

**Technique stack:**
1. `Dot` singularity + `Circle` flash: `flash.animate.scale(30).set_opacity(0)` with `rate_func=exponential_decay` — the singularity explodes outward
2. `NumberPlane` grid: `grid.animate.scale(100)` with `rate_func=ease_out_cubic` — spatial expansion decelerates as it grows, mimicking inflationary cosmology
3. 80 colored particles via `interpolate_color(BLUE, PURPLE, random)` — the quark-gluon plasma cooling into matter
4. Four `Text` force labels: `Gravity`, `Strong Nuclear`, `Weak Nuclear`, `Electromagnetism` — fade in sequentially with scale, showing force symmetry breaking

**Key code pattern:**
```python
flash = create_glow_circle(radius=0.5, color=WHITE, opacity=0.8)
self.play(flash.animate.scale(30).set_opacity(0),
          rate_func=exponential_decay, run_time=2.0)

grid = NumberPlane(x_range=[-20, 20, 1], y_range=[-12, 12, 1],
                   background_line_style={"stroke_color": BLUE_D,
                                          "stroke_width": 0.5,
                                          "stroke_opacity": 0.3})
self.play(grid.animate.scale(100),
          rate_func=rate_functions.ease_out_cubic, run_time=4.0)
```

**Visual metaphor:** The NumberPlane's grid lines represent the fabric of spacetime itself — scaling it by 100× in 4 seconds visualizes 10^26× expansion in 10^-32 seconds.

---

### Chapter 7: Eukaryotes & Endosymbiosis

**Goal:** Explain the endosymbiotic theory — how complex cells evolved.

**Technique stack:**
1. `DrawBorderThenFill` for the prokaryote — draws the border first, then fills, mimicking cell membrane formation
2. Small `Circle` prey drifts toward the prokaryote — `prey.animate.move_to(prok_center)` — the engulfment moment
3. Purple `Circle` flash: `engulf_flash.animate.scale(1.5).set_opacity(0)` — the endosymbiotic event
4. `ReplacementTransform(prok.copy(), euk)` — morphs the prokaryote copy into a larger eukaryote, visually representing the evolutionary transition
5. Organelle labels (`FadeIn` with `scale=0.5`) — nucleus and mitochondria appear within the new cell

**Key code pattern:**
```python
# Engulf the smaller cell
self.play(prey.animate.move_to(prok.get_center()), run_time=1.5)

# Endosymbiosis flash
self.play(engulf_flash.animate.scale(1.5).set_opacity(0), run_time=0.8)

# Morph into eukaryote
euk = Circle(radius=0.7, color=PURPLE, stroke_width=3, fill_opacity=0.05)
self.play(ReplacementTransform(prok.copy(), euk), run_time=2.0)
```

**Visual metaphor:** The entire sequence is a visual essay of the Lynn Margulis endosymbiosis theory — one cell engulfing another, but instead of digestion, cooperation emerges. `ReplacementTransform` is the ideal Manim tool for this evolutionary morph.

---

### Chapter 12: Human Evolution

**Goal:** Present 6 million years of hominin evolution as an information graphic.

**Technique stack:**
1. Horizontal `Line` timeline from `LEFT*6` to `RIGHT*6`
2. 6 species markers, each a `VGroup` of: `Circle` (head) + `Line` (body) + `Text` (name + date) + `Dot` (timeline position)
3. Brain-size bar chart: 6 `Rectangle` objects with height proportional to `cc/1400 * 2.0`, colored from cool to warm
4. 5 technology milestone `Text` items (Oldowan, Fire, Acheulean, Art, Agriculture) staggered in
5. Final migration text: "Homo sapiens migrates out of Africa ~70 kya"

**Information density management:**
- Timeline + species → brain size bars → technology milestones → migration conclusion
- Each layer fades in sequentially, preventing information overload
- Brain size bars are a quantitative visual — something Manim excels at
- The increasing bar heights reinforce the narrative of cognitive evolution

---

## Repository Structure

```
manim-evolution-story/
├── .github/
│   └── workflows/
│       └── render.yml              # GitHub Actions CI/CD (tag + manual trigger)
├── .gitignore                      # Cache, Python, OS, IDE exclusions
├── Makefile                        # Convenience: render, concat, audio, upscale
├── README.md
├── LICENSE                         # MIT License
├── requirements.txt                # manim + numpy
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
    ├── create_longform_video.py   # 13 independent scene classes
    └── full_video.py              # Single continuous master scene
```

## Quick Start

### Requirements

- Python 3.12+
- [Manim Community Edition](https://docs.manim.community/) (`pip install manim`)
- [FFmpeg](https://ffmpeg.org/) (assembly, audio, upscaling)
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

# Show all Makefile commands
make help
```

### Troubleshooting

| Problem | Solution |
|---------|----------|
| `manim not found` | Ensure `pip install manim` completed and `~/.local/bin` is on your PATH |
| `ffmpeg not found` | Install via `brew install ffmpeg` (macOS) or `apt install ffmpeg` (Linux) |
| Rendering is slow | Use `-pql` (480p15) for iteration, `-pqh` (1080p60) for final renders |
| `ModuleNotFoundError: manim` | Check you're in the correct Python environment (`which python`) |
| Video has no audio | Run `make audio` after `make concat` — audio is generated as a separate step |
| Partial movie files only | Run `make render-all` first to generate individual scene MP4s before `make concat` |

## Cinematic Upscale

The Big Bang scene was upscaled to **4K (3840×2160)** with color grading to demonstrate the quality potential of Manim source material:

```bash
make upscale
```

### FFmpeg Filter Chain Explained

| Filter | Purpose | Why This Matters |
|--------|---------|------------------|
| `lanczos` scaling | High-quality resampling for upscaling | Lanczos preserves sharp edges better than bilinear or bicubic — critical for Manim's geometric shapes and text |
| `eq=brightness=0.05` | Slight brightness lift | Compensates for luminance compression during scaling; 0.05 = ~5% lift |
| `eq=contrast=1.1` | 10% contrast increase | Restores punch lost during scaling; Manim's 480p color ranges benefit from mild S-curve |
| `eq=saturation=1.2` | 20% saturation boost | Manim's custom color palette at 480p can appear washed out after upscale; saturation recovery is essential |
| `unsharp=3:3:1.0:3:3:0.5` | 3×3 mask, 1.0 luma strength, 0.5 chroma | Light sharpening compensates for Lanczos's inherent softness at extreme scale factors (~4.5×) |
| `preset slow` | Better compression efficiency | Small file size increase for significant quality improvement at a given bitrate |
| `crf 18` | Visually lossless | Constant Rate Factor 18 is the industry standard for archival-quality H.264 (lower = better, 18-23 is typical, 18 is "visually lossless") |
| `b:v 40M` | 40 Mbps video bitrate | Ample bandwidth for 4K content with fine gradients (Manim's gradients + Lanczos need high bitrate to avoid banding) |

The result (`BigBangScene_4K_Cinematic.mp4`) shows that low-resolution Manim renders can be effectively enhanced for professional presentation — from 854×480 to 3840×2160 (22.7× the pixel count).

## CI/CD Pipeline

This repository includes a [GitHub Actions workflow](.github/workflows/render.yml) for automated rendering:

| Trigger | Behavior |
|---------|----------|
| **Tag push** (`v*`) | Auto-renders all scenes at 1080p60 |
| **Manual dispatch** | Choose scene (any chapter / all / master) and resolution (480p15 / 1080p60) from the Actions tab |

Rendered videos are uploaded as build artifacts (`.zip`) available for download from each workflow run, with 30-day retention.

### Example: Trigger a 1080p60 render

```bash
git tag v1.0.0
git push origin v1.0.0
```

Or navigate to Actions → Render Videos → Run workflow → scene: `all`, resolution: `h`.

## Technical Details

| Attribute | Value |
|-----------|-------|
| Animation Engine | [Manim Community v0.19+](https://docs.manim.community/) |
| Rendering Method | CPU/GPU via Manim's OpenGL renderer |
| Post-Processing | FFmpeg 6.1 (concat, scaling, filtering, audio) |
| Audio Generation | FFmpeg lavfi (sine wave drones + pink noise) |
| Base Resolution | 854 × 480 (480p, 15 fps) |
| High Quality | 1920 × 1080 (1080p, 60 fps) via `-pqh` |
| 4K Upscale | 3840 × 2160 via Lanczos + color grading |
| Total Duration | 4 minutes 1 second |
| Total Scenes | 13 |
| Animation Classes Used | 8 (`FadeIn`, `FadeOut`, `Write`, `Create`, `GrowFromCenter`, `DrawBorderThenFill`, `ReplacementTransform`, `UpdateFromAlphaFunc`) |
| Mobject Types Used | 12 (`Text`, `Dot`, `Circle`, `Line`, `VGroup`, `Rectangle`, `Ellipse`, `Polygon`, `RegularPolygon`, `Square`, `Arrow`, `NumberPlane`) |
| Rate Functions Used | 4 (`exponential_decay`, `ease_out_cubic`, `linear`, `ease_in_cubic`) |
| Codebase Size | ~2,700 lines of Manim Python |

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

*Created with [Manim](https://www.manim.community/) — the mathematical animation engine by 3Blue1Brown, maintained by the Manim Community.*
