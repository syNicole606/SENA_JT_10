-- ================================================
-- Script SQL para el sistema "Code And Key"
-- Compatible con MariaDB 10.4.32 (XAMPP)
-- Codificación: utf8mb4_spanish_ci | Zona horaria: -05:00
-- ================================================

-- Establecer codificación y zona horaria
SET NAMES 'utf8mb4';
SET time_zone = '-05:00';

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS code_and_key_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

-- Usar la base de datos
USE code_and_key_db;

-- =============================
-- Tabla: roles
-- =============================
CREATE TABLE IF NOT EXISTS roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE COMMENT 'Nombre del rol (Sofisticado, Aficionado, Secundario)'
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla de roles de usuario';

-- =============================
-- Tabla: usuarios
-- =============================
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Clave primaria única del usuario',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del usuario',
    apellido VARCHAR(100) NOT NULL COMMENT 'Apellido del usuario',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Correo electrónico único del usuario',
    contraseña VARCHAR(255) NOT NULL COMMENT 'Contraseña encriptada del usuario',
    id_rol INT NOT NULL COMMENT 'Referencia al rol del usuario',
    estado ENUM('activo', 'inactivo', 'suspendido') DEFAULT 'activo' COMMENT 'Estado actual del usuario',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de registro del usuario',
    fecha_ultimo_acceso TIMESTAMP NULL COMMENT 'Fecha y hora del último acceso al sistema',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de última actualización',
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol)
        REFERENCES roles(id_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_usuario_email (email),
    INDEX idx_usuario_estado (estado),
    INDEX idx_usuario_rol (id_rol),
    INDEX idx_usuario_nombre_apellido (nombre, apellido)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla que almacena la información de los usuarios del sistema';

-- =============================
-- Tabla: proyectos
-- =============================
CREATE TABLE IF NOT EXISTS proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proyecto VARCHAR(100) NOT NULL COMMENT 'Nombre del proyecto',
    equipo_desarrollo TEXT COMMENT 'Miembros del equipo',
    necesidades TEXT COMMENT 'Necesidades del cliente',
    perspectiva TEXT COMMENT 'Objetivo del proyecto',
    id_usuario INT NOT NULL COMMENT 'Usuario creador del proyecto',
    CONSTRAINT fk_proyecto_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_proyecto_usuario (id_usuario)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla que almacena los proyectos de los usuarios';

-- =============================
-- Tabla: sprints
-- =============================
CREATE TABLE IF NOT EXISTS sprints (
    id_sprint INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del Sprint',
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    observaciones TEXT,
    id_proyecto INT NOT NULL,
    CONSTRAINT fk_sprint_proyecto FOREIGN KEY (id_proyecto)
        REFERENCES proyectos(id_proyecto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_sprint_proyecto (id_proyecto)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla que gestiona los Sprints asociados a proyectos';

-- =============================
-- Tabla: requisitos
-- =============================
CREATE TABLE IF NOT EXISTS requisitos (
    id_requisito INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('RF', 'RNF') NOT NULL COMMENT 'Tipo de requisito',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del requisito',
    descripcion TEXT,
    prioridad ENUM('Alta', 'Media', 'Baja') DEFAULT 'Alta',
    id_proyecto INT NOT NULL,
    CONSTRAINT fk_requisito_proyecto FOREIGN KEY (id_proyecto)
        REFERENCES proyectos(id_proyecto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_requisito_proyecto (id_proyecto),
    INDEX idx_requisito_tipo (tipo)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla de requisitos funcionales y no funcionales';

-- =============================
-- Tabla: documentos
-- =============================
CREATE TABLE IF NOT EXISTS documentos (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_documento VARCHAR(100) NOT NULL,
    tipo_archivo VARCHAR(20),
    ruta TEXT,
    id_proyecto INT NOT NULL,
    CONSTRAINT fk_documento_proyecto FOREIGN KEY (id_proyecto)
        REFERENCES proyectos(id_proyecto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_documento_proyecto (id_proyecto)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla que almacena los documentos cargados por el usuario';

-- =============================
-- Tabla: checklist
-- =============================
CREATE TABLE IF NOT EXISTS checklist (
    id_checklist INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    fecha_creacion DATE NOT NULL,
    id_proyecto INT NOT NULL,
    CONSTRAINT fk_checklist_proyecto FOREIGN KEY (id_proyecto)
        REFERENCES proyectos(id_proyecto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_checklist_proyecto (id_proyecto)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla de checklist de verificación por proyecto';

-- =============================
-- Tabla: pqrs
-- =============================
CREATE TABLE IF NOT EXISTS pqrs (
    id_pqrs INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Petición', 'Queja', 'Reclamo', 'Sugerencia') NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_pqrs_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_pqrs_usuario (id_usuario),
    INDEX idx_pqrs_tipo (tipo)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_spanish_ci
  COMMENT='Tabla que almacena PQRS de los usuarios';

-- ================================================
-- Datos ficticios para pruebas en "Code And Key"
-- ================================================

-- Insertar roles
INSERT INTO roles (nombre_rol) VALUES
('Sofisticado'),
('Aficionado'),
('Secundario');

-- Insertar usuarios
INSERT INTO usuarios (nombre, apellido, email, contraseña, id_rol, estado) VALUES
('Andrés', 'Gutiérrez', 'andres@example.com', 'hashed_pass1', 1, 'activo'),
('Danna', 'Sánchez', 'danna@example.com', 'hashed_pass2', 2, 'activo'),
('Nicole', 'Medina', 'nicole@example.com', 'hashed_pass3', 3, 'activo');

-- Insertar proyectos
INSERT INTO proyectos (nombre_proyecto, equipo_desarrollo, necesidades, perspectiva, id_usuario) VALUES
('Sistema de Gestión de Requisitos', 'Andrés, Danna', 'Automatizar la generación de documentos IEEE 830', 'Optimizar tiempo de desarrollo', 1),
('Web de Tienda Virtual', 'Nicole', 'Aumentar ventas online', 'Crear sitio e-commerce funcional', 3);

-- Insertar sprints
INSERT INTO sprints (nombre, fecha_inicio, fecha_fin, observaciones, id_proyecto) VALUES
('Sprint Inicial', '2025-08-01', '2025-08-10', 'Levantamiento de requerimientos', 1),
('Sprint Diseño', '2025-08-11', '2025-08-20', 'Maquetación de interfaz', 2);

-- Insertar requisitos
INSERT INTO requisitos (tipo, nombre, descripcion, prioridad, id_proyecto) VALUES
('RF', 'Registro de Usuario', 'Permite registrar nuevos usuarios con nombre, correo y contraseña.', 'Alta', 1),
('RNF', 'Disponibilidad 24/7', 'El sistema debe estar disponible todo el tiempo.', 'Alta', 1),
('RF', 'Carrito de Compras', 'Funcionalidad para añadir productos y comprarlos.', 'Alta', 2);

-- Insertar documentos
INSERT INTO documentos (nombre_documento, tipo_archivo, ruta, id_proyecto) VALUES
('Manual de Usuario', 'pdf', '/docs/manual_usuario.pdf', 1),
('Diseño UI', 'png', '/docs/ui_design.png', 2);

-- Insertar checklist
INSERT INTO checklist (descripcion, fecha_creacion, id_proyecto) VALUES
('Validación de requisitos funcionales', '2025-08-05', 1),
('Verificación de interfaz de usuario', '2025-08-12', 2);

-- Insertar pqrs
INSERT INTO pqrs (tipo, descripcion, id_usuario) VALUES
('Sugerencia', 'Agregar modo oscuro al sistema.', 2),
('Queja', 'La interfaz carga lentamente.', 3);

-- =============================
-- Relaciones entre tablas (resumen)
-- =============================
-- usuarios.id_rol → roles.id_rol                  (N:1)
-- proyectos.id_usuario → usuarios.id_usuario      (N:1)
-- sprints.id_proyecto → proyectos.id_proyecto     (N:1)
-- requisitos.id_proyecto → proyectos.id_proyecto  (N:1)
-- documentos.id_proyecto → proyectos.id_proyecto  (N:1)
-- checklist.id_proyecto → proyectos.id_proyecto   (N:1)
-- pqrs.id_usuario → usuarios.id_usuario           (N:1)
