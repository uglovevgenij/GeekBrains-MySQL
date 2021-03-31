USE vkles6;

/* 
 * Задание 1. Пусть задан некоторый пользователь.
 * Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. 
 * (можете взять пользователя с любым id). 
*/

-- Выводим счетчик сообщений определенного id и группируем по отправителю
SELECT
		to_user_id, 
		from_user_id, 
		count(*) AS counts
		FROM messages 
		WHERE from_user_id = 6 -- данный id выбран целенаправленого для комментария к Limit
		GROUP BY to_user_id
		ORDER BY counts DESC -- сортируем от большего к меньшему
		-- LIMIT 1; Хочется оставить лимит, чтобы красиво вывести активного пользователя, но тогда он совпадающие значения счетчика.
	
SELECT * FROM users WHERE id IN (1, 11); -- не разобрался как предыдущий запрос правильно вставить вместо значений IN. Счетчик мешает адаптировать его под IN.
	

	
/*
 * Задание 2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.
*/

-- Находим несовершеннолетних пользователей
SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM profiles
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18;

-- Находим их посты
SELECT id, user_id 
FROM posts 
WHERE user_id IN (
	SELECT user_id
	FROM profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18);

-- Запускаем счетчик лайков на посты несовершеннолетних пользователей
SELECT count(post_id) AS all_likes
FROM posts_likes
WHERE like_type = 1 AND post_id IN ( -- учитываем факт, что лайк поставлен на пост и добавляем условия списка предыдущего запроса
	SELECT id FROM posts WHERE user_id IN (
		SELECT user_id
		FROM profiles
		WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18));

/*
 * Задание 3.  Определить, кто больше поставил лайков (всего) - мужчины или женщины?
*/

SELECT -- выводим количество лайков мужчин
	'male' AS gen, 
	(SELECT count(*) AS m 
		FROM posts_likes 
		WHERE like_type = 1 AND user_id IN (
			SELECT user_id FROM profiles WHERE gender = 'm')) AS stat
UNION -- совмещаем запросы, соблюдая схожесть названия колонок
SELECT -- выводим количество лайков женщин
	'female' AS gen, 
	(SELECT count(*) AS f
		FROM posts_likes
		WHERE like_type = 1 AND user_id IN (
			SELECT user_id FROM profiles WHERE gender = 'f')) AS stat
ORDER BY stat DESC
-- LIMIT 1 -- По условиям задачи можно оставить лимит, но таблица с выводом двух гендеров выглядит красивее.
; -- Я целеноправленно включил в поиск только М и Ж, не учитывая тех, кто не указывал свой пол.