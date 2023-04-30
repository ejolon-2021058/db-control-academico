DROP DATABASE IF EXISTS control_academico_in5bm;
CREATE DATABASE control_academico_in5bm;
USE control_academico_in5bm;

-- -------------------------------------------------DDL ----------------------------------------------------------------

CREATE TABLE alumnos(
carne VARCHAR(16) not null,
nombre1 VARCHAR(16) not null,
nombre2 VARCHAR (16),
nombre3 VARCHAR (16),
apellido1 VARCHAR(16),
apellido2 VARCHAR (16) NOT NULL,
PRIMARY KEY (carne)
);

CREATE TABLE salones(
id_salon VARCHAR(5)  NOT NULL,
descripcion  VARCHAR(45),
capacidad_max INT NOT NULL,
edificio VARCHAR(16),
nivel INT,
PRIMARY KEY (id_salon)
);


CREATE TABLE carreras_tecnicas(
codigo_tecnico VARCHAR (10) NOT NULL,
carrera VARCHAR (45) NOT NULL,
grado VARCHAR(10) NOT NULL,
seccion CHAR(1) not null,
jornada VARCHAR(10) not null,
PRIMARY KEY (codigo_tecnico)
);



DROP TABLE IF EXISTS instructores;
create table instructores(
id_instructor INT NOT NULL AUTO_INCREMENT,
nombre1 VARCHAR (15) not null,
nombre2 VARCHAR (15),
nombre3 VARCHAR (15),
apellido1 VARCHAR (15) not null,
apellido2 VARCHAR (15),
direccion VARCHAR (50),
email VARCHAR (45) not null,
telefono VARCHAR (25) not null,
fecha_de_nacimiento DATE,
PRIMARY KEY (id_instructor)
);

DROP TABLE IF EXISTS horarios;
CREATE TABLE horarios (
id_horario INT NOT NULL AUTO_INCREMENT,
horario_inicio TIME NOT NULL,
horario_final TIME NOT NULL,
lunes TINYINT(1),
martes TINYINT(1),
miercoles TINYINT(1),
jueves TINYINT(1),
viernes TINYINT(1),
PRIMARY KEY (id_horario)
);

DROP TABLE IF EXISTS cursos;
CREATE TABLE cursos(
id_curso INT NOT NULL AUTO_INCREMENT,
nombre_curso VARCHAR(255) NOT NULL,
ciclo YEAR,
cupo_maximo INT,
cupo_min INT,
carrera_tecnica_id VARCHAR(15) NOT NULL,
horario_id INT not null,
salon_id VARCHAR(5) not null,
instructor_id int not null,
PRIMARY KEY (id_curso),
CONSTRAINT fk_carrera_tecnica_id
FOREIGN KEY (carrera_tecnica_id) REFERENCES carreras_tecnicas (codigo_tecnico)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_horario_id
FOREIGN KEY (horario_id) REFERENCES horarios (id_horario)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_salon_id
FOREIGN KEY (salon_id) REFERENCES salones (id_salon)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_instructor_id
FOREIGN KEY (instructor_id) REFERENCES instructores(id_instructor)
ON delete cascade on update cascade 
);

DROP TABLE IF EXISTS asignaciones_alumnos;
CREATE TABLE asignaciones_alumnos(
id int NOT NULL AUTO_INCREMENT,
alumno_id VARCHAR(16) NOT NULL,
curso_id INT NOT NULL,
fecha_asignacion DATETIME,
PRIMARY KEY(id),
CONSTRAINT fk_alumno_id
FOREIGN KEY (alumno_id)
REFERENCES alumnos(carne)
ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT fk_curso_id
FOREIGN KEY (curso_id)
REFERENCES cursos(id_curso)
ON DELETE CASCADE ON UPDATE CASCADE
);



-- Procedimientos almacenados
-- Alumnos-------------------------------------------------------
-- alumnos read
DROP PROCEDURE IF  EXISTS sp_alumnos_create;
CREATE PROCEDURE sp_alumnos_create(
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_create(IN carne VARCHAR(16), IN nombre1 VARCHAR(16), IN nombre2 VARCHAR(16),
		IN nombre3 VARCHAR(16), IN apellido1 VARCHAR(16), IN apellido2 VARCHAR(16))
	BEGIN
		INSERT INTO alumnos (carne,nombre1,nombre2,nombre3,apellido1,apellido2)
		VALUES(carne,nombre1,nombre2,nombre3,apellido1,apellido2);
END $$
DELIMITER;


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_alumnos_read;
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_read()
	BEGIN
		SELECT * FROM alumnos;
END $$

-- READ BY ID
DROP PROCEDURE IF EXISTS sp_alumnos_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_read_id(IN carne VARCHAR(16))
	BEGIN
		SELECT * FROM alumnos WHERE carne = carne;
END $$ 




-- Update alumnos

DROP PROCEDURE IF EXISTS sp_alumnos_update;
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_update( IN _carne VARCHAR(16),IN _nombre1 VARCHAR(16), IN _nombre2 VARCHAR(16), IN _nombre3 VARCHAR(16),
		IN _apellido1 VARCHAR(16), IN _apellido2 VARCHAR(16))
	BEGIN
		UPDATE alumnos SET
        carne = _carne,
		nombre1 = _nombre1,
		nombre2 = _nombre2,
		nombre3 = _nombre3,
		apellido1 = _apellido1,
		apellido2 = _apellido2
		WHERE carne = _carne;
END $$
-- alumnos delete

DROP PROCEDURE IF EXISTS sp_alumnos_delete;
DELIMITER $$
	CREATE PROCEDURE sp_alumnos_delete(IN _carne VARCHAR(16))
	BEGIN
		DELETE FROM alumnos WHERE carne =_carne;
END $$ 

-- Salones----------------------------------------------------------------------------------------------------------------------------------
-- salones Create-------------------------------------------------

DELIMITER $$
-- DROP PROCEDURE IF  EXISTS sp_salones_create $$
	CREATE PROCEDURE sp_salones_create(IN _id_salon VARCHAR(5), IN _descripcion VARCHAR(45), 
		IN _capacidad_max INT, IN _edificio VARCHAR (16), IN _nivel INT)
	BEGIN
		INSERT INTO salones (id_salon,descripcion,capacidad_max,edificio,nivel)
		VALUES(_id_salon,_descripcion,_capacidad_max,_edificio,_nivel);
END $$
DELIMITER ;

-- Salones read

DELIMITER $$
-- DROP PROCEDURE IF EXISTS sp_salones_read;

	CREATE PROCEDURE sp_salones_read()
	BEGIN
		SELECT * FROM salones;
END $$
DELIMITER ;

-- READ BY ID
DELIMITER $$
-- DROP PROCEDURE IF EXISTS sp_salones_read_id$$

	CREATE PROCEDURE sp_salones_read_id(IN _id_salon VARCHAR(5))
	BEGIN
		SELECT * FROM salones WHERE id_salon = _id_salon;
END $$
DElimiter ;

-- salones update
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_update$$

	CREATE PROCEDURE sp_salones_update(IN _descripcion VARCHAR(45), 
    IN _capacidad_max INT, IN _edificio VARCHAR (16), IN _nivel INT , IN _id_salon VARCHAR(5))
	BEGIN
	UPDATE salones SET
    descripcion = _descripcion,
    capacidad_max = _capacidad_max,
    edificio = _edificio,
    nivel = _nivel
    WHERE
    id_salon = _id_salon;
END $$
DElimiter ;

-- salones delete
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_salones_delete$$
	CREATE PROCEDURE sp_salones_delete(IN _id_salon VARCHAR(5))
	BEGIN
		DELETE FROM salones
		WHERE
		id_salon = _id_salon;
END $$
DElimiter ;

-- carreras Tecnicas------------------------------------------------------------------------------------------

-- carreras tecnicas read
DROP PROCEDURE IF  EXISTS sp_carreras_tecnicas_create;
CREATE PROCEDURE sp_carreras_tecnicas_create(
DELIMITER $$
	CREATE PROCEDURE sp_carreras_tecnicas_create(IN codigo_tecnico VARCHAR(10), IN carrera VARCHAR(45), 
		IN grado VARCHAR(10), IN seccion CHAR(1), IN jornada VARCHAR (10))
	BEGIN
		INSERT INTO carreras_tecnicas (codigo_tecnico,carrera,grado,seccion,jornada)
		VALUES(codigo_tecnico,carrera,grado,seccion,jornada);
END $$
        

DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_read;
DELIMITER $$
	CREATE PROCEDURE sp_carreras_tecnicas_read()
	BEGIN
		SELECT * FROM carreras_tecnicas;
END $$

-- READ BY ID

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_carreras_read_id(IN _codigo_tecnico VARCHAR(10))
	BEGIN
		SELECT * FROM carreras_tecnicas WHERE codigo_tecnico = _codigo_tecnico;
END $$

--  carreras_tecnicas update
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_update;
DELIMITER $$
	CREATE PROCEDURE sp_carreras_tecnicas_update(IN _carrera VARCHAR(45), 
		IN _grado VARCHAR(45), IN _seccion CHAR(1), IN _jornada VARCHAR (10), IN _codigo_tecnico VARCHAR(10))
	BEGIN
		UPDATE carreras_tecnicas SET
		codigo_tecnico = _codigo_tecnico,
        carrera = _carrera,
		grado = _grado,
		seccion = _seccion,
		jornada = _jornada
		WHERE
		codigo_tecnico = _codigo_tecnico;
END $$

-- DELETE carreras_tecnicas
DROP PROCEDURE IF EXISTS sp_carreras_tecnicas_delete;
DELIMITER $$
	CREATE PROCEDURE sp_carreras_tecnicas_delete(IN _codigo_tecnico VARCHAR(10))
	BEGIN
		DELETE FROM carreras_tecnicas
		WHERE
		codigo_tecnico = _codigo_tecnico;
END $$



-- Instructores ----------------------------------------------------------------------------

DROP PROCEDURE IF  EXISTS sp_instructores_create;
DELIMITER $$
	CREATE PROCEDURE sp_instructores_create(IN nombre1 VARCHAR(15), IN nombre2 VARCHAR(15),
		IN nombre3 VARCHAR(15), IN apellido1 VARCHAR(15), IN apellido2 VARCHAR(15),
		IN direccion VARCHAR(50), IN email VARCHAR(45), IN telefono VARCHAR(25), IN fecha_nacimiento DATE)
	BEGIN
		INSERT INTO instructores (nombre1,nombre2,nombre3,apellido1,apellido2,direccion,email,telefono,fecha_de_nacimiento)
		VALUES(nombre1,nombre2,nombre3,apellido1,apellido2,direccion,email,telefono,fecha_de_nacimiento);
END $$

-- Instructores Read 
DROP PROCEDURE IF EXISTS sp_instructores_read;
DELIMITER $$
	CREATE PROCEDURE sp_instructores_read()
	BEGIN
		SELECT * FROM instructores;
END $$

-- Instructores Read by id
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_instructores_read_id $$
DELIMITER $$
	CREATE PROCEDURE sp_instructores_read_id(IN id_instructor INT)
	BEGIN
		SELECT * FROM instructores WHERE id_instructor= id_instructor;
END $$


--  INSTRUCTORES update
DROP PROCEDURE IF EXISTS sp_instructores_update;
DELIMITER $$
	CREATE PROCEDURE sp_instructores_update(IN nombre1 VARCHAR(15), IN nombre2 VARCHAR(15),
		IN nombre3 VARCHAR(15), IN apellido1 VARCHAR(15), IN apellido2 VARCHAR(15),
		IN direccion VARCHAR(50), IN email VARCHAR(45), IN telefono VARCHAR(25), IN fecha_de_nacimiento DATE, IN id_instuctor INT)
	BEGIN
		UPDATE instructores SET
		nombre1 = nombre1,
		nombre2 = nombre2,
		nombre3 = nombre3,
		apellido1 = apellido1,
		apellido2 = apellido2,
		direccion = direccion,
		email = email,
		telefono = telefono,
		fecha_nacimiento =fecha_nacimiento
		WHERE id_instructor = id_instructor;
END $$

-- instructores DELETE 
DROP PROCEDURE IF EXISTS sp_instructores_delete ;
DELIMITER $$
	CREATE PROCEDURE sp_instructores_delete (IN id_instructor INT)
	BEGIN
		DELETE FROM instructores WHERE id_instructor =id_instructor;
END $$ 

-- horarios -----------------------------------------------------------------------
-- horarios create
DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_horarios_create $$
DELIMITER $$
	CREATE PROCEDURE sp_horarios_create(IN horario_inicio TIME, 
		IN horario_final TIME, IN lunes TINYINT, IN martes TINYINT, IN miercoles TINYINT,
		IN jueves TINYINT, IN viernes TINYINT)
	BEGIN
		INSERT INTO horarios (horario_inicio,horario_final,lunes,martes,miercoles,
		jueves,viernes)
		VALUES(horario_inicio,horario_final,lunes,martes,miercoles,jueves,viernes);
END $$
        
 -- Horarios Read 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_read;
DELIMITER $$
	CREATE PROCEDURE sp_horarios_read()
	BEGIN
		SELECT * FROM horarios;
END $$

-- horarios Read by id
DROP PROCEDURE IF EXISTS sp_horarios_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_horarios_read_id(IN id_horario INT)
	BEGIN
		SELECT * FROM horarios WHERE id_horario = id_horario;
END $$

-- horarios Update 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_update;
DELIMITER $$
	CREATE PROCEDURE sp_horarios_update (IN horario_inicio TIME, 
		IN horario_final TIME, IN lunes TINYINT, IN martes TINYINT, IN miercoles TINYINT,
		IN jueves TINYINT, IN viernes TINYINT, IN id INT)
	BEGIN
		UPDATE horarios SET
		horario_inicio = horario_inicio,
		horario_final = horario_final,
		lunes =  lunes,
		martes = martes,
		miercoles = miercoles,
		jueves = jueves,
		viernes = viernes
		WHERE
		id_horario = id_horario;
END $$

-- DELETE horarios

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_horarios_delete;
DELIMITER $$
	CREATE PROCEDURE sp_horarios_delete(IN _id_horario INT)
	BEGIN
		DELETE FROM horarios
		WHERE
		id_horario = _id_horario;
END $$

-- cursos--------------------------------------------------------------------------------
-- cursos create

-- carrera con combo box
-- horario combo box


DROP PROCEDURE IF EXISTS sp_cursos_create;
DELIMITER $$
	CREATE PROCEDURE sp_cursos_create(
    IN _nombre_curso VARCHAR(16),
    IN _ciclo YEAR,
	IN _cupo_maximo INT ,
	IN _cupo_min INT,
	IN _carrera_tecnica_id VARCHAR(8),
	IN _horario_id INT,
	IN _instructor_id INT,
	IN _salon_id VARCHAR(5))
	BEGIN
		INSERT INTO cursos (nombre_curso,ciclo,cupo_maximo,cupo_min,carrera_tecnica_id,
		horario_id,instructor_id,salon_id)
		VALUES(_nombre_curso,_ciclo,_cupo_maximo,_cupo_min,_carrera_tecnica_id,_horario_id
		,_instructor_id, _salon_id);
END $$
  
  -- cursos Read 
DROP PROCEDURE IF EXISTS sp_cursos_read;
DELIMITER $$
	CREATE PROCEDURE sp_cursos_read()
	BEGIN
		SELECT * FROM cursos;
END $$

-- curso Read by id
DROP PROCEDURE IF EXISTS sp_cursos_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_cursos_read_id(IN id_curso INT)
	BEGIN
		SELECT * FROM cursos WHERE id_curso = id_curso;
END $$  

-- cursos UPDATE
DROP PROCEDURE IF EXISTS sp_cursos_update;
DELIMITER $$
	CREATE PROCEDURE sp_cursos_update (IN _nombre_curso VARCHAR(16), IN _ciclo YEAR,
		IN _cupo_maximo INT , IN _cupo_min INT, IN _carrera_tecnica_id VARCHAR(15),
		IN _id_horario INT, IN _instructor_id INT, IN _salon_id INT, IN _id_curso INT)
	BEGIN
		UPDATE cursos SET
		nombre_curso = _nombre_curso,
		ciclo = _ciclo,
		cupo_max = _cupo_max,
		cupo_minimo = _cupo_min,
		carrera_tecnica_id = _carrera_tecnica_id,
		horario_id = _horario_id,
		instructor_id = _instructor_id,
        salon_id = _salon_id
		WHERE
		id_curso = _id_curso;
END $$

-- DELETE cursos
DROP PROCEDURE IF EXISTS sp_cursos_delete;
DELIMITER $$
	CREATE PROCEDURE sp_cursos_delete(IN _id_curso INT)
	BEGIN
		DELETE FROM cursos
		WHERE
		id_curso = _id_curso;
END $$

-- asignaciones_alumnos-------------------------------------------------------------
-- asig_alumnos create

DELIMITER $$
DROP PROCEDURE IF  EXISTS sp_asignaciones_alumnos_create;
DELIMITER $$
	CREATE PROCEDURE sp_asignaciones_alumnos_create(IN _alumno_id VARCHAR(16),IN _cursos_id INT,IN _fecha_asignacion DATETIME)
	BEGIN
		INSERT INTO asignacion_alumnos (alumno_id,curso_id,fecha_asignacion)
		VALUES(_alumno_id,_curso_id,_fecha_asignacion);
END $$
        
  -- asignacion_alumnos Read 
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_read;
DELIMITER $$
	CREATE PROCEDURE sp_asignaciones_alumnos_read()
	BEGIN
		SELECT * FROM asignacion_alumnos;
END $$ 

-- asignacion_alumnos Read by id
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_read_id;
DELIMITER $$
	CREATE PROCEDURE sp_asignaciones_alumnos_read_id(IN _id INT)
	BEGIN
		SELECT * FROM asignacion_alumnos WHERE id = id;
END $	


-- asignacion_alumnos UPDATE
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_update;
DELIMITER $$
	CREATE PROCEDURE sp_asignaciones_alumnos_update(IN _id int ,IN _alumno_id VARCHAR(16), IN _curso_id INT, IN _fecha_asignacion DATETIME)
	BEGIN
		UPDATE asignacion_alumnos SET
		id = _id,
        alumno_id = _alumno_id,
		cursos_id = _curso_id,
		fecha_asignacion = _fecha_asignacion
		WHERE id = _id;
END $$

-- delete asig_alumnos
DROP PROCEDURE IF EXISTS sp_asignaciones_alumnos_delete;
DELIMITER $$
	CREATE PROCEDURE sp_asignaciones_alumnos_delete(IN id INT)
	BEGIN
		DELETE FROM asignacion_alumnos WHERE id =_id;
END $$ 

CALL sp_alumnos_create("2020323","Juan","Carlos","Gabriel","García","Dubón");
CALL sp_alumnos_create("2022421","Courtn","Kevin","Louis","Kingston","Street");
CALL sp_alumnos_create("2018312","Ernesto","ALdair","Eduardo","Sanum","Pérez");
CALL sp_alumnos_create("2020991","Yeremi","Aldair","Jeremias","Pérez","Solorzano");
CALL sp_alumnos_create("2019484","Jose","Alfredo","Fernando","Bonilla","Quéme");
CALL sp_alumnos_create("2018315","Juan","Carlos","Josue","Ramirez","Fuentes");
CALL sp_alumnos_create("2017112","Luis","Edurdo","José","Restrepo","Patiño");
CALL sp_alumnos_create("2022866","Rodrigo","Jose","Carlos","Bonilla","Quiroz");
CALL sp_alumnos_create("2021581","Carlos","Fernando","Aaron","Juarez","Alveño");
CALL sp_alumnos_create("2021331","Ronald","José","Andres","Chinchilla","Tzuruy");

CALL sp_salones_create("A1","Salon con cielo falso pintado",30,"EF1",1);
CALL sp_salones_create("B1","Salon de practicas ",25,"EF1",3);
CALL sp_salones_create("C2","Salon de Laboratorio",40,"EF1",2);
CALL sp_salones_create("D1","Salon amplio con 3 sillas zurdas",40,"EF2",1);
CALL sp_salones_create("F3","Salon pequeño ",25,"EF2",3);
CALL sp_salones_create("G2","salon Mediano",30,"EF2",2);
CALL sp_salones_create("H3","Salon mediano",30,"EF3",3);
CALL sp_salones_create("J1","Salon mediano-grande",35,"EF3",1);
CALL sp_salones_create("K2","Salon mediano-grande",35,"EF3",2);
CALL sp_salones_create("L1","salon pequeño",25,"EF1",1);


CALL sp_carreras_tecnicas_create("IN5BV","Informatica","5to",'B',"Vespertina");
CALL sp_carreras_tecnicas_create("IN5BM","Informatica","5to",'B',"Matutina");
CALL sp_carreras_tecnicas_create("EL4BM","Electronica","4to",'B',"Matutina");
CALL sp_carreras_tecnicas_create("EL4BV","Electronica","4to",'B',"Vespertina");
CALL sp_carreras_tecnicas_create("DI6AM","Dibujo","6to",'A',"Matutina");
CALL sp_carreras_tecnicas_create("DI6AV","Dibujo","6to",'A',"Vespertina");
CALL sp_carreras_tecnicas_create("ELE5AM","Electricidad","5to",'A',"Matutina");
CALL sp_carreras_tecnicas_create("ELE5AV","Electricidad","5to",'A',"Vespertina");
CALL sp_carreras_tecnicas_create("ME5BM","Mécanica","5to",'B',"Matutina");
CALL sp_carreras_tecnicas_create("ME5BV","Mécanica","5to",'B',"Vespertina");


CALL sp_instructores_create("Jose","Salomon","Jesús","Fernández","Fernándezz","zona 3","Fernandez@gmail.com","23133424","1956-03-12");
CALL sp_instructores_create("Luis","Roberto","Aldair","Diaz","Chacón","zona 11","cdiaz@gmail.com","86422580","1993-04-23");
CALL sp_instructores_create("Luisa","Josefa","Fernanda","Dominguez","Dubon","zona5","Dub@gmail.com","12357949","1987-04-21");
CALL sp_instructores_create("Stephany","Matilde","Anastacia","Flores","Enriquez","zona 15","Florez@gmail.com","12656937","1996-06-12");
CALL sp_instructores_create("Ana","Elisabeth","Arely","Pinto","Pérez","zona2","Perezz@gmail.com","3413168","2004-12-12");
CALL sp_instructores_create("Genesis","Fernada","Uril","Cobra","Foquillo","zona 18","Foqui@gmail.com","18523451","1933-12-09");
CALL sp_instructores_create("Esmeralda","Alberta","Patricia","Campos","Gordillo","zona 4","Cxmp@gmail.com","3421218","2001-09-21");
CALL sp_instructores_create("Juan","Carlos","Rodrigo","Diaz","Espinoza","zona 6","Espi@gmail.com","3414313","1998-03-28");
CALL sp_instructores_create("JOrge","Estuardo","Alberto","Dominguez","paz","zona 13","pa@gmail.com","213273912","1969-10-30");
CALL sp_instructores_create("Bryan","José","Jesús","Ulil","Lopez","zona 10","jose@gmail.com","57344538","1987-01-29");

CALL sp_carreras_tecnicas_read;

CALL sp_horarios_create('07:05:00','09:05:00',0,0,1,0,0);
CALL sp_horarios_create('09:05:00','12:05:00',0,0,1,0,0);
CALL sp_horarios_create('07:05:00','11:05:00',1,0,0,0,0);
CALL sp_horarios_create('11:05:00','12:05:00',1,1,0,0,0);
CALL sp_horarios_create('07:05:00','07:35:00',0,1,0,0,0);
CALL sp_horarios_create('07:35:00','12:00:00',0,1,0,0,0);
CALL sp_horarios_create('07:05:00','10:05:00',0,0,0,1,0);
CALL sp_horarios_create('10:05:00','12:05:00',0,0,0,1,0);
CALL sp_horarios_create('07:05:00','09:00:00',0,0,0,0,1);
CALL sp_horarios_create('09:00:00','12:00:00',0,0,0,0,1);

CALL sp_horarios_read;

CALL sp_cursos_create("Matematica",2022,25,10,"IN5BM",1,1,"A1");
CALL sp_cursos_create("Sociales",2022,30,10,"IN5BV",2,2,"B1");
CALL sp_cursos_create("Geografía",2022,30,10,"EL4BM",3,3,"C2");
CALL sp_cursos_create("Estadistica",2022,30,10,"EL4BV",4,4,"D1");
CALL sp_cursos_create("Ingles",2022,30,10,"DI6AM",5,5,"F3");
CALL sp_cursos_create("TIC´s",2022,30,10,"DI6AV",6,6,"G2");
CALL sp_cursos_create("Literatura",2022,30,10,"ELE5AM",7,7,"H3");
CALL sp_cursos_create("Quimica",2022,30,10,"ELE5AV",8,8,"J1");
CALL sp_cursos_create("Física",2022,30,10,"ME5BM",9,9,"K2");
CALL sp_cursos_create("Fílosofía",2022,35,10,"ME5BV",10,10,"L1");
CALL sp_cursos_read;










