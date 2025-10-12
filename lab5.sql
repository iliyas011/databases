--TASK 1.1
CREATE  TABLE   employees
(
    employee_id integer,
    First_name  text,
    last_name   text,
    age         integer CHECK ( age BETWEEN 18 AND 65),
    salary      numeric CHECK ( salary > 0 )
);
--TASK 1.2
CREATE  TABLE products_catalog
(
    product_id     integer,
    product_name   text,
    regular_price  numeric,
    discount_price numeric

        CONSTRAINT valid_discount CHECK (
            regular_price > 0 AND
            discount_price > 0 AND
            discount_price < regular_price
            )
);
--TASK 1.3
CREATE  TABLE bookings (
                           booking_id integer ,
                           check_in_date date ,
                           check_out_date date ,
                           num_guests integer  CHECK ( num_guests BETWEEN 1 AND 10 )
);
--TASK 1.4

INSERT INTO employees VALUES (1, 'iliyas', 'Seitkamal', 25, 350000);
INSERT INTO employees VALUES (2, 'dakl', 'DDakl', 40, 500000);

INSERT INTO products_catalog VALUES (1, 'Laptop', 500000, 450000);
INSERT INTO products_catalog VALUES (2, 'Mouse', 10000, 7000);

INSERT INTO bookings VALUES (1, '2025-10-13', '2025-10-20', 3);
INSERT INTO bookings VALUES (2, '2025-12-01', '2025-12-05', 2);



--part 2

--task 2.1
CREATE  TABLE  customers
(
    customer_id       integer NOT NULL,
    email             text    NOT NULL,
    phone             text,
    registration_date date    NOT NULL
);

-- task 2.2
CREATE TABLE inventory
(
    item_id      integer NOT NULL,
    item_name    text    NOT NULL,
    quantity     integer NOT NULL CHECK ( quantity >= 0 ),
    unit_price   numeric NOT NULL CHECK ( unit_price >= 0 ),
    last_updated timestamp NOT NULL
);

-- task 2.3

INSERT INTO customers VALUES (1, 'iliyas@mail.com', '87010000001', '2025-01-01');
INSERT INTO customers VALUES (2, 'dakl@mail.com', NULL, '2025-02-10');

-- PART 3
--task 3.1
CREATE  TABLE users
(
    user_id    integer,
    username   text UNIQUE ,
    email      text UNIQUE ,
    created_at timestamp
);
--task 3.2
CREATE  TABLE  course_enrollments
(
    enrollment_id integer,
    student_id    integer,
    course_code   text,
    semester      text,
    CONSTRAINT Com UNIQUE (student_id, course_code, semester)

);

--task 3.3

INSERT INTO users VALUES (1, 'iliyas', 'iliyas@mail.com', NOW());
INSERT INTO users VALUES (2, 'dakl', 'dakl@mail.com', NOW());

INSERT INTO course_enrollments VALUES (1, 101, 'CS101', 'Fall2025');
INSERT INTO course_enrollments VALUES (2, 101, 'CS102', 'Fall2025');


ALTER TABLE users
    ADD CONSTRAINT unique_username UNIQUE (username),
    ADD CONSTRAINT unique_email UNIQUE (email);

--part 4
--task 4.1

CREATE  TABLE  departments
(
    dept_id   integer PRIMARY KEY,
    dept_name text NOT NULL,
    location  text
);

INSERT INTO departments VALUES (1, 'HR', 'Kyzylorda');
INSERT INTO departments VALUES (2, 'IT', 'Almaty');
INSERT INTO departments VALUES (3, 'Finance', 'Shymkent');

CREATE  TABLE  student_courses(
                                  student_id integer,
                                  course_id integer ,
                                  enrollment_date date ,
                                  grade text ,
                                  PRIMARY KEY  (student_id , course_id)
);

INSERT INTO student_courses VALUES (100, 1, '2025-01-15', 'A');
INSERT INTO student_courses VALUES (100, 2, '2025-02-10', 'B');

--PART 5

CREATE  TABLE  employees_dept
(
    emp_id    integer PRIMARY KEY,
    emp_name  text NOT NULL,
    dept_id   integer REFERENCES departments (dept_id),
    hire_date date
);

CREATE  TABLE  authors
(
    author_id   integer PRIMARY KEY,
    author_name text NOT NULL,
    country     text

);

CREATE  TABLE   publishers
(
    publisher_id   integer PRIMARY KEY,
    publisher_name text NOT NULL,
    city           text
);

CREATE  TABLE  books
(
    book_id          integer PRIMARY KEY,
    title            text NOT NULL,
    author_id        integer REFERENCES authors (author_id),
    publisher_id     integer REFERENCES publishers (publisher_id),
    publication_year integer,
    isbn             text UNIQUE
);

CREATE TABLE categories
(
    category_id   INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE categories
(
    category_id   INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk
(
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id  INTEGER REFERENCES categories (category_id) ON DELETE RESTRICT
);

CREATE TABLE orders
(
    order_id   INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items
(
    item_id    INTEGER PRIMARY KEY,
    order_id   INTEGER REFERENCES orders (order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk (product_id),
    quantity   INTEGER CHECK (quantity > 0)
);

--part 6

CREATE TABLE customers_ecom
(
    customer_id       SERIAL PRIMARY KEY,
    name              TEXT        NOT NULL,
    email             TEXT UNIQUE NOT NULL,
    phone             TEXT,
    registration_date DATE        NOT NULL
);

CREATE TABLE products_ecom
(
    product_id     SERIAL PRIMARY KEY,
    name           TEXT NOT NULL,
    description    TEXT,
    price          NUMERIC CHECK (price >= 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0)
);

CREATE TABLE orders_ecom
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers_ecom (customer_id) ON DELETE CASCADE,
    order_date   DATE NOT NULL,
    total_amount NUMERIC CHECK (total_amount >= 0),
    status       TEXT CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_details_ecom
(
    order_detail_id SERIAL PRIMARY KEY,
    order_id        INTEGER REFERENCES orders_ecom (order_id) ON DELETE CASCADE,
    product_id      INTEGER REFERENCES products_ecom (product_id),
    quantity        INTEGER CHECK (quantity > 0),
    unit_price      NUMERIC CHECK (unit_price > 0)
);





