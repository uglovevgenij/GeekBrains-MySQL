USE vkles6;

/* 
 * Задание 1. Пусть задан некоторый пользователь.
 * Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. 
 * (можете взять пользователя с любым id). 
*/

SELECT
		to_user_id, 
		from_user_id, 
		count(*) AS counts
		FROM messages 
		WHERE from_user_id = 10 
		GROUP BY to_user_id;
	
/*
 * Задание 2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.
*/

SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
FROM profiles
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18;

SELECT post_id, user_id
FROM posts_likes
WHERE like_type = 1;



/*
 * Задание 3.  Определить, кто больше поставил лайков (всего) - мужчины или женщины?
*/

/*
 * Задание 4. Найти пользователя, который проявляет наименьшую активность в использовании социальной сети.
*/ 