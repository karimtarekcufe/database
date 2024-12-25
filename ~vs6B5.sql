-- 1. User Data Table
CREATE DATABASE weedingorganizer;
GO
USE weedingorganizer;

CREATE TABLE UserData (
    ID INT PRIMARY KEY IDENTITY(1, 1), -- ID is now the primary key
    UserName VARCHAR(255) UNIQUE,     -- UserName is unique
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    SignUpDate DATE NOT NULL,
    UpdatedDate DATE 

);

-- 2. Payment Table
CREATE TABLE Payment (
    ID INT PRIMARY KEY IDENTITY,
    CreditCardNumber VARCHAR(16) NOT NULL,
    CVV VARCHAR(4) NOT NULL,
    ExpiryDate DATE NOT NULL
);

-- 3. Customers Table
CREATE TABLE Customers (
    ID INT PRIMARY KEY, -- Matches UserData ID
    Address TEXT,
    PaymentID INT ,
    Budget DECIMAL(10, 2) NOT NULL DEFAULT  0,
    FOREIGN KEY (ID) REFERENCES UserData(ID)
	on delete cascade on update cascade, -- Changed to use UserData ID
    FOREIGN KEY (PaymentID) REFERENCES Payment(ID)
	on delete no action 
);

-- 4. Hall Provider Table
CREATE TABLE HallProvider (
    HallID INT identity(1,1),
    ProvID INT ,
    HallName VARCHAR(255) NOT NULL,
    Location TEXT NOT NULL,
    Capacity INT NOT NULL,
    Size DECIMAL(10, 2),
    PRIMARY KEY (HallID, ProvID),
    FOREIGN KEY (ProvID) REFERENCES UserData(ID) -- Changed to use UserData ID
);

-- 5. Request Table
CREATE TABLE Request (
    ID INT PRIMARY KEY IDENTITY(1, 1),
    CustomerID INT,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Date DATE NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    HallID INT,
    provID INT,
    DuePayment DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(ID),
    FOREIGN KEY (HallID, provID) REFERENCES HallProvider(HallID, ProvID) -- Corrected composite foreign key reference
);

-- 6. Request Payment Table
CREATE TABLE RequestPayment (
    RequestID INT,
    CustomerID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (RequestID, CustomerID),
    FOREIGN KEY (RequestID) REFERENCES Request(ID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(ID)
);

-- 7. Guest List Table
CREATE TABLE GuestList (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    RequestID INT,
    GuestName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    Address TEXT,
    FOREIGN KEY (RequestID) REFERENCES Request(ID)
);

-- 8. Transportation Table
CREATE TABLE Transportation (
    ID INT PRIMARY KEY,
    Type VARCHAR(255),
    Serving_Location TEXT NOT NULL,
    Rating DECIMAL(3, 2),
    RequestID INT,
    FOREIGN KEY (ID) REFERENCES UserData(ID), -- Changed to use UserData ID
    FOREIGN KEY (RequestID) REFERENCES Request(ID)
);

-- 9. Caterer Table
CREATE TABLE Caterer (
    ID INT PRIMARY KEY,
    Rating DECIMAL(3, 2),
    FOREIGN KEY (ID) REFERENCES UserData(ID) -- Changed to use UserData ID
);

-- 10. Menu Option Table
CREATE TABLE MenuOption (
    CatererID INT,
    Fname VARCHAR(255),
    Price DECIMAL(10, 2),
    PRIMARY KEY (CatererID, Fname),
    FOREIGN KEY (CatererID) REFERENCES Caterer(ID)
);

-- 11. Menu Requests Table
CREATE TABLE MenuRequests (
    RequestID INT,
    Fname VARCHAR(255),
    CatererID INT,
    Quantity INT,
    PRIMARY KEY (RequestID, Fname, CatererID),
    FOREIGN KEY (RequestID) REFERENCES Request(ID),
    FOREIGN KEY ( CatererID,Fname) REFERENCES MenuOption -- Corrected composite foreign key reference
);

-- 12. Entertainers Table
CREATE TABLE Entertainers (
    ID INT PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(255),
	Price_Per_Hour INT not null,
    FOREIGN KEY (ID) REFERENCES UserData(ID) -- Changed to use UserData ID
);

-- 13. Musician Table
CREATE TABLE Musician (
    EntertainerID INT PRIMARY KEY,
    BandName VARCHAR(255),
    Genre VARCHAR(255),
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(ID)
);

-- 14. Florists Table
CREATE TABLE Florists (
    EntertainerID INT PRIMARY KEY,
    Arrangement TEXT,
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(ID)
);

-- 15. Photographer Table
CREATE TABLE Photographer (
    EntertainerID INT PRIMARY KEY,
    Camera VARCHAR(255),
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(ID)
);

-- 16. Entertainment Request Table
CREATE TABLE EntertainmentRequest (
    RequestID INT,
    EntertainersID INT,
    Type VARCHAR(255),
    PRIMARY KEY (RequestID, EntertainersID),
    FOREIGN KEY (RequestID) REFERENCES Request(ID),
    FOREIGN KEY (EntertainersID) REFERENCES Entertainers(ID)
);
-- 1. Insert into UserData
INSERT INTO UserData (UserName, Password, Role, SignUpDate, UpdatedDate)
VALUES 
('admin', 'adminpass', 'Admin', '2024-12-01', NULL),
('john_doe', 'password123', 'Customer', '2024-12-05', NULL),
('hall_provider', 'securepass', 'Provider', '2024-12-02', NULL),
('caterer_pro', 'catpass', 'Provider', '2024-12-03', NULL),
('dj_rockstar', 'djpass', 'Entertainer', '2024-12-04', NULL);

-- 2. Insert into Payment
INSERT INTO Payment (CreditCardNumber, CVV, ExpiryDate)
VALUES 
('1234567812345678', '123', '2026-01-01'),
('9876543298765432', '456', '2025-12-31');

-- 3. Insert into Customers
INSERT INTO Customers (ID, Address, PaymentID, Budget)
VALUES 
(2, '123 Wedding Lane, Cairo', 1, 30000.00);

-- 4. Insert into HallProvider
INSERT INTO HallProvider (HallID, ProvID, HallName, Location, Capacity, Size)
VALUES 
(1, 3, 'Golden Palace', 'Downtown Cairo', 300, 500.00);

-- 5. Insert into Request
INSERT INTO Request (CustomerID, StartTime, EndTime, Date, Price, HallID, ProvID, DuePayment)
VALUES 
(2, '17:00:00', '23:00:00', '2025-01-15', 15000.00, 1, 3, 5000.00);

-- 6. Insert into RequestPayment
INSERT INTO RequestPayment (RequestID, CustomerID, Amount)
VALUES 
(1, 2, 10000.00);

-- 7. Insert into GuestList
INSERT INTO GuestList (RequestID, GuestName, Phone, Address)
VALUES 
(1, 'Alice Brown', '+201234567890', '456 Event Road, Cairo'),
(1, 'Michael Green', '+201987654321', '789 Guest Ave, Cairo');

-- 8. Insert into Transportation
INSERT INTO Transportation (ID, Type, Serving_Location, Rating, RequestID)
VALUES 
(3, 'Bus', 'Downtown Cairo', 4.8, 1);

-- 9. Insert into Caterer
INSERT INTO Caterer (ID, Rating)
VALUES 
(4, 4.7);

-- 10. Insert into MenuOption
INSERT INTO MenuOption (CatererID, Fname, Price)
VALUES 
(4, 'Grilled Chicken', 150.00),
(4, 'Vegetarian Dish', 120.00);

-- 11. Insert into MenuRequests
INSERT INTO MenuRequests (RequestID, Fname, CatererID, Quantity)
VALUES 
(1, 'Grilled Chicken', 4, 100),
(1, 'Vegetarian Dish', 4, 50);

-- 12. Insert into Entertainers
INSERT INTO Entertainers (ID, Name, Type)
VALUES 
(5, 'DJ Rockstar', 'Musician');

-- 13. Insert into Musician
INSERT INTO Musician (EntertainerID, BandName, Genre)
VALUES 
(5, 'DJ Rockstar', 'Pop & Dance');

-- 14. Insert into EntertainmentRequest
INSERT INTO EntertainmentRequest (RequestID, EntertainersID, Type)
VALUES 
(1, 5, 'Musician');
