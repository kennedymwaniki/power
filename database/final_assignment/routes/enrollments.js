const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all enrollments
router.get("/", (req, res) => {
  const sql = `
        SELECT e.*, 
               s.first_name, s.last_name, 
               c.course_code, c.course_name
        FROM enrollments e
        JOIN students s ON e.student_id = s.student_id
        JOIN courses c ON e.course_id = c.course_id
    `;

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ enrollments: results });
  });
});

// Get a single enrollment
router.get("/:id", (req, res) => {
  const sql = `
        SELECT e.*, 
               s.first_name, s.last_name, 
               c.course_code, c.course_name
        FROM enrollments e
        JOIN students s ON e.student_id = s.student_id
        JOIN courses c ON e.course_id = c.course_id
        WHERE e.enrollment_id = ?
    `;

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: "Enrollment not found" });
    }
    res.json({ enrollment: results[0] });
  });
});

// Create a new enrollment
router.post("/", (req, res) => {
  const { student_id, course_id, grade } = req.body;

  // Validate required fields
  if (!student_id || !course_id) {
    return res
      .status(400)
      .json({ message: "Please provide student_id and course_id" });
  }

  // Check if student and course exist
  const checkSql = `
        SELECT 
            (SELECT COUNT(*) FROM students WHERE student_id = ?) as studentExists,
            (SELECT COUNT(*) FROM courses WHERE course_id = ?) as courseExists
    `;

  db.query(checkSql, [student_id, course_id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }

    if (!results[0].studentExists) {
      return res.status(404).json({ message: "Student not found" });
    }

    if (!results[0].courseExists) {
      return res.status(404).json({ message: "Course not found" });
    }

    // Check if enrollment already exists
    db.query(
      "SELECT * FROM enrollments WHERE student_id = ? AND course_id = ?",
      [student_id, course_id],
      (err, results) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }

        if (results.length > 0) {
          return res.status(409).json({
            message: "Student is already enrolled in this course",
            enrollment: results[0],
          });
        }

        // Create enrollment
        const insertSql = `
                    INSERT INTO enrollments (student_id, course_id, grade) 
                    VALUES (?, ?, ?)
                `;

        db.query(
          insertSql,
          [student_id, course_id, grade || null],
          (err, result) => {
            if (err) {
              return res.status(500).json({ error: err.message });
            }

            // Get the newly created enrollment
            const fetchSql = `
                        SELECT e.*, 
                               s.first_name, s.last_name, 
                               c.course_code, c.course_name
                        FROM enrollments e
                        JOIN students s ON e.student_id = s.student_id
                        JOIN courses c ON e.course_id = c.course_id
                        WHERE e.enrollment_id = ?
                    `;

            db.query(fetchSql, [result.insertId], (err, results) => {
              if (err) {
                return res.status(500).json({ error: err.message });
              }
              res.status(201).json({
                message: "Enrollment created successfully",
                enrollment: results[0],
              });
            });
          }
        );
      }
    );
  });
});

// Update an enrollment (update grade)
router.put("/:id", (req, res) => {
  const { grade } = req.body;

  if (grade === undefined) {
    return res.status(400).json({ message: "Please provide grade to update" });
  }

  // Check if enrollment exists
  db.query(
    "SELECT * FROM enrollments WHERE enrollment_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Enrollment not found" });
      }

      // Update grade
      db.query(
        "UPDATE enrollments SET grade = ? WHERE enrollment_id = ?",
        [grade, req.params.id],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          // Get the updated enrollment
          const fetchSql = `
                    SELECT e.*, 
                           s.first_name, s.last_name, 
                           c.course_code, c.course_name
                    FROM enrollments e
                    JOIN students s ON e.student_id = s.student_id
                    JOIN courses c ON e.course_id = c.course_id
                    WHERE e.enrollment_id = ?
                `;

          db.query(fetchSql, [req.params.id], (err, results) => {
            if (err) {
              return res.status(500).json({ error: err.message });
            }
            res.json({
              message: "Enrollment updated successfully",
              enrollment: results[0],
            });
          });
        }
      );
    }
  );
});

// Delete an enrollment
router.delete("/:id", (req, res) => {
  // Check if enrollment exists
  db.query(
    "SELECT * FROM enrollments WHERE enrollment_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Enrollment not found" });
      }

      // Delete enrollment
      db.query(
        "DELETE FROM enrollments WHERE enrollment_id = ?",
        [req.params.id],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.json({ message: "Enrollment deleted successfully" });
        }
      );
    }
  );
});

module.exports = router;
