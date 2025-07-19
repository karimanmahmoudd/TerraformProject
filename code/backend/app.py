from flask import Flask, request, jsonify
import random
from flask_cors import CORS  # Add this import
import random
import psycopg2
import os
# app = Flask(__name__)
app = Flask(__name__)
CORS(app) 
# In-memory game storage
games = {}


@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
    response.headers.add('Access-Control-Allow-Methods', 'GET,POST')
    return response


@app.route("/start", methods=["POST"])
def start_game():
    # Generate a random number between 1 and 100
    secret_number = random.randint(1, 100)
    game_id = str(random.randint(1000, 9999))
    
    games[game_id] = {
        "secret_number": secret_number,
        "attempts": 0,
        "guesses": [],
        "status": "in_progress"
    }
    
    return jsonify({
        "game_id": game_id,
        "message": "Guess a number between 1 and 100",
        "min": 1,
        "max": 100
    })

@app.route("/guess", methods=["POST"])
def make_guess():
    data = request.get_json()
    game_id = data.get("game_id")
    guess = data.get("guess")
    
    if not game_id or game_id not in games:
        return jsonify({"error": "Invalid game ID"}), 404
    
    try:
        guess = int(guess)
    except (ValueError, TypeError):
        return jsonify({"error": "Guess must be a number"}), 400
    
    game = games[game_id]
    
    if game["status"] != "in_progress":
        return jsonify({"error": "Game is already completed"}), 400
    
    game["attempts"] += 1
    game["guesses"].append(guess)
    
    if guess == game["secret_number"]:
        game["status"] = "won"
        return jsonify({
            "message": f"Congratulations! You guessed the number in {game['attempts']} attempts.",
            "status": "won",
            "secret_number": game["secret_number"],
            "attempts": game["attempts"],
            "guesses": game["guesses"]
        })
    elif guess < game["secret_number"]:
        hint = "higher"
    else:
        hint = "lower"
    
    # Check if maximum attempts reached (optional)
    if game["attempts"] >= 10:
        game["status"] = "lost"
        return jsonify({
            "message": f"Game over! The number was {game['secret_number']}.",
            "status": "lost",
            "secret_number": game["secret_number"],
            "attempts": game["attempts"],
            "guesses": game["guesses"]
        })
    
    return jsonify({
        "message": f"Try again! Go {hint}.",
        "status": "in_progress",
        "attempts": game["attempts"],
        "previous_guess": guess,
        "hint": hint
    })

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)