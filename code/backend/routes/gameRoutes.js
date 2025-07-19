const express = require("express");
const router = express.Router();
const gameController = require("../controllers/gameController");

router.post("/games", gameController.startGame);
router.post("/games/:id/guess", gameController.makeGuess);
router.get("/games/:id", gameController.getGame);

module.exports = router;
