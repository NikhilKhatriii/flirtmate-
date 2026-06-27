import os
import json
import logging
import requests
import random
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)
# Enable CORS for all routes (to allow requests from Flutter web/desktop apps running locally)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

GROQ_API_KEY = os.getenv("GROQ_API_KEY", "").replace('"', '').replace("'", "").strip()
GROQ_MODEL = os.getenv("GROQ_MODEL", "llama-3.3-70b-versatile").replace('"', '').replace("'", "").strip()
GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions"

@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy",
        "groq_configured": bool(GROQ_API_KEY),
        "model": GROQ_MODEL
    })

@app.route("/api/generate", methods=["POST"])
def generate():
    if not GROQ_API_KEY:
        logging.error("Groq API Key is not configured on the backend.")
        return jsonify({"error": "Groq API Key is not configured on the backend. Please set it in your .env file."}), 500

    data = request.json or {}

    category = data.get("category", {})
    category_name = category.get("name", "Sophisticated")
    style_hint = category.get("styleHint", "")
    tagline = category.get("tagline", "")
    
    vibe = data.get("vibe")
    vibe_hint = vibe.get("promptHint") if vibe else None
    
    incoming_message = data.get("incomingMessage", "").strip()
    user_context = data.get("userContext")
    language_code = data.get("languageCode", "en")

    # Map language codes to names for the prompt
    languages = {"en": "English", "ne": "Nepali", "hi": "Hindi", "es": "Spanish", "zh": "Chinese", "ja": "Japanese"}
    target_language = languages.get(language_code, "English")

    # Extract advanced AI memory criteria for deep personalization
    age = data.get("age", "").strip()
    country = data.get("country", "").strip()
    dating_app = data.get("datingApp", "").strip()
    relationship_stage = data.get("relationshipStage", "").strip()
    communication_style = data.get("communicationStyle", "").strip()
    love_language = data.get("loveLanguage", "").strip()
    introvert_extrovert = data.get("introvertExtrovert", "").strip()
    humor_type = data.get("humorType", "").strip()

    memory_details = []
    if age: memory_details.append(f"Target Age: {age}")
    if country: memory_details.append(f"Target Country/Location: {country}")
    if dating_app: memory_details.append(f"Platform: {dating_app}")
    if relationship_stage: memory_details.append(f"Relationship Stage: {relationship_stage}")
    if communication_style: memory_details.append(f"Communication Style: {communication_style}")
    if love_language: memory_details.append(f"Love Language: {love_language}")
    if introvert_extrovert: memory_details.append(f"Personality: {introvert_extrovert}")
    if humor_type: memory_details.append(f"Humor Preference: {humor_type}")

    memory_context = "\n".join(memory_details) if memory_details else "None"

    # Guide Llama to output highly witty, high-status human-like responses
    prompt = (
        f"You are a master of 'quiet luxury' social chemistry and an elite communication coach.\n"
        f"Selected Style: \"{category_name}\" ({tagline}).\n"
        f"Language: {target_language}.\n"
        f"Vibe / Dynamic: {vibe_hint if vibe_hint else 'Neutral'}.\n"
        f"Context Details: {user_context if user_context else 'None'}.\n"
        f"Target User Context Details:\n{memory_context}\n\n"
        f"Incoming Message (if replying): \"{incoming_message}\".\n\n"
        "Generate 5 variations of response:\n"
        "1. 'main': A witty, smooth, and high-status line matching the style. Avoid generic compliments (like 'you are beautiful' or 'nice smile'). Instead, write a clever, teasing, magnetic line that a highly confident human would write. Example: 'I'm starting to think your smile should come with a warning—it keeps distracting me.'\n"
        "2. 'short': A shorter version under 10 words, designed for quick texting.\n"
        "3. 'romantic': A version leaning into romance, warmth, and authentic curiosity.\n"
        "4. 'playful': A more playful, bantering, and teasingly competitive version.\n"
        "5. 'confident': A bold, direct, high-value alternative.\n"
        "6. 'insight': A 1-2 sentence Strategic Coach insight explaining why the 'main' line works psychologically (e.g., 'This is low-pressure. Easy to answer. Invites a date naturally.').\n\n"
        "Return ONLY a JSON object with keys: 'main', 'short', 'romantic', 'playful', 'confident', 'insight'."
    )

    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {"role": "system", "content": "You are an expert dating wingman. You respond ONLY with structured JSON objects."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.8,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=30)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Generate Error: {e}")
        # Elegant fallback
        return jsonify({
            "data": {
                "main": "I'm starting to think your smile should come with a warning—it keeps distracting me.",
                "short": "You're a distraction, in a good way.",
                "romantic": "You have a calm presence that lingers long after you've stopped speaking.",
                "playful": "Are you always this much trouble, or am I just particularly lucky?",
                "confident": "I noticed you immediately, and I'm not one for second-guessing.",
                "insight": "This line leverages subtle intrigue. It shows high-status curiosity without sounding desperate."
            },
            "status": "fallback"
        })

@app.route("/api/analyze-screenshot", methods=["POST"])
def analyze_screenshot():
    data = request.json or {}
    image_base64 = data.get("image", "")
    platform = data.get("platform", "WhatsApp").strip()

    # Enhanced fallback response template
    fallback_response = {
        "platform": platform,
        "interest": 94,
        "confidence": 88,
        "mood": "Playful & Interested",
        "flirting_level": "Spicy / High Dynamic",
        "reply_time": "Reply within 1-2 hours",
        "double_text": False,
        "suggested_reply": "I'm starting to think your smile should come with a warning—it keeps distracting me.",
        "insight": "She matched your banter instantly and asked an open question. High interest detected!",
        "green_flags": [
            {"title": "Fast Energy Matching", "desc": "Responded quickly with double emojis."},
            {"title": "Open-Ended Engagement", "desc": "Asked a question back to keep the conversation flowing."}
        ],
        "red_flags": [
            {"title": "Slight Delay on Plans", "desc": "Hesitated slightly when mentioning weekend availability."}
        ]
    }

    if not GROQ_API_KEY or not image_base64 or image_base64 == "dummy_base64_chat_data":
        return jsonify({"data": fallback_response, "status": "fallback"})

    # Groq Vision call using llama-3.2-11b-vision-preview
    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    prompt_text = (
        f"Analyze this chat screenshot from platform: {platform}. "
        "Assess the conversation deeply and return a JSON object with EXACTLY these keys:\n"
        "- 'interest': integer 0-100\n"
        "- 'confidence': integer 0-100\n"
        "- 'mood': short string describing their emotion (e.g., 'Flirty', 'Playful', 'Distant', 'Warm')\n"
        "- 'flirting_level': short string (e.g., 'High / Spicy', 'Subtle', 'Banatering')\n"
        "- 'reply_time': short string recommendation (e.g., 'Reply within 2 hours')\n"
        "- 'double_text': boolean (true/false)\n"
        "- 'suggested_reply': magnetic, high-status, witty next text message to send\n"
        "- 'insight': strategic dating coach advice\n"
        "- 'green_flags': array of objects, each with 'title' and 'desc'\n"
        "- 'red_flags': array of objects, each with 'title' and 'desc'\n"
        "Return ONLY a valid JSON object."
    )

    payload = {
        "model": "llama-3.2-11b-vision-preview",
        "messages": [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt_text},
                    {
                        "type": "image_url",
                        "image_url": {"url": f"data:image/jpeg;base64,{image_base64}"}
                    }
                ]
            }
        ],
        "temperature": 0.5,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=25)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        parsed["platform"] = platform
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Vision API Error: {e}")
        return jsonify({"data": fallback_response, "status": "fallback"})

@app.route("/api/redflags", methods=["POST"])
def redflags():
    data = request.json or {}
    conversation_text = data.get("incomingMessage", "").strip()

    fallback_flags = {
        "flags": [
            {"type": "green", "icon": "💚", "message": "Matching Energy", "description": "She is responding with similar length messages and interest markers."},
            {"type": "yellow", "icon": "⚠️", "message": "Slow Replies", "description": "Taking a few hours to reply. Could be busy, or keeping up boundaries."},
            {"type": "red", "icon": "🚩", "message": "One-Word Replies", "description": "Watch out if she gives short answers without asking anything back."}
        ],
        "match_energy": 78,
        "summary": "The vibe is generally positive, but matches show signs of holding back. Keep the focus light and fun."
    }

    if not GROQ_API_KEY or not conversation_text:
        return jsonify({"data": fallback_flags, "status": "fallback"})

    prompt = (
        f"Analyze this chat transcript for warning signs (red flags), neutral signs (yellow flags), or positive signals (green flags).\n"
        f"Chat text: \"{conversation_text}\"\n\n"
        "Return a JSON object containing:\n"
        "1. 'flags': a list of flags. Each item has: 'type' ('red', 'green', 'yellow'), 'icon' ('🚩', '💚', '⚠️'), 'message' (short flag title), 'description' (dating coach insight).\n"
        "2. 'match_energy': integer 0-100\n"
        "3. 'summary': short overall description.\n\n"
        "Return ONLY a JSON object."
    )

    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {"role": "system", "content": "You are a red flag and vibe detector. Output ONLY structured JSON."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.6,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=20)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Red Flag Error: {e}")
        return jsonify({"data": fallback_flags, "status": "fallback"})

@app.route("/api/score", methods=["POST"])
def score():
    data = request.json or {}
    conversation_text = data.get("incomingMessage", "").strip()

    fallback_scores = {
        "charm": 87,
        "confidence": 92,
        "humor": 76,
        "mystery": 81,
        "overthinking": 34,
        "feedback": "You're leading the conversation with solid confidence, but sharing slightly too much too fast. Slow down and let them dig."
    }

    if not GROQ_API_KEY or not conversation_text:
        return jsonify({"data": fallback_scores, "status": "fallback"})

    prompt = (
        f"Score this conversation on Rizz metrics.\n"
        f"Chat text: \"{conversation_text}\"\n\n"
        "Assess scores (0-100) for charm, confidence, humor, mystery, and overthinking, and write a wittily brief feedback sentence.\n"
        "Return ONLY a JSON object with keys: 'charm', 'confidence', 'humor', 'mystery', 'overthinking', 'feedback'."
    )

    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {"role": "system", "content": "You are a master rizz scorer. Respond ONLY with structured JSON."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.6,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=20)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Score Error: {e}")
        return jsonify({"data": fallback_scores, "status": "fallback"})

@app.route("/api/voice-rizz", methods=["POST"])
def voice_rizz():
    data = request.json or {}
    phrase = data.get("incomingMessage", "").strip()

    fallback_rizz = {
        "rizz": "I have to admit, your music taste is slightly better than mine. Almost makes me want to ask what else you're hiding.",
        "explanation": "This swaps a dry invitation for a playful challenge, maintaining high status while provoking curiosity."
    }

    if not GROQ_API_KEY or not phrase:
        return jsonify({"data": fallback_rizz, "status": "fallback"})

    prompt = (
        f"Translate this draft message/phrase into an ultra-smooth, high-status, witty flirt line: \"{phrase}\".\n"
        "Return ONLY a JSON object with keys: 'rizz' and 'explanation' (Briefly explaining why it works)."
    )

    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {"role": "system", "content": "You are a voice rizz translator. Respond ONLY with structured JSON."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.8,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=15)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Voice Rizz Error: {e}")
        return jsonify({"data": fallback_rizz, "status": "fallback"})

@app.route("/api/daily", methods=["GET", "POST"])
def daily():
    fallback_daily = {
        "icebreaker": "Would you rather have a conversation consisting entirely of movie quotes or song lyrics?",
        "tip": "Ask 'why' rather than 'what'. It invites stories instead of listings, keeping the dialogue rich.",
        "challenge": "Send a text today containing exactly one food emoji and nothing else. Let the mystery simmer.",
        "line": "I'm starting to think your smile should come with a warning—it keeps distracting me.",
        "compliment": "You have a voice that sounds like a quiet Sunday afternoon."
    }

    if not GROQ_API_KEY:
        return jsonify({"data": fallback_daily, "status": "fallback"})

    # Pick a random style for variation
    style = random.choice(["Witty", "Mysterious", "Confident", "Wholesome", "Playful"])
    prompt = (
        f"Generate fresh daily content with a '{style}' aesthetic.\n"
        "Provide: 'icebreaker' (question), 'tip' (flirting advice), 'challenge' (fun challenge), 'line' (pickup line), 'compliment' (charming compliment).\n"
        "Return ONLY a JSON object with these keys."
    )

    headers = {"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {"role": "system", "content": "You are a daily wingman editor. Output ONLY structured JSON."},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.8,
        "response_format": {"type": "json_object"}
    }

    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=20)
        res_data = response.json()
        content = res_data.get("choices", [{}])[0].get("message", {}).get("content", "{}")
        parsed = json.loads(content)
        return jsonify({"data": parsed, "status": "success"})
    except Exception as e:
        logging.error(f"Daily Feed Error: {e}")
        return jsonify({"data": fallback_daily, "status": "fallback"})

@app.route("/api/feedback", methods=["POST"])
def feedback():
    data = request.json or {}
    name = data.get("name", "Anonymous")
    email = data.get("email", "N/A")
    comments = data.get("comments", "")
    
    logging.info(f"Feedback Received from {name} ({email}): {comments}")
    
    # Save simulated feedback locally
    try:
        with open("feedback.txt", "a") as f:
            f.write(f"Name: {name}\nEmail: {email}\nComments: {comments}\n---\n")
    except Exception:
        pass

    return jsonify({"status": "success", "message": "Feedback submitted successfully."})

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
