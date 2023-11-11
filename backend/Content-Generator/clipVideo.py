from moviepy.editor import *
from pytube import YouTube
import os
import json
from contextExtraction import contextExtraction

class clipVideo():

    def clipVideo(videoID):
        SAVE_PATH = "videos"
        path = "videos"
        link = "https://www.youtube.com/watch?v=" + videoID
        yt = YouTube(link)
        title = yt.title
        out_file = yt.streams.filter(progressive=True, file_extension='mp4').order_by('resolution').desc().first().download(SAVE_PATH)
        os.rename(out_file, path + "/video.mp4")

        with open("context_json.txt", "w") as f:
            f.write(str(contextExtraction.extractContent(videoID)))

        contextToRead = open("context_json.txt", "r")
        context = str(contextToRead.read())

        testContext = json.loads(context)

        for i in range(len(testContext["clips"])):
            clip = VideoFileClip(path + "/" + "video" + ".mp4")  
            clip = clip.subclip(testContext["clips"][i]["start"], testContext["clips"][i]["start"] + int(testContext["clips"][i]["duration"]))
            clip.write_videofile(path + "/" + "clip" + str(i) + ".mp4")
            clip.close()
        
        os.remove(path + "/video.mp4")

        return "Video successfully clipped"
    
    def fetchTitle(videoID):
        link = "https://www.youtube.com/watch?v=" + videoID
        return YouTube(link).title

