-- Consulta Zona Horaria
/*
SELECT @@global.time_zone AS 'Zona Horaria Global', 
  @@SESSION.time_zone AS 'Zona Horaria de la Sesión';
*/
  
-- MySQL collate database default
/*
SELECT @@character_set_database AS 'Conjuntos de Caracteres', 
  @@collation_database AS 'Intercalación';
*/

-- Consulta MySQL INNER JOIN
SELECT P.PersonID AS 'ID',
	D.DocumentDescription AS 'Tipo de Documento',
	P.DocumentNumber AS 'Número de Documento',
	P.LastName AS 'Apellidos',
	P.FirstName AS 'Nombres',
	DATE_FORMAT(P.Birthdate, '%d/%m/%Y') AS 'Fecha de Nacimiento',
	P.Address AS 'Dirección de Residencia',
	C.CityName AS 'Ciudad de Residencia'
FROM Persons AS P
	INNER JOIN Citys AS C ON P.City = C.CityID
	INNER JOIN Documents AS D ON P.DocumentType = D.DocumentID
ORDER BY P.LastName ASC;
