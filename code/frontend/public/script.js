let currentGameId = null;
const hangmanStages = [
  `
     +---+
     |   |
         |
         |
         |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
         |
         |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
     |   |
         |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
    /|   |
         |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
    /|\\  |
         |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
    /|\\  |
    /    |
         |
  =========
  `,
  `
     +---+
     |   |
     O   |
    /|\\  |
    / \\  |
         |
  =========
  `,
];

document.addEventListener("DOMContentLoaded", () => {
  const guessInput = document.getElementById("guess-input");
  const guessButton = document.getElementById("guess-button");
  const newGameButton = document.getElementById("new-game-button");
  const wordDisplay = document.getElementById("word-display");
  const hangmanArt = document.getElementById("hangman-art");
  const incorrectGuesses = document.getElementById("incorrect-guesses");
  const guessedLetters = document.getElementById("guessed-letters");
  const message = document.getElementById("message");

  // Start a new game
  async function startNewGame() {
    try {
      const response = await fetch("http://172.22.154.104:5000/api/games", {
        method: "POST",
      });
      const game = await response.json();
      currentGameId = game._id;
      updateGameDisplay(game);
      message.textContent = "";
      guessInput.disabled = false;
      guessButton.disabled = false;
    } catch (err) {
      console.error("Error starting new game:", err);
      message.textContent = "Failed to start a new game. Please try again.";
    }
  }

  // Make a guess
  async function makeGuess(letter) {
    if (!currentGameId) return;

    try {
      const response = await fetch(
        `http://172.22.154.104:5000/api/games/${currentGameId}/guess`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ letter }),
        }
      );
      const game = await response.json();
      updateGameDisplay(game);

      if (game.status === "won") {
        message.textContent = "Congratulations! You won!";
        message.className = "won";
        disableInput();
      } else if (game.status === "lost") {
        message.textContent = `Game over! The word was "${game.word}".`;
        message.className = "lost";
        disableInput();
      }
    } catch (err) {
      console.error("Error making guess:", err);
      message.textContent = "Failed to make a guess. Please try again.";
    }
  }

  // Update the game display
  function updateGameDisplay(game) {
    // Display the word with underscores for unguessed letters
    const displayWord = game.word
      .split("")
      .map((letter) => (game.guessedLetters.includes(letter) ? letter : "_"))
      .join(" ");
    wordDisplay.textContent = displayWord;

    // Update hangman art based on incorrect guesses
    hangmanArt.textContent = hangmanStages[game.incorrectGuesses];

    // Update incorrect guesses count
    incorrectGuesses.textContent = game.incorrectGuesses;

    // Update guessed letters
    guessedLetters.textContent = game.guessedLetters.join(", ");
  }

  function disableInput() {
    guessInput.disabled = true;
    guessButton.disabled = true;
  }

  // Event listeners
  guessButton.addEventListener("click", () => {
    const letter = guessInput.value.trim().toLowerCase();
    if (letter && letter.match(/^[a-z]$/)) {
      makeGuess(letter);
      guessInput.value = "";
    } else {
      message.textContent = "Please enter a single letter (a-z).";
    }
    guessInput.focus();
  });

  guessInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      guessButton.click();
    }
  });

  newGameButton.addEventListener("click", startNewGame);

  // Start a game when the page loads
  startNewGame();
});
