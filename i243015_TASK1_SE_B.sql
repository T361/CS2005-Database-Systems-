--- TASK 1 --
CREATE DATABASE HotelManagement;

USE HotelManagement;

CREATE TABLE Guests (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255),
    id_proof_number VARCHAR(50) NOT NULL
);
CREATE TABLE Rooms (
    id INT IDENTITY(1,1) PRIMARY KEY,
    room_number INT NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    capacity INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Available'
);
CREATE TABLE Reservations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    reservation_status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',

    FOREIGN KEY (guest_id) REFERENCES Guests(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);
CREATE TABLE Payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reservation_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,

    FOREIGN KEY (reservation_id) REFERENCES Reservations(id)
);

CREATE TABLE Staff (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    salary INT NOT NULL CHECK (salary > 0),
    hire_date DATE NOT NULL
);


ALTER TABLE Guests 
ADD EMERGENCY_CONTACT CHAR(11) NOT NULL;

ALTER TABLE Staff 
ALTER Column salary DECIMAL(10,2);
