from youtube_transcript_api import YouTubeTranscriptApi 
from getCompletion import getCompletion

class contextExtraction():

    def extractContent(videoID):
        srt = contextExtraction.retrieveTranscript(videoID)
        str1 = ""

        for i in range(len(srt)):
            str1 += str(srt[i]['start'])
            str1 += "\n"
            str1 += srt[i]['text']
            str1 += "\n"

        prompt = f"""You will be given YouTube caption data on a topic enclosed in triple backticks, analyze the context and divide the data into short and digestable clips, the 'text' key has the data to analyze, the 'start' and 'duration' keys should be used to make sure each clip is not longer than a minute. Utilize as much of the transcript as possible. For example: A 6 minute video should have atleast 5 clips. Output only the JSON in the format {{ "clips": [
            {{
            "start": ,
            "duration": ,
            "text": ""
            }},
            {{
            "start": ,
            "duration": ,
            "text": ""
            }}
            ...
           }}
           ] 
            ```{str1}```"""

        return getCompletion.get_completion(prompt)
         
    
    def retrieveTranscript(videoID):
        return YouTubeTranscriptApi.get_transcript(videoID)