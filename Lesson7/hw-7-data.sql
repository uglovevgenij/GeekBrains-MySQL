CREATE DATABASE x;

USE x;



DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO rubrics VALUES
  (NULL, 'Видеокарты'),
  (NULL, 'Память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desсription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id),
  CONSTRAINT fk_products_catalogs FOREIGN KEY (catalog_id) REFERENCES catalogs (id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, desсription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2),
  ('MSI B250M', 'Материнская плата MSI B250M, B250, Socket 1151, DDR4, mATX', 4060.00, DEFAULT);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users (id)
) COMMENT = 'Заказы';

INSERT INTO orders (user_id) VALUES
  (1), (2), (2), (3), (3), (3), (4), (5), (6), (6);

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_products_orders FOREIGN KEY (order_id) REFERENCES orders (id),
  CONSTRAINT fk_orders_products_products FOREIGN KEY (product_id) REFERENCES products (id)
) COMMENT = 'Состав заказа';

INSERT INTO orders_products (order_id, product_id, total) VALUES 
	(1, 1, 1),
	(1, 3, 2),
	(1, 7, 1),
	(2, 2, 2),
	(2, 6, 1),
	(3, 1, 4),
	(3, 5, 1),
	(3, 4, 2),
	(3, 6, 1),
	(4, 2, 1),
	(4, 7, 2),
	(5, 6, 3),
	(5, 7, 1),
	(6, 2, 4),
	(6, 3, 1),
	(6, 6, 2),
	(6, 7, 1),
	(6, 5, 1),
	(7, 2, 2),
	(7, 3, 1),
	(7, 4, 3),
    (8, 3, 1),
    (9, 4, 4),
    (9, 6, 3),
    (9, 7, 3),
    (10, 1, 1),
    (10, 8, 1);
	
DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id),
  CONSTRAINT fk_discounts_users FOREIGN KEY (user_id) REFERENCES users (id),
  CONSTRAINT fk_discounts_products FOREIGN KEY (product_id) REFERENCES products (id)
) COMMENT = 'Скидки';

INSERT INTO discounts (user_id, product_id, discount, started_at, finished_at) VALUES
	(1, 1, 0.1, '2020-12-01', '2021-06-12'),
	(1, 7, 0.2, '2020-12-01', '2021-06-12'),
	(2, 6, 0.5, '2021-03-01', '2021-06-12'),
	(2, 6, 0.5, '2021-03-01', '2021-06-12'),
	(4, 3, 0.3, '2021-01-01', '2021-07-12'),
    (6, 4, 0.2, '2021-01-01', '2021-07-12'),
    (6, 7, 0.2, '2021-01-01', '2021-07-12');

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses (name) VALUES
	('МВидео'), ('Citilink'), ('Мир компьютеров');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_storehouses_products_storehouses FOREIGN KEY (storehouse_id) REFERENCES storehouses (id),
  CONSTRAINT fk_storehouses_products_products FOREIGN KEY (product_id) REFERENCES products (id)
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
	(1, 1, 5),
	(1, 2, 4),
	(1, 6, 6),
	(2, 3, 4),
	(2, 7, 6),
	(3, 4, 3),
	(3, 5, 2),
    (3, 8, 1);
