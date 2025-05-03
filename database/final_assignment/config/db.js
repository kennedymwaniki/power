// Database connection configuration
const mysql = require("mysql2");
const fs = require("fs");
const path = require("path");

// Create connection
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // Replace with your MySQL username
  password: "", // Leave empty if no password is set
  database: "student_records",
  port: 3306,
});

// Function to initialize the database
function initializeDatabase() {
  const sqlScript = fs.readFileSync(
    path.join(__dirname, "../database.sql"),
    "utf8"
  );

  const statements = sqlScript
    .split(";")
    .filter((statement) => statement.trim() !== "");

  // Execute each statement
  statements.forEach((statement) => {
    db.query(statement, (err) => {
      if (err) {
        console.error("Error executing SQL statement:", err);
      }
    });
  });

  console.log("Database initialized successfully");
}

// Connect
db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL database:", err);
    return;
  }
  console.log("MySQL Connected...");

  // Initialize database
  initializeDatabase();
});

module.exports = db;
