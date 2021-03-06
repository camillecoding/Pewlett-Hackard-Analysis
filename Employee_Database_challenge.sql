CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE title (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, from_date, title)
);

CREATE TABLE department_employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE(dept_name)
);

SELECT * FROM departments;
SELECT * FROM department_employees;

SELECT emp_no, first_name, last_name
INTO employee_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

SELECT ei.emp_no, ei.first_name, 
		ei.last_name, t.title, 
		t.from_date, t.to_date
INTO retirement_titles
FROM employee_info as ei
INNER JOIN title as t 
ON ei.emp_no = t.emp_no
ORDER BY emp_no;

SELECT * FROM retirement_titles;

SELECT DISTINCT ON (emp_no) emp_no,
first_name, 
last_name, 
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT (ut.title) title_count, title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY title
ORDER BY title_count DESC;

SELECT * FROM retiring_titles;

SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, 
		e.last_name, e.birth_date, de.from_date, 
		de.to_date, t.title
INTO mentorship_eligible
FROM employees as e
INNER JOIN department_employees as de
	ON e.emp_no = de.emp_no
INNER JOIN title as t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

SELECT * FROM mentorship_eligible;