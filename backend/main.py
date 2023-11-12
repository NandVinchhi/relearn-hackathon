from fastapi import FastAPI, HTTPException
from typing import List
import dbfunctions
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/is_onboarded")
async def api_is_onboarded(body: dict):
    try:
        return {"message": dbfunctions.is_onboarded(body["email"])}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")

@app.post("/onboard")
async def api_onboard(body: dict):
    try:
        dbfunctions.onboard(body["email"], body["topic_selection"])
        return {"message": "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/recommend_reel")
async def api_recommend_reel(body: dict):
    try:
        recommended_reel = dbfunctions.recommend_reel(body["email"], body["selection_list"])
        return {"message": recommended_reel}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/recommend_initial")
async def api_recommend_initial(body: dict):
    try:
        initial_recommendations = dbfunctions.recommend_initial(body["email"], body["selection_list"])
        return {"message": initial_recommendations or "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/get_meme_reel")
async def api_get_meme_reel():
    try:
        meme_reel = dbfunctions.get_meme_reel()
        return {"message": meme_reel or "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/get_comments")
async def api_get_comments(body: dict):
    try:
        comments = dbfunctions.get_comments(body["reel_id"])
        return {"message": comments or "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")

@app.post("/add_comment")
async def api_add_comment(body: dict):
    try:
        added_comment = dbfunctions.add_comment(body["reel_id"], body["email"], body["name"], body["profile_url"], body["created_at"], body["comment"])
        return {"message": added_comment}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/add_comment_with_edison")
async def api_add_comment_with_edison(body: dict):
    try:
        added_comment = dbfunctions.add_comment_with_edison(body["reel_id"], body["email"], body["name"], body["profile_url"], body["created_at"], body["comment"])
        return {"message": added_comment}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")

@app.post("/is_liked")
async def api_is_liked(body: dict):
    try:
        liked_status = dbfunctions.is_liked(body["reel_id"], body["email"])
        return {"liked": liked_status}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/like_reel")
async def api_like_reel(body: dict):
    try:
        dbfunctions.like_reel(body["reel_id"], body["email"])
        return {"message": "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")
    
@app.post("/remove_like")
async def api_remove_like(body: dict):
    try:
        dbfunctions.remove_like(body["reel_id"], body["email"])
        return {"message": "success"}
    except Exception as e:
        print(repr(e))
        raise HTTPException(status_code=500, detail="Server error")