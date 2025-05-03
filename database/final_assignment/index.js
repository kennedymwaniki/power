const express = require("express");
const app = express();
const db = require("./config/db");

// Import routes
const studentsRoutes = require("./routes/students");
const coursesRoutes = require("./routes/courses");
const enrollmentsRoutes = require("./routes/enrollments");
const departmentsRoutes = require("./routes/departments");

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Root route
app.get("/", (req, res) => {
  res.json({
    message: "Welcome to Student Record Management System API",
    endpoints: {
      students: "/api/students",
      courses: "/api/courses",
      enrollments: "/api/enrollments",
      departments: "/api/departments",
    },
  });
});

// Route middlewares
app.use("/api/students", studentsRoutes);
app.use("/api/courses", coursesRoutes);
app.use("/api/enrollments", enrollmentsRoutes);
app.use("/api/departments", departmentsRoutes);

// Handle 404 errors
app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

// Handle server errors
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: "Server error", error: err.message });
});

// Set port and start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Access API at http://localhost:${PORT}`);
});
