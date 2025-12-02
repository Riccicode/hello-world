-- NIVEL 1 --
-- EJERCICIO 1 ---
-- CREAR TABLA ---
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(10) NOT NULL PRIMARY KEY,
	iban VARCHAR(100),
	pan VARCHAR(50),
	pin INT,
	cvv INT,
	expiring_date VARCHAR(10),
    CONSTRAINT FK_transaction_creditcard
    FOREIGN KEY (ID) REFERENCES transaction(credit_card_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL 
    
    );
    
-- EJERCICIO 2 ---
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
    
UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id = "CcU-2938" ;

-- EJERCICIO 3 ------
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- lat	829.999
-- longitude	-117.999
-- amount	111.11
-- declined	0

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined, timestamp)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "111.11", "0", NOW()
		);	  
SET FOREIGN_KEY_CHECKS = 1;

-- EJERCICIO 4 -- 
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card 
DROP COLUMN pan;

-- NIVEL 2 --
-- EJERCICIO 1-- 
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD"; 

-- EJERCICIO 2 -- 
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte.
-- País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW  VistaMarketing as
SELECT company_name, phone, country, AVG(amount) as media_compras
FROM transaction JOIN company ON company_id = company.id
GROUP BY company_id
ORDER BY media_compras DESC;

-- EJERCICIO 3 -- 
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany" -- 

CREATE OR REPLACE VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount) as media_compras
FROM transaction JOIN company ON company_id = company.id
WHERE country = "Germany"
GROUP BY company_id
ORDER BY media_compras DESC;

-- NIVEL 3 --
-- EJERCICIO 1 -- 
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, 
-- però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:
-- OBSERVACIONES: - TABLA COMPANY, ELIMINAR WEBSITE. 
-- 				  - TABLA DATA USER, CAMBIAR NOMBRE TABLA a data_user, CAMBIAR id A INT , CAMBIAR email A personal_email
--                - TABLA CREDIT CARD, CAMBIAR id A VARCHAR (20), CAMBIAR iban A VARCHAR (50), CAMBIAR pin A VARCHAR (4), CAMBIAR expiring_date A VARCHAR(20), AGREGAR fecha_actual DATE
-- 				  - TABLA TRANSACTION, CAMBIAR creditar_card_id A VARCHAR(20), CAMBIAR company_id A VARCHAR(20)
-- 				  - ESTABLECER ID EN TODAS LAS TABLAS COMO PK, ESTABLECER creditar_card_id, company_id y user_id COMO FK

-- Primero crear la tabla USER -- 
CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

-- HACER LAS MODIFICACIONES DE LAS OBSERVACIONES -- 
ALTER TABLE company
DROP COLUMN  website;

RENAME TABLE user TO data_user;

ALTER TABLE data_user
MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT,
CHANGE COLUMN email personal_email VARCHAR(150);

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20) NOT NULL,
MODIFY COLUMN iban VARCHAR(50),
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN expiring_date VARCHAR(20),
ADD COLUMN fecha_actual DATE;

ALTER TABLE transaction
MODIFY COLUMN credit_card_id VARCHAR(20) NULL,
MODIFY COLUMN company_id VARCHAR(20) NULL,
MODIFY COLUMN user_id INT NULL;

-- ESTABLECER Y ASEGURAR QUE ESTEN BIEN LAS PK -- 

ALTER TABLE company
MODIFY COLUMN id VARCHAR(15) NOT NULL ;
  
ALTER TABLE data_user
MODIFY COLUMN id INT NOT NULL;

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR(20) NOT NULL ;

ALTER TABLE `transaction`
MODIFY COLUMN id VARCHAR(255) NOT NULL ;  

-- ELIMINAR FK PREVIAS -- 

SHOW CREATE TABLE transaction

ALTER TABLE `transaction` DROP FOREIGN KEY fk_transaction_creditcard;
ALTER TABLE `transaction` DROP FOREIGN KEY fk_transaction_company;

-- BUSCAR HUERFANOS Y CORREGIRLO PARA PODER CREAR LAS FK --
SELECT DISTINCT company_id
FROM `transaction`
WHERE company_id IS NOT NULL AND company_id NOT IN (SELECT id FROM company);

SELECT DISTINCT credit_card_id
FROM `transaction`
WHERE credit_card_id IS NOT NULL AND credit_card_id NOT IN (SELECT id FROM credit_card);

SELECT DISTINCT user_id
FROM `transaction`
WHERE user_id IS NOT NULL AND user_id NOT IN (SELECT id FROM data_user);

-- CORREGIR HUERFANOS, SETEANDOLOS A NULL YA QUE NO EXISTEN ESAS REFERENCIAS EN LAS OTRAS TABLAS PORQUE NO SE HAN CREADO Y ANTERIORMENTE SE HABIAN INSERTADO CON FOREIGN_KEY_CHECKS = 0-- 
UPDATE `transaction`
LEFT JOIN company
ON `transaction`.company_id = company.id
SET `transaction`.company_id = NULL
WHERE `transaction`.company_id IS NOT NULL
AND company.id IS NULL;
  
UPDATE `transaction`
LEFT JOIN credit_card
ON `transaction`.credit_card_id = credit_card.id
SET `transaction`.credit_card_id = NULL
WHERE `transaction`.credit_card_id IS NOT NULL
AND credit_card.id IS NULL;

UPDATE `transaction`
LEFT JOIN data_user
ON `transaction`.user_id = data_user.id
SET `transaction`.user_id = NULL
WHERE `transaction`.user_id IS NOT NULL
AND data_user.id IS NULL;

-- AHORA SI , AGREGAR LAS FK -- 

ALTER TABLE `transaction`
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE `transaction`
ADD CONSTRAINT fk_transaction_company
FOREIGN KEY (company_id)
REFERENCES company(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE `transaction`
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id)
REFERENCES data_user(id)
ON DELETE SET NULL
ON UPDATE CASCADE;
  
-- EJERCICIO 2 --
-- L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
-- ID de la transacció
-- Nom de l'usuari/ària
-- Cognom de l'usuari/ària
-- IBAN de la targeta de crèdit usada.
-- Nom de la companyia de la transacció realitzada.
-- Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
-- Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.
  
CREATE OR REPLACE VIEW InformeTecnico AS
SELECT `transaction`.id AS transaction_id,
data_user.name AS user_name,
data_user.surname AS user_surname,
data_user.phone AS user_phone,
credit_card.iban,
company.company_name AS company_name,
company.phone AS company_phone,
`transaction`.timestamp AS transaction_date
FROM `transaction`
LEFT JOIN data_user
  ON `transaction`.user_id = data_user.id
LEFT JOIN credit_card
  ON `transaction`.credit_card_id = credit_card.id
LEFT JOIN company
  ON `transaction`.company_id = company.id;
  
-- MOSTRAR VISTA -- 

SELECT * FROM InformeTecnico
ORDER BY transaction_id DESC;
