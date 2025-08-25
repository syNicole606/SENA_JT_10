-- Se crea la Base de Datos SENA

-- Creación de la Base de Datos

CREATE DATABASE IF NOT EXISTS `SENA_JT_10`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE SENA_JT_10;

-- Establecer Zona Horaria para la Base de Datos
-- SET GLOBAL time_zone = 'America/Bogota';
SET GLOBAL time_zone = '-05:00';
-- SET time_zone = 'America/Bogota';

-- Se crea la tabla Ciudades
CREATE TABLE Citys (
    CityID INT NOT NULL AUTO_INCREMENT,
    CityName VARCHAR(100),
    PRIMARY KEY (CityID)
);

-- Se crea la tabla Documentos
CREATE TABLE Documents (
    DocumentID INT NOT NULL AUTO_INCREMENT,
    DocumentType VARCHAR(10),
    DocumentDescription VARCHAR(50),
    PRIMARY KEY (DocumentID)
);

-- Se crea la Tabla Personas
CREATE TABLE Persons (
    PersonID INT NOT NULL AUTO_INCREMENT,
    DocumentType INT,
    DocumentNumber INT,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    Birthdate DATE,
    Address VARCHAR(255),
    City INT,
    PRIMARY KEY (PersonID),
    FOREIGN KEY (DocumentType) REFERENCES Documents (DocumentID),
    FOREIGN KEY (City) REFERENCES Citys (CityID)
);

-- Se insertan datos en la tabla Ciudades
INSERT INTO Citys (CityName) VALUES 
('Bogotá'),
('Medellin'),
('Barranquilla'),
('Cali'),
('Pasto');

-- Se insertan datos en la tabla Documentos
INSERT INTO Documents (DocumentType, DocumentDescription) VALUES 
('TI', 'Tarjeta de Identidad'),
('CC', 'Cédula de Ciudadania'),
('CE', 'Cédula de Extranjería'),
('PPT', 'Permiso de Protección Temporal');

-- Se insertan datos en la tabla Personas
INSERT INTO Persons (DocumentType, DocumentNumber, LastName, FirstName, Birthdate, Address, City) VALUES 
(1, 1020589634, 'Gutiérrez Rivera', 'Andrés Felipe', STR_TO_DATE('24/02/2002', '%d/%m/%Y'), 'Carrera 100 No 10-54', 1),
(1, 1015789652, 'Rivera Huertas', 'Luz Ángela', STR_TO_DATE('03/01/2002', '%d/%m/%Y'), 'Calle 13 No 34-26', 1),
(4, 4865217, 'Paez Lesmes', 'Carlos Andrés', STR_TO_DATE('09/06/2005', '%d/%m/%Y'), 'Carrera 15 No 86-12', 1);
