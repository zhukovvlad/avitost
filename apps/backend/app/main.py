import os
import secrets
import urllib.parse

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, RedirectResponse

load_dotenv()

AUTH_URL = "https://oauth.yandex.ru/authorize"
TOKEN_URL = "https://oauth.yandex.ru/token"
CLIENT_ID = os.getenv("YANDEX_CLIENT_ID")
CLIENT_SECRET = os.getenv("YANDEX_CLIENT_SECRET")
REDIRECT_URI = os.getenv("OAUTH_REDIRECT_URI")
SCOPE = os.getenv("OAUTH_SCOPE", "login:info")
STATE = set()

app = FastAPI(
    title="AviTost API",
    description="API для OAuth авторизации через Yandex",
    version="1.0.0",
)

# Настройка CORS для работы с frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/health")
def health():
    return {"status": "ok"}


@app.get("/api/login")
def login():
    if not (CLIENT_ID and REDIRECT_URI):
        raise HTTPException(500, "CLIENT_ID/REDIRECT_URI не заданы")
    state = secrets.token_urlsafe(16)
    STATE.add(state)
    params = {
        "response_type": "code",
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "scope": SCOPE,
        "state": state,
    }
    return RedirectResponse(f"{AUTH_URL}?{urllib.parse.urlencode(params)}")


@app.get("/oauth/callback")
async def callback(req: Request):
    if err := req.query_params.get("error"):
        return JSONResponse({"error": err}, status_code=400)
    code = req.query_params.get("code")
    state = req.query_params.get("state")
    if not code or state not in STATE:
        raise HTTPException(400, "bad code/state")
    STATE.discard(state)
    async with httpx.AsyncClient(timeout=20) as c:
        r = await c.post(
            TOKEN_URL,
            data={
                "grant_type": "authorization_code",
                "code": code,
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "redirect_uri": REDIRECT_URI,
            },
        )
    r.raise_for_status()
    return JSONResponse(r.json())
