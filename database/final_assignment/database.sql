-- Student Record Management System Database

-- Create database
CREATE DATABASE IF NOT EXISTS student_records;
USE student_records;

-- Create Students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create Courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    credit_hours INT NOT NULL,
    description TEXT,
    department_id INT,
    INDEX (department_id)
);

-- Create Departments table
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    head_of_department VARCHAR(100)
);

-- Create Enrollments table (Many-to-Many relationship between Students and Courses)
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY (student_id, course_id) -- A student can only enroll once in a course
);

-- Add foreign key to Courses table if it doesn't exist yet
-- First check if the foreign key exists
SET @constraint_exists = (
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE constraint_schema = 'student_records'
    AND table_name = 'courses'
    AND constraint_name = 'courses_ibfk_1'
);

-- Only add the constraint if it doesn't exist
SET @sql = IF(@constraint_exists = 0,
    'ALTER TABLE courses ADD CONSTRAINT courses_ibfk_1 FOREIGN KEY (department_id) REFERENCES departments(department_id)',
    'SELECT "Foreign key constraint already exists"'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Sample Data: Departments - Only insert if no departments exist
INSERT INTO departments (department_id, department_name, head_of_department)
SELECT 1, 'Computer Science', 'Dr. Jane Smith'
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 1);

INSERT INTO departments (department_id, department_name, head_of_department)
SELECT 2, 'Mathematics', 'Prof. John Williams'
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 2);

INSERT INTO departments (department_id, department_name, head_of_department)
SELECT 3, 'Business Administration', 'Dr. Robert Johnson'
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 3);

-- Sample Data: Students - Only insert if email doesn't exist
INSERT INTO students (first_name, last_name, email, date_of_birth)
SELECT 'Michael', 'Brown', 'michael.brown@example.com', '2000-05-15'
WHERE NOT EXISTS (SELECT 1 FROM students WHERE email = 'michael.brown@example.com');

INSERT INTO students (first_name, last_name, email, date_of_birth)
SELECT 'Emily', 'Davis', 'emily.davis@example.com', '1999-10-22'
WHERE NOT EXISTS (SELECT 1 FROM students WHERE email = 'emily.davis@example.com');

INSERT INTO students (first_name, last_name, email, date_of_birth)
SELECT 'David', 'Johnson', 'david.johnson@example.com', '2001-03-08'
WHERE NOT EXISTS (SELECT 1 FROM students WHERE email = 'david.johnson@example.com');

INSERT INTO students (first_name, last_name, email, date_of_birth)
SELECT 'Sarah', 'Wilson', 'sarah.wilson@example.com', '2000-12-30'
WHERE NOT EXISTS (SELECT 1 FROM students WHERE email = 'sarah.wilson@example.com');

INSERT INTO students (first_name, last_name, email, date_of_birth)
SELECT 'James', 'Taylor', 'james.taylor@example.com', '1998-07-17'
WHERE NOT EXISTS (SELECT 1 FROM students WHERE email = 'james.taylor@example.com');

-- Sample Data: Courses - Only insert if course_code doesn't exist
INSERT INTO courses (course_code, course_name, credit_hours, description, department_id)
SELECT 'CS101', 'Introduction to Programming', 3, 'Basic concepts of programming using Python', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_code = 'CS101');

INSERT INTO courses (course_code, course_name, credit_hours, description, department_id)
SELECT 'CS202', 'Data Structures', 4, 'Fundamental data structures and algorithms', 1
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_code = 'CS202');

INSERT INTO courses (course_code, course_name, credit_hours, description, department_id)
SELECT 'MATH101', 'Calculus I', 3, 'Introduction to differential calculus', 2
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_code = 'MATH101');

INSERT INTO courses (course_code, course_name, credit_hours, description, department_id)
SELECT 'MATH202', 'Linear Algebra', 3, 'Vectors, matrices, and linear transformations', 2
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_code = 'MATH202');

INSERT INTO courses (course_code, course_name, credit_hours, description, department_id)
SELECT 'BUS101', 'Principles of Management', 3, 'Basic concepts of business management', 3
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE course_code = 'BUS101');

-- Sample Data: Enrollments - Only insert if enrollment doesn't exist
INSERT INTO enrollments (student_id, course_id, grade)
SELECT 1, 1, 'A'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 1 AND course_id = 1);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 1, 3, 'B+'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 1 AND course_id = 3);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 2, 1, 'A-'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 2 AND course_id = 1);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 2, 5, 'B'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 2 AND course_id = 5);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 3, 2, 'A'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 3 AND course_id = 2);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 3, 4, 'B-'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 3 AND course_id = 4);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 4, 3, 'B+'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 4 AND course_id = 3);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 4, 5, 'A-'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 4 AND course_id = 5);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 5, 1, 'B'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 5 AND course_id = 1);

INSERT INTO enrollments (student_id, course_id, grade)
SELECT 5, 2, 'A'
WHERE NOT EXISTS (SELECT 1 FROM enrollments WHERE student_id = 5 AND course_id = 2);