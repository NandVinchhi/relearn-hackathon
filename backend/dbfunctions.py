import redis
from redis.commands.search.query import NumericFilter, Query
from redis.commands.json.path import Path
from credentials import REDIS_URL, REDIS_PASSWORD, SUPABASE_KEY, SUPABASE_URL
from supabase import create_client, Client
from random import choice
import json

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

r = redis.Redis(
  host=REDIS_URL,
  port=17728,
  password=REDIS_PASSWORD
)

def is_onboarded(email) -> bool:
    try:
        response = supabase.table("topic_selection").select("*").eq('email', email).execute()
        if len(response.data) > 0:
            return True
        return False
    except:
        return False

def onboard(email, topic_selection):
    supabase.table("topic_selection").insert({"email": email, "selection_list": topic_selection}).execute()

# def get_reel(email):

def get_meme_reel():
    response = supabase.table("reels").select("*").eq("meme", True).execute()
    return choice(response.data)

# def get_progress():

def get_comments(reel_id):
    comments = []
    cursor = '0'

    while cursor != 0:
        cursor, keys = r.scan(cursor, match=f"comments:{reel_id}:*")
        for key in keys:
            comment_data = r.json().get(key)
            if comment_data:
                comments.append(json.loads(comment_data))

    return comments

def remove_comments(reel_id):
    cursor = '0'

    while cursor != 0:
        cursor, keys = r.scan(cursor, match=f"comments:{reel_id}:*")
        for key in keys:
            r.delete(key)

def add_comment(reel_id, email, name, profile_url, created_at, comment):
    key = f"comments:{reel_id}:{email}:{created_at}"
    comment_data = {
        "email": email,
        "name": name,
        "profile_url": profile_url,
        "reel_id": reel_id,
        "content": comment,
        "created_at": created_at,
        "edison_reply": ""
    }

    r.json().set(key, Path.root_path(), json.dumps(comment_data))

# def add_comment_with_edison(email, name, profilepic, created, comment):


def is_liked(reel_id, email) -> bool:
    key = f"likes:{reel_id}:{email}"
    return bool(r.exists(key))

def like_reel(reel_id, email):
    key = f"likes:{reel_id}:{email}"

    like_data = {
        "email": email,
        "reel_id": reel_id
    }

    r.json().set(key, Path.root_path(), json.dumps(like_data))

def remove_like(reel_id, email):
    key = f"likes:{reel_id}:{email}"

    r.delete(key)

