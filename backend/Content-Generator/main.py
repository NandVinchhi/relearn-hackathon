from getCompletion import getCompletion
from contextExtraction import contextExtraction
from clipVideo import clipVideo
from VideoProcessing import VideoProcessing

#Workflow
# IFKnq9QM6_A
# Short video: dC7BtsV-ddc
# - Set-ExecutionPolicy RemoteSigned
# - Use GPT4 to extract transcripts and clips from a YouTube video => contextExtraction.py
# - Use moviepy to crop videos into 576x1024 form and add subtitles to clip => cropVideo.py

# - VideoProcessing => NatureVideo.overlay(KhanAcademyVideo).overlayMusic().addSubtitles()
# - Use moviepy to cut videos into clips based on data => cutVideo.py
# - Use moviepy to overlay light music into the clip => overlay.py

# o Hydrogen Bonding in Water : https://youtu.be/6G1evL7ELwE //
# o Capillary Action and why we see a meniscus : https://youtu.be/eQXGpturk3A 
# o Surface Tension : https://youtu.be/_RTF0DAHBBM 
# o Water as a Solvent : https://youtu.be/lCvBp73ZJ-A


def main():
    print(clipVideo.clipVideo("eQXGpturk3A"))
    print(VideoProcessing.addEdges("eQXGpturk3A"))

    print("Done")

if __name__ == "__main__":
    main()