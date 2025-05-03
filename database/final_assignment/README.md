# Student Record Management System

A complete database management system built with MySQL and Node.js/Express to manage student records, courses, enrollments, and departments.

## Project Overview

The Student Record Management System is designed to handle all aspects of student academic records management, including:

- Student information management
- Course catalog management
- Student enrollment in courses
- Department organization
- Grade recording and tracking

## Database Structure

The system consists of four main entities with their relationships:

1. **Students**: Stores student personal information
2. **Courses**: Contains course details and which department they belong to
3. **Departments**: Contains department information
4. **Enrollments**: Manages the many-to-many relationship between students and courses, including grades

### Entity Relationship Diagram (ERD)

```
+------------+       +-------------+       +-------------+
| Students   |       | Enrollments |       | Courses     |
+------------+       +-------------+       +-------------+
| student_id |<----->| student_id  |       | course_id   |<----+
| first_name |       | course_id   |<----->| course_code |     |
| last_name  |       | grade       |       | course_name |     |
| email      |       | enroll_date |       | credit_hrs  |     |
| birth_date |       +-------------+       | description |     |
| reg_date   |                             | dept_id     |<----|
| is_active  |                             +-------------+     |
+------------+                                                 |
                                                              |
                                          +----------------+   |
                                          | Departments    |   |
                                          +----------------+   |
                                          | department_id  |---+
                                          | dept_name      |
                                          | head_of_dept   |
                                          +----------------+
```

## Technology Stack

- Database: MySQL
- Backend: Node.js with Express
- ORM: Native MySQL Driver

## Setup Instructions

### Prerequisites

- Node.js (v14 or higher)
- MySQL (v8.0 or higher)

### Database Setup

1. Make sure MySQL server is running
2. Log into MySQL and run the database.sql script:

```bash
mysql -u your_username -p < database.sql
```

The database script is designed to be idempotent - it can be run multiple times safely without duplicating data:

- Uses `CREATE TABLE IF NOT EXISTS` for all tables
- Only inserts sample data if it doesn't already exist
- Handles foreign key relationships properly

### Environment Configuration

1. Open `config/db.js` and update the MySQL connection details:

```javascript
const db = mysql.createConnection({
  host: "localhost",
  user: "your_username", // Replace with your MySQL username
  password: "your_password", // Replace with your MySQL password
  database: "student_records",
});
```

#### MySQL 8+ Authentication Notes

If you encounter this error:

```
Error: ER_NOT_SUPPORTED_AUTH_MODE: Client does not support authentication protocol requested by server
```

You can fix it by either:

1. Creating a MySQL user with the legacy authentication method:

```sql
ALTER USER 'your_username'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
```

2. Installing and using the `mysql2` package instead:

```bash
npm install mysql2
```

Then update the import in `config/db.js` to use mysql2 instead.

### Installation

1. Install dependencies:

```bash
npm install
```

2. Start the server:

```bash
npm start
```

Or for development with auto-reload:

```bash
npm run dev
```

3. Access the API at http://localhost:3000

## API Endpoints

### Students

- `GET /api/students` - Get all students
- `GET /api/students/:id` - Get a specific student
- `POST /api/students` - Create a new student
- `PUT /api/students/:id` - Update a student
- `DELETE /api/students/:id` - Delete a student
- `GET /api/students/:id/courses` - Get all courses for a student

### Courses

- `GET /api/courses` - Get all courses
- `GET /api/courses/:id` - Get a specific course
- `POST /api/courses` - Create a new course
- `PUT /api/courses/:id` - Update a course
- `DELETE /api/courses/:id` - Delete a course
- `GET /api/courses/:id/students` - Get all students enrolled in a course

### Enrollments

- `GET /api/enrollments` - Get all enrollments
- `GET /api/enrollments/:id` - Get a specific enrollment
- `POST /api/enrollments` - Create a new enrollment
- `PUT /api/enrollments/:id` - Update an enrollment (grade)
- `DELETE /api/enrollments/:id` - Delete an enrollment

### Departments

- `GET /api/departments` - Get all departments
- `GET /api/departments/:id` - Get a specific department
- `POST /api/departments` - Create a new department
- `PUT /api/departments/:id` - Update a department
- `DELETE /api/departments/:id` - Delete a department
- `GET /api/departments/:id/courses` - Get all courses in a department

## Example API Usage

### Creating a new student

```bash
curl -X POST http://localhost:3000/api/students \
  -H "Content-Type: application/json" \
  -d '{"first_name": "John", "last_name": "Smith", "email": "john.smith@example.com", "date_of_birth": "2002-05-10"}'
```

### Enrolling a student in a course

```bash
curl -X POST http://localhost:3000/api/enrollments \
  -H "Content-Type: application/json" \
  -d '{"student_id": 1, "course_id": 2}'
```

### Updating a student's grade

```bash
curl -X PUT http://localhost:3000/api/enrollments/1 \
  -H "Content-Type: application/json" \
  -d '{"grade": "A-"}'
```

## Project Structure

```
final_assignment/
├── config/
│   └── db.js                # Database connection configuration
├── routes/
│   ├── students.js          # Students API routes
│   ├── courses.js           # Courses API routes
│   ├── enrollments.js       # Enrollments API routes
│   └── departments.js       # Departments API routes
├── database.sql             # SQL file with database schema and sample data
├── index.js                 # Main server file
├── package.json             # Project dependencies
└── README.md                # Project documentation
```

## Troubleshooting

### Module Import Errors

If you encounter module import errors, ensure all route files are using the same module syntax. This project uses CommonJS (`require`/`module.exports`) rather than ES modules (`import`/`export`).

### Database Connection Issues

- Verify MySQL is running with `mysql --version`
- Check that the database name, username, and password in `config/db.js` match your MySQL setup
- Make sure the `student_records` database exists

### Data Duplication on Server Restart

The SQL script in `database.sql` has been updated to prevent duplicating data when it runs multiple times. Each INSERT statement now checks if the data exists before inserting it.

## Future Enhancements

- User authentication and authorization
- Student attendance tracking
- Faculty management
- Academic calendar scheduling
- Report generation (transcripts, grade sheets, etc.)
