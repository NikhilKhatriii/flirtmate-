import os
import json
import logging
import requests
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
    
    user_context = data.get("userContext")
    recent_lines = data.get("recentLines", [])
    language_code = data.get("languageCode", "en")

    # Map language codes to names for the prompt
    languages = {
        "en": "English",
        "ne": "Nepali",
        "hi": "Hindi",
        "es": "Spanish",
        "zh": "Chinese",
        "ja": "Japanese"
    }
    target_language = languages.get(language_code, "English")

    avoid_list = " | ".join(recent_lines[:8]) if recent_lines else ""
    
    # Constructing prompt
    prompt_lines = [
        f'Generate exactly ONE sophisticated, high-class flirty pickup line or message for the "{category_name}" style.',
        f'The response MUST be written in {target_language}.',
        f'Style description: {style_hint}' if style_hint else '',
        f'Tagline: "{tagline}"' if tagline else '',
        f'Situation: {vibe_hint}' if vibe_hint else '',
        '',
        'Rules:',
        f'- Output ONLY the line itself in {target_language} — no quotes, no labels, no explanation, no English translation',
        '- Make it feel genuinely crafted and unique — not generic or clichéd',
        '- High-class language: witty, charming, intelligent',
        '- Length: 1 to 3 sentences maximum',
        '- Never sound desperate or cheap'
    ]
    
    if avoid_list:
        prompt_lines.append(f'- Do NOT repeat or closely resemble any of these recent lines: {avoid_list}')
    if user_context:
        prompt_lines.append(f'- Context hint: {user_context}')
        
    prompt_lines.append('\nRespond with only the pickup line, nothing else.')
    
    prompt = "\n".join([line for line in prompt_lines if line is not None])
    
    logging.info(f"Generating line for category: {category_name}")
    
    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "model": GROQ_MODEL,
        "messages": [
            {
                "role": "system",
                "content": (
                    "You are a master of sophisticated, high-class romantic wit. "
                    "You craft original, charming pickup lines with elegance and "
                    "creativity. You respond with only the requested line — nothing else."
                )
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        "temperature": 0.95,
        "max_tokens": 150
    }
    
    try:
        response = requests.post(GROQ_API_URL, headers=headers, json=payload, timeout=20)
        
        if response.status_code != 200:
            logging.error(f"Groq API returned status code {response.status_code}: {response.text}")
            try:
                err_data = response.json()
                msg = err_data.get("error", {}).get("message", "Unknown error")
            except Exception:
                msg = response.text
            return jsonify({"error": f"Groq API Error: {msg}"}), response.status_code
            
        res_data = response.json()
        choices = res_data.get("choices", [])
        if not choices:
            logging.error("No choices returned from Groq API")
            return jsonify({"error": "Empty response from Groq API"}), 500
            
        content = choices[0].get("message", {}).get("content", "").strip()
        
        # Clean any quotes surrounding the line
        if content.startswith('"') and content.endswith('"'):
            content = content[1:-1].strip()
        if content.startswith('“') and content.endswith('”'):
            content = content[1:-1].strip()
            
        logging.info(f"Successfully generated line: {content}")
        return jsonify({"line": content, "status": "success"})
        
    except requests.exceptions.Timeout:
        logging.error("Request to Groq API timed out.")
        return jsonify({"error": "Request to Groq API timed out."}), 504
    except Exception as e:
        logging.error(f"Error calling Groq API: {e}")
        return jsonify({"error": f"Backend Error: {str(e)}"}), 500

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    # Bind to 0.0.0.0 so it is accessible from the local network (emulators/other devices)
    app.run(host="0.0.0.0", port=port, debug=True)