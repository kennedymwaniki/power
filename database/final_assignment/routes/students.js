const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all students
router.get("/", (req, res) => {
  const sql = "SELECT * FROM students";

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ students: results });
  });
});

// Get a single student
router.get("/:id", (req, res) => {
  const sql = "SELECT * FROM students WHERE student_id = ?";

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: "Student not found" });
    }
    res.json({ student: results[0] });
  });
});

// Create a new student
router.post("/", (req, res) => {
  const { first_name, last_name, email, date_of_birth } = req.body;

  // Validate required fields
  if (!first_name || !last_name || !email || !date_of_birth) {
    return res
      .status(400)
      .json({ message: "Please provide all required fields" });
  }

  const sql =
    "INSERT INTO students (first_name, last_name, email, date_of_birth) VALUES (?, ?, ?, ?)";

  db.query(
    sql,
    [first_name, last_name, email, date_of_birth],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }

      // Get the newly created student
      db.query(
        "SELECT * FROM students WHERE student_id = ?",
        [result.insertId],
        (err, results) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res
            .status(201)
            .json({
              message: "Student created successfully",
              student: results[0],
            });
        }
      );
    }
  );
});

// Update a student
router.put("/:id", (req, res) => {
  const { first_name, last_name, email, date_of_birth, is_active } = req.body;

  // Check if student exists
  db.query(
    "SELECT * FROM students WHERE student_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Student not found" });
      }

      // Update student
      const sql =
        "UPDATE students SET first_name = ?, last_name = ?, email = ?, date_of_birth = ?, is_active = ? WHERE student_id = ?";

      db.query(
        sql,
        [
          first_name || results[0].first_name,
          last_name || results[0].last_name,
          email || results[0].email,
          date_of_birth || results[0].date_of_birth,
          is_active !== undefined ? is_active : results[0].is_active,
          req.params.id,
        ],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          // Get the updated student
          db.query(
            "SELECT * FROM students WHERE student_id = ?",
            [req.params.id],
            (err, results) => {
              if (err) {
                return res.status(500).json({ error: err.message });
              }
              res.json({
                message: "Student updated successfully",
                student: results[0],
              });
            }
          );
        }
      );
    }
  );
});

// Delete a student
router.delete("/:id", (req, res) => {
  // Check if student exists
  db.query(
    "SELECT * FROM students WHERE student_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Student not found" });
      }

      // Delete student
      const sql = "DELETE FROM students WHERE student_id = ?";

      db.query(sql, [req.params.id], (err, result) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Student deleted successfully" });
      });
    }
  );
});

// Get all courses for a student
router.get("/:id/courses", (req, res) => {
  const sql = `
        SELECT c.*, e.grade, e.enrollment_date
        FROM courses c
        JOIN enrollments e ON c.course_id = e.course_id
        WHERE e.student_id = ?
    `;

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ courses: results });
  });
});

module.exports = router;
