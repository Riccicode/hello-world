-- crear database -- 
CREATE DATABASE SPRINT4;
USE sprint4;

-- crear tabla american_users --
CREATE TABLE american_users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(150),
    birth_date DATE,
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(200)
);
select * from american_users;


-- insertar csv en la tabla american_users --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/american_users.csv'
INTO TABLE american_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'       
IGNORE 1 LINES
(id, name, surname, phone, email, @birth, country, city, postal_code, address)
SET birth_date = STR_TO_DATE(@birth, '%b %e, %Y'); -- se crea una variable @birth temporal para luego transformar el texto a DATE y poder insertarlo --

-- crear tabla companies -- 

CREATE TABLE companies (
    company_id VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL,
    phone VARCHAR(30),
    email VARCHAR(150),
    country VARCHAR(100),
    website VARCHAR(200)
);


select * from companies;

-- insertar csv en tabla companies --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(company_id, company_name, phone, email, country, website);

-- crear tabla credit_cards --

CREATE TABLE credit_cards (
    id VARCHAR(20) PRIMARY KEY,
    user_id INT NOT NULL,
    iban VARCHAR(50),
    pan VARCHAR(30),
    pin VARCHAR(10),
    cvv VARCHAR(10),
    track1 VARCHAR(200),
    track2 VARCHAR(200),
    expiring_date DATE
);

select * from credit_cards;

-- insertar csv en tabla credit_cards -- 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'    
IGNORE 1 LINES
(id, user_id, iban, pan, pin, cvv, track1, track2, @exp)
SET expiring_date = STR_TO_DATE(@exp, '%m/%d/%y');  -- se crea una variable @exp donde temporalmente se almacena el dato de expiring_date y se convierte a DATE para luego insertarlo

-- crear tabla european_users --

CREATE TABLE european_users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(150),
    birth_date DATE,
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(200)
);

select * from european_users;

-- insertar csv en european_users --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/european_users.csv'
INTO TABLE european_users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'    
IGNORE 1 LINES
(id, name, surname, phone, email, @birth, country, city, postal_code, address)
SET birth_date = STR_TO_DATE(@birth, '%b %e, %Y');

-- crear tabla products -- 

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(150),
    price DECIMAL(10,2),       -- ahora sí es número real
    colour VARCHAR(20),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(20)
);

select * from products;

-- insertar csv en tabla products --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, product_name, @price, colour, weight, warehouse_id)
SET price = REPLACE(@price, '$', ''); -- creo una variable temporal para almancear el valor de price para quitarle el signo, asi luego se puede operar ese valor --

-- crear tabla transactions -- 

CREATE TABLE transactions (
    id VARCHAR(50) PRIMARY KEY,
    card_id VARCHAR(20),
    business_id VARCHAR(20),
    timestamp DATETIME,
    amount DECIMAL(10,2),
    declined TINYINT,
    product_ids VARCHAR(100),
    user_id INT,
    lat FLOAT,
    longitude FLOAT
);
select * from transactions;

-- insertar csv en transactions --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'   -- aqui los campos estan separados por ; ---
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'    
IGNORE 1 LINES
(id, card_id, business_id, @ts, amount, declined, product_ids, user_id, lat, longitude)
SET `timestamp` = STR_TO_DATE(@ts, '%Y-%m-%d %H:%i:%s'); -- -- convertir timestamp a DATETIME
  
-- en el ejercicio 3 me di cuenta que deberia haber limpiado los espacios en product_ids, por lo que ahora lo actualizo, pero esto deberia haber estado de entrada en el insert.
UPDATE transactions 
SET product_ids = REPLACE(product_ids, ' ', '');

  
  
  
-- crearemos una tabla nueva con todos los usuarios independientemente de que continente son --

CREATE TABLE data_users AS
SELECT  id, name, surname, phone, email, birth_date, 'America' AS continent, country, city, postal_code, address FROM american_users
UNION ALL
SELECT  id, name, surname, phone, email, birth_date, 'Europe', country, city, postal_code, address FROM european_users;

select * from data_users;

-- ahora estableceremos los FK y los PK correspondiente si no estan creados. --

ALTER TABLE data_users
ADD PRIMARY KEY (id);
  
-- crear fk para credit_cards
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_card
FOREIGN KEY (card_id) REFERENCES credit_cards(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- crear fk para companies -- 
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_companies
FOREIGN KEY (business_id) REFERENCES companies(company_id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- crear fk para data_users --
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_datausers
FOREIGN KEY (user_id) REFERENCES data_users(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- NIVEL 1 --
-- EJERCICIO 1 ---
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules. --

SELECT user_id, COUNT(user_id) AS "cantidad de transacciones", name, surname FROM transactions
JOIN data_users ON user_id = data_users.id
WHERE declined = 0
GROUP BY user_id
HAVING COUNT(user_id) > 80;

-- EJERCICIO 2 --
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.--

SELECT iban, AVG(amount), company_name FROM transactions
JOIN companies ON company_id = business_id
JOIN credit_cards ON credit_cards.user_id = transactions.user_id
WHERE company_name = "Donec Ltd" AND declined = 0
GROUP BY iban;

-- NIVEL 2--
-- EJERCICIO 1 --
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades aleshores és inactiu,
-- si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

CREATE TABLE credit_card_state AS
SELECT subquery.card_id AS card_id, CASE WHEN SUM(subquery.declined) = 3 THEN 'inactivo'
									ELSE 'activo'
									END AS state
FROM (SELECT card_id, timestamp, declined, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS rowi
     FROM transactions
      ) AS subquery
WHERE subquery.rowi <= 3
GROUP BY subquery.card_id;

select * from credit_card_state;

-- Quantes targetes estan actives? --
SELECT COUNT(state) AS tarjetas_activas from credit_card_state
group by state 
having state = 'activo';

-- NIVEL 3 --
-- EJERCICIO 1 --
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada,
-- tenint en compte que des de transaction tens product_ids. Genera la següent consulta:
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.--

-- crear tabla transaction_product que unira la lista de productos con la lista de transacciones -- 

CREATE TABLE IF NOT EXISTS transaction_product (
  transaction_id VARCHAR(50) NOT NULL,
  product_id INT NOT NULL,
  declined TINYINT NOT NULL,
  PRIMARY KEY (transaction_id, product_id)
  );
  
  -- insertar los datos de las transaccions y los products id utilizando  CAST para cambiar de texto a INT , CONCAT para convertir product_ids en formato valido para hacer un JSON
  -- y luego un cross join para tener cada transaccion y cada product_id por separado
  
INSERT INTO transaction_product (transaction_id, product_id, declined)
SELECT 
    transactions.id AS transaction_id,
    CAST(lista_ids.product_id AS UNSIGNED) AS product_id, -- cambia de texto a numero entero positivo --
    transactions.declined AS declined
FROM transactions
CROSS JOIN JSON_TABLE(
					CONCAT('["', REPLACE(transactions.product_ids, ',', '","'), '"]'),  -- json table para cada * incluir $ 
					'$[*]' COLUMNS (product_id VARCHAR(20) PATH '$')
					) AS lista_ids
;


SELECT * FROM transaction_product;
-- luego crear los fk para la nueva tabla creada -- 

-- FK  products.id
ALTER TABLE transaction_product
ADD CONSTRAINT fk_transaction_product_products
FOREIGN KEY (product_id) REFERENCES products(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- FKtransactions.id
ALTER TABLE transaction_product
ADD CONSTRAINT fk_transaction_product_transactions
FOREIGN KEY (transaction_id) REFERENCES transactions(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- finalmente las veces que se ha vendido cada producto --

SELECT products.id AS product_id, 
products.product_name AS product_name, 
COUNT(transaction_product.transaction_id) AS veces_vendido
FROM products
JOIN transaction_product ON transaction_product.product_id = products.id
WHERE declined = 0
GROUP BY products.id, 
			products.product_name
ORDER BY veces_vendido DESC, products.id;

  
  
  
