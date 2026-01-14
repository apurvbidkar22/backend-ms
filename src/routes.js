const express = require("express");
const router = express.Router();
const pool = require("./db");

router.get("/health", (req, res) => {
  res.status(200).json({ status: "UP" });
});

router.get("/data", async (req, res) => {
  try {
    const result = await pool.query(
      "CREATE TABLE IF NOT EXISTS messages (id SERIAL PRIMARY KEY, msg TEXT);"
    );

    await pool.query(
      "INSERT INTO messages (msg) VALUES ('Hello from OpenShift Backend!')"
    );

    const data = await pool.query("SELECT * FROM messages;");
    res.json(data.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database error" });
  }
});

module.exports = router;
