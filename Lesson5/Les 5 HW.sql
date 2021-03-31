DROP DATABASE IF EXISTS shop;

CREATE DATABASE shop;

USE shop;

/*
 *
 *  ПРАКТИЧЕСКОЕ ЗАДАНИЕ ПО ТЕМЕ «ОПЕРАТОРЫ, ФИЛЬТРАЦИЯ, СОРТИРОВКА И ОГРАНИЧЕНИЕ»
 * 
 */

/* Задание 1
 * Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 * Заполните их текущими датой и временем. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '2006-08-29', NULL, NULL);

/* РЕШЕНИЕ ЗАДАНИЯ 1 */
 
UPDATE users
	SET created_at = NOW(), 
		updated_at = NOW();

SELECT * FROM users;


/* Задание 2
 * Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');
 
 /* РЕШЕНИЕ ЗАДАНИЯ 2
  * Не нашел инфу в методичках, пришлось воспользоваться гуглом для решения через STR_TO_DATE */
 
 -- Добавляем новые столбцы для переноса данных в вормате DATETIME
 ALTER TABLE users ADD COLUMN created_at_new DATETIME NULL, ADD COLUMN updated_at_new DATETIME NULL;

-- Анализируем строковые значения в оригинальных колонках через STR_TO_DATE и переносим в формате DATETIME в новые 
UPDATE users
SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
    updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
   
-- Заменяем новые колонки на старые путем удаления старых и переименования новых
ALTER TABLE users 
    DROP created_at, DROP updated_at, 
    RENAME COLUMN created_at_new TO created_at, RENAME COLUMN updated_at_new TO updated_at;
   
SELECT * FROM users;


/* Задание 3
 * В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 * 0, если товар закончился и выше нуля, если на складе имеются запасы.
 * Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех записей. */

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);

/* РЕШЕНИЕ ЗАДАНИЯ 3 */
 
-- Решение из интернета. Оставил вопрос в комментариях
SELECT value FROM storehouses_products ORDER BY IF(value > 0, 0, 1), value;


/* Задание 4
 *  Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий (may, august) */

/* РЕШЕНИЕ ЗАДАНИЯ 4 */

SELECT name, birthday_at, 
	CASE 
	WHEN birthday_at LIKE '%-05-%' THEN 'May'
	WHEN birthday_at LIKE '%-08-%' THEN 'August'
	END AS mounth
FROM users WHERE birthday_at LIKE '%-05-%' OR birthday_at LIKE '%-08-%';


/* Задание 5
 * Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
 * Отсортируйте записи в порядке, заданном в списке IN. */ 

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
 
 /* РЕШЕНИЕ ЗАДАНИЯ 5 */
 
 -- Все еще не понимаю как это работает, но решение подстроил уже самостоятельно =)
 SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY IF(id = 5, 0, 5), id;



/*
 *
 *  ПРАКТИЧЕСКОЕ ЗАДАНИЕ ТЕМЕ «АГРЕГАЦИЯ ДАННЫХ»
 * 
 */

/* Задание 1
Подсчитайте средний возраст пользователей в таблице users. */

/* РЕШЕНИЕ ЗАДАНИЯ 1 */
SELECT AVG( -- функция для поиска среднего значения суммы чисел столбца
	timestampdiff(YEAR, birthday_at, now()) -- функция для отображения полных лет с даты в ячейке по сегодняшний день
	) FROM users;
	

/* Задание 2
Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

/* РЕШЕНИЕ ЗАДАНИЯ 2 */
SELECT 
	DAYNAME(DATE_FORMAT(birthday_at,'2021-%m-%d')) AS nday, COUNT(*) -- выводим день недели относительно 2021 года и счетчик повторений
FROM users GROUP BY nday
HAVING COUNT(*) > 0 
ORDER BY COUNT(*);

/* Задание 3
Подсчитайте произведение чисел в столбце таблицы.*/
DROP TABLE IF EXISTS x;
CREATE TABLE x (id INT PRIMARY KEY);

INSERT INTO x VALUES (1), (2), (3), (4), (5);

/* РЕШЕНИЕ ЗАДАНИЯ 3 */
-- Решение найдено в статье http://www.sql-tutorial.ru/ru/book_product_of_column_values.html
SELECT EXP(SUM(LOG(id))) product FROM x;
