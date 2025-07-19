const Game = require("../models/Game");
const words = [
  "apple",
  "banana",
  "cherry",
  "date",
  "elderberry",
  "fig",
  "grape",
  "honeydew",
  "ice cream",
  "jackfruit",
  "kiwi",
  "lemon",
  "mango",
  "nectarine",
  "orange",
  "papaya",
  "quince",
  "raspberry",
  "strawberry",
  "tangerine",
  "ugli fruit",
];

// Start a new game
exports.startGame = async (req, res) => {
  try {
    const randomWord = words[Math.floor(Math.random() * words.length)];
    const game = new Game({
      word: randomWord.toLowerCase(),
    });
    await game.save();
    res.status(201).json(game);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Make a guess
exports.makeGuess = async (req, res) => {
  try {
    const game = await Game.findById(req.params.id);
    if (!game) {
      return res.status(404).json({ error: "Game not found" });
    }

    // if (game.status !== "in_progress") {
    //   return res.status(400).json({ error: "Game is already over" });
    // }

    const letter = req.body.letter.toLowerCase();
    if (!letter.match(/^[a-z]$/)) {
      return res.status(400).json({ error: "Please enter a single letter" });
    }

    if (game.guessedLetters.includes(letter)) {
      return res.status(400).json({ error: "Letter already guessed" });
    }

    game.guessedLetters.push(letter);

    if (!game.word.includes(letter)) {
      game.incorrectGuesses += 1;
      if (game.incorrectGuesses >= 6) {
        game.status = "lost";
      }
    }

    // Check if player has won
    const wordArray = game.word.split("");
    const isWon = wordArray.every((char) => game.guessedLetters.includes(char));
    if (isWon) {
      game.status = "won";
    }

    await game.save();
    res.json(game);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get game status
exports.getGame = async (req, res) => {
  try {
    const game = await Game.findById(req.params.id);
    if (!game) {
      return res.status(404).json({ error: "Game not found" });
    }
    res.json(game);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
