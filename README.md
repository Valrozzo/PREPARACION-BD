# PREPARACION-BD
istema de Gestión Hospitalaria — Base de Datos SQL

Este proyecto implementa la arquitectura completa de una base de datos para un Sistema de Gestión Hospitalaria, diseñada bajo principios de normalización, seguridad, transacciones ACID y optimización del rendimiento.

El objetivo es proporcionar una base sólida para administrar pacientes, médicos, departamentos, consultas, hospitalizaciones, prescripciones y habitaciones, así como vistas orientadas a diferentes perfiles de usuarios.

 Características Principales

Modelo relacional completo: departamentos, médicos, pacientes, consultas, medicamentos, hospitalizaciones, prescripciones y habitaciones.

Vistas especializadas para médicos, pacientes y administración.

Mecanismos de seguridad basados en roles y Row Level Security (RLS).

Procedimientos almacenados con manejo transaccional ACID.

Sistema de auditoría mediante triggers.

Índices de optimización para mejorar el rendimiento en consultas frecuentes.
Arquitectura de la Base de Datos

El modelo incluye las siguientes entidades principales:

Departamentos

Médicos

Pacientes

Consultas

Medicamentos

Prescripciones

Habitaciones

Hospitalizaciones

Cada tabla ha sido diseñada siguiendo la Tercera Forma Normal (3FN) para garantizar consistencia y evitar redundancia.
