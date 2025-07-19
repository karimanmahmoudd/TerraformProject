const mongoose = require("mongoose");

const GameSchema = new mongoose.Schema({
  word: {
    type: String,
    required: true,
  },
  guessedLetters: {
    type: [String],
    default: [],
  },
  incorrectGuesses: {
    type: Number,
    default: 0,
  },
  status: {
    type: String,
    enum: ["in_progress", "won", "lost"],
    default: "in_progress",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Game", GameSchema);
