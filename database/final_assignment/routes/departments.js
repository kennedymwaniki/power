const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all departments
router.get("/", (req, res) => {
  const sql = "SELECT * FROM departments";

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ departments: results });
  });
});

// Get a single department
router.get("/:id", (req, res) => {
  const sql = "SELECT * FROM departments WHERE department_id = ?";

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: "Department not found" });
    }
    res.json({ department: results[0] });
  });
});

// Create a new department
router.post("/", (req, res) => {
  const { department_name, head_of_department } = req.body;

  // Validate required fields
  if (!department_name) {
    return res.status(400).json({ message: "Please provide department_name" });
  }

  const sql =
    "INSERT INTO departments (department_name, head_of_department) VALUES (?, ?)";

  db.query(
    sql,
    [department_name, head_of_department || null],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }

      // Get the newly created department
      db.query(
        "SELECT * FROM departments WHERE department_id = ?",
        [result.insertId],
        (err, results) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.status(201).json({
            message: "Department created successfully",
            department: results[0],
          });
        }
      );
    }
  );
});

// Update a department
router.put("/:id", (req, res) => {
  const { department_name, head_of_department } = req.body;

  // Check if department exists
  db.query(
    "SELECT * FROM departments WHERE department_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Department not found" });
      }

      const existingDepartment = results[0];

      // Update department
      const sql =
        "UPDATE departments SET department_name = ?, head_of_department = ? WHERE department_id = ?";

      db.query(
        sql,
        [
          department_name || existingDepartment.department_name,
          head_of_department !== undefined
            ? head_of_department
            : existingDepartment.head_of_department,
          req.params.id,
        ],
        (err, result) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          // Get the updated department
          db.query(
            "SELECT * FROM departments WHERE department_id = ?",
            [req.params.id],
            (err, results) => {
              if (err) {
                return res.status(500).json({ error: err.message });
              }
              res.json({
                message: "Department updated successfully",
                department: results[0],
              });
            }
          );
        }
      );
    }
  );
});

// Delete a department
router.delete("/:id", (req, res) => {
  // Check if department exists
  db.query(
    "SELECT * FROM departments WHERE department_id = ?",
    [req.params.id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (results.length === 0) {
        return res.status(404).json({ message: "Department not found" });
      }

      // Check if department has courses
      db.query(
        "SELECT COUNT(*) as courseCount FROM courses WHERE department_id = ?",
        [req.params.id],
        (err, results) => {
          if (err) {
            return res.status(500).json({ error: err.message });
          }

          if (results[0].courseCount > 0) {
            return res.status(409).json({
              message:
                "Cannot delete department with associated courses. Please reassign or delete the courses first.",
            });
          }

          // Delete department
          db.query(
            "DELETE FROM departments WHERE department_id = ?",
            [req.params.id],
            (err, result) => {
              if (err) {
                return res.status(500).json({ error: err.message });
              }
              res.json({ message: "Department deleted successfully" });
            }
          );
        }
      );
    }
  );
});

// Get all courses in a department
router.get("/:id/courses", (req, res) => {
  const sql = `
        SELECT * FROM courses
        WHERE department_id = ?
    `;

  db.query(sql, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ courses: results });
  });
});

module.exports = router;
