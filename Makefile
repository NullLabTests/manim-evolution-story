.PHONY: render-all render-scene master-video audio upscale clean

# Render all 13 scenes at low quality (quick iteration)
SCENES = TitleScene BigBangScene StarFormationScene SolarSystemScene \
         OriginOfLifeScene GreatOxidationScene EukaryotesScene \
         CambrianExplosionScene SeaToLandScene RiseOfMammalsScene \
         PrimateLineageScene HumanEvolutionScene ConclusionScene

# Render a specific scene (usage: make render-scene S=BigBangScene)
render-scene:
	manim -pql scripts/create_longform_video.py $(S)

# Render all scenes
render-all:
	for scene in $(SCENES); do \
		manim -pql scripts/create_longform_video.py $$scene; \
	done

# Render full master video
master-video:
	manim -pql scripts/full_video.py FullStoryScene

# Concatenate scenes into master (manually after rendering)
concat:
	@printf "file '$(PWD)/media/videos/create_longform_video/480p15/%s.mp4'\n" $(SCENES) > /tmp/scenes.txt
	ffmpeg -f concat -safe 0 -i /tmp/scenes.txt -c copy media/master/FullEvolutionStory.mp4

# Generate ambient audio
audio:
	ffmpeg -f lavfi -i "anoisesrc=d=245:c=pink:a=0.5" \
		-f lavfi -i "sine=frequency=55:duration=245" \
		-f lavfi -i "sine=frequency=110:duration=245" \
		-f lavfi -i "sine=frequency=165:duration=245" \
		-filter_complex "[1]volume=0.15[a];[2]volume=0.10[b];[3]volume=0.08[c];[0]volume=0.3[n];[a][b][c][n]amix=inputs=4:duration=first:weights=2 1.5 1 0.5,afade=t=in:ss=0:d=3,afade=t=out:st=240:d=5" \
		-ac 2 /tmp/ambient.wav -y
	ffmpeg -i media/master/FullEvolutionStory.mp4 -i /tmp/ambient.wav \
		-c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest \
		media/master/FullEvolutionStory_WithSound.mp4 -y

# Upscale BigBangScene to 4K
upscale:
	ffmpeg -i media/videos/create_longform_video/480p15/BigBangScene.mp4 \
		-vf "scale=3840:2160:flags=lanczos,eq=brightness=0.05:contrast=1.1:saturation=1.2,unsharp=3:3:1.0:3:3:0.5" \
		-c:v libx264 -preset slow -crf 18 -b:v 40M -maxrate 50M -bufsize 80M \
		-c:a aac -b:a 192k -movflags +faststart \
		media/scenes/BigBangScene_4K_Cinematic.mp4 -y

# Clean generated media
clean:
	rm -rf media/videos media/tex media/text
