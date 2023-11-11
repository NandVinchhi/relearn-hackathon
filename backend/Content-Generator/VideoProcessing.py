from moviepy.editor import *
from youtube_transcript_api import YouTubeTranscriptApi 
import json
import random
import os

class VideoProcessing():
    def addEdges(videoID):
        
        transcript = YouTubeTranscriptApi.get_transcript(videoID)

        contextToRead = open("context_json.txt", "r")
        context = str(contextToRead.read())
        testContext = json.loads(context)

        c = 0
        directory = os.fsencode("videos")
        for file in os.listdir(directory):

            filename = os.fsdecode(file)
            if filename.endswith(".mp4"):

                clip = VideoFileClip("videos/clip" + str(c) + ".mp4") 
                width = clip.size[0]
                height = ((16/9)-(9/16)) * clip.size[0] / 2

                audioArray = []
                audio = AudioFileClip("music/song" + str(random.randint(1, 4)) + ".mp3")

                for i in range(int(clip.duration / audio.duration) + 1):
                    audioArray.append(audio)

                loopAudio = concatenate_audioclips(audioArray).subclip(0, clip.duration)

                reel = VideoFileClip("reels/reel" + str(random.randint(1, 5)) + ".mp4", 
                                     target_resolution=[int((((16/9)-(9/16)) * clip.size[0] ) + clip.size[0]), 
                                                        int(clip.size[0])]).without_audio()
                
                reelArray = []
                for i in range(int(clip.duration / reel.duration) + 1):
                    reelArray.append(reel)

                loopVideo = concatenate_videoclips(reelArray).subclip(0, clip.duration)
                loopVideoTop = loopVideo.crop(x1=0, y1=0, x2=width, y2=height).set_position(("center","top"))
                loopVideoBot = loopVideo.crop(x1=0, y1=loopVideo.size[1] - height, x2=width, y2=loopVideo.size[1]).set_position(("center","bottom"))

                combine = clips_array([[loopVideoTop],[clip],[loopVideoBot]])

                clipArray = []
                startTime = testContext["clips"][c]["start"]
                print(str(c) + ":" + str(startTime))

                for i in range(len(transcript)):
                    if (transcript[i]["start"] >= startTime and 
                        transcript[i]["start"] + transcript[i]["duration"] <= startTime + testContext["clips"][c]["duration"]):

                        subCombine = combine.subclip(float(transcript[i]["start"] - startTime), 
                                                    float(transcript[i]["start"] + transcript[i]["duration"] - startTime))
                        text = TextClip(txt=transcript[i]["text"], filename=None, 
                                        size=(float(clip.size[0]), 
                                            float((((16/9)-(9/16)) * clip.size[0] ) + clip.size[0])), 
                                            color="white", stroke_color="black", font='Helvetica-Narrow-Bold').set_position(("center",
                                                                        "top")).margin(bottom=int(height)).set_duration(float(transcript[i]["duration"]))
                        comboClip = CompositeVideoClip([subCombine, text])
                        clipArray.append(comboClip)
                
                final = concatenate_videoclips(clipArray)
                finalAudio = CompositeAudioClip([final.audio, loopAudio])
                final = final.set_audio(finalAudio)
                final.write_videofile("videos/clip" + str(c) + ".mp4")
                c += 1

        os.remove("context_json.txt")
        return "Clip successfully edited"