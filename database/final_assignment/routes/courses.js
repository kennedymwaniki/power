const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all courses
router.get("/", (req, res) => {
  const sql = `
        SELECT c.*, d.department_name 
        FROM courses c
        LEFT JOIN departments d ON c.department_id = d.department_id
    `;

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ courses: results });
  });
});

// Get a single course
router.get("/:id", (req, res) => {
  const sql = `
        SELECT c.*, d.department_name 
        FROM courses c
        LEFT JOIN departments d ON c.department_id = d.department_id
        WHERE c.course_id = ?
    `;

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: "Course not found" });
    }
    res.json({ course: results[0] });
  });
});

// Create a new course
router.post("/", (req, res) => {
  const { course_code, course_name, credit_hours, description, department_id } =
    req.body;

  // Validate required fields
  if (!course_code || !course_name || !credit_hours) {
    return res
      .status(400)
      .json({
        message: "Please provide course_code, course_name, and credit_hours",
      });
  }

  const sql =
    "INSERT INTO courses (course_code, course_name, credit_hours, description, department_id) VALUES (?, ?, ?, ?, ?)";

  db.query(
    sql,
    [
      course_code,
      course_name,
      credit_hours,
      description || null,
      department_id || null,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }

      // Get the newly created course
      const fetchSql = `
            SELECT c.*, d.department_name 
            FROM courses c
            LEFT JOIN departments d ON c.department_id = d.department_id
            WHERE c.course_id = ?
        `;

      db.query(fetchSql, [result.insertId], (err, results) => {
        if (err) {
          return res.status(500).json({ error: err.message });
        }
        res.status(201).json({
          message: "Course created successfully",
          course: results[0],
        });
      });
    }
  );
});

// Update a course
router.put("/:id", (req, res) => {
  const { course_code, course_name, credit_hours, description, department_id } =
    req.body;

  // Check if course exists
  db.query(
    "SELECT * FROM courses WHERE course_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Course not found" });
      }

      const existingCourse = results[0];

      // Update course
      const sql = `
            UPDATE courses 
            SET course_code = ?, course_name = ?, credit_hours = ?, description = ?, department_id = ? 
            WHERE course_id = ?
        `;

      db.query(
        sql,
        [
          course_code || existingCourse.course_code,
          course_name || existingCourse.course_name,
          credit_hours || existingCourse.credit_hours,
          description !== undefined ? description : existingCourse.description,
          department_id !== undefined
            ? department_id
            : existingCourse.department_id,
          req.params.id,
        ],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          // Get the updated course
          const fetchSql = `
                SELECT c.*, d.department_name 
                FROM courses c
                LEFT JOIN departments d ON c.department_id = d.department_id
                WHERE c.course_id = ?
            `;

          db.query(fetchSql, [req.params.id], (err, results) => {
            if (err) {
              return res.status(500).json({ error: err.message });
            }
            res.json({
              message: "Course updated successfully",
              course: results[0],
            });
          });
        }
      );
    }
  );
});

// Delete a course
router.delete("/:id", (req, res) => {
  // Check if course exists
  db.query(
    "SELECT * FROM courses WHERE course_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Course not found" });
      }

      // Delete course
      db.query(
        "DELETE FROM courses WHERE course_id = ?",
        [req.params.id],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.json({ message: "Course deleted successfully" });
        }
      );
    }
  );
});

// Get all students enrolled in a course
router.get("/:id/students", (req, res) => {
  const sql = `
        SELECT s.*, e.grade, e.enrollment_date
        FROM students s
        JOIN enrollments e ON s.student_id = e.student_id
        WHERE e.course_id = ?
    `;

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ students: results });
  });
});

module.exports = router;
