DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;

SHOW tables;

CREATE TABLE users (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL, 
	email VARCHAR(145) NOT NULL,
	phone INT UNSIGNED NOT NULL,
	password_hash CHAR(65) DEFAULT NULL, 
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	-- UNIQUE INDEX email_unique (email, phone)
	UNIQUE INDEX email_unique (email),
	UNIQUE INDEX phone_unique (phone)
) ENGINE=InnoDB;

ALTER TABLE users ADD COLUMN passport_number VARCHAR(10);

ALTER TABLE users MODIFY COLUMN passport_number VARCHAR(20);

ALTER TABLE users RENAME COLUMN passport_number TO passport;

ALTER TABLE users ADD UNIQUE KEY passport_unique (passport);

ALTER TABLE users DROP INDEX passport_unique;

ALTER TABLE users DROP COLUMN passport;


SELECT * FROM users;

DESCRIBE users;



CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL,
	gender ENUM('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	photo_id INT UNSIGNED,
	user_status VARCHAR(30),
	city VARCHAR(130),
	country VARCHAR(130),
	UNIQUE INDEX fk_profiles_users_to_idx (user_id),
	CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id)
);

DESCRIBE profiles;


CREATE TABLE messages (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOLEAN DEFAULT FALSE,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	INDEX fk_messages_from_user_idx (from_user_id),
	INDEX fk_messages_to_user_idx (to_user_id),	
	CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;



CREATE TABLE friend_requests (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	accepted BOOLEAN DEFAULT FALSE,
	INDEX fk_friend_requests_from_user_idx (from_user_id),
	INDEX fk_friend_requests_to_user_idx (to_user_id),
	CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)	
);

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL,
  admin_id BIGINT UNSIGNED NOT NULL,
  INDEX fk_communities_users_admin_idx (admin_id),
  CONSTRAINT fk_communities_users FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;


-- n:m
CREATE TABLE communities_users (
  community_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (community_id, user_id),
  INDEX fk_communities_users_comm_idx (community_id),
  INDEX fk_communities_users_users_idx (user_id),
  CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;


-- 1:n
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  media_types_id INT UNSIGNED NOT NULL,
  file_name VARCHAR(245) DEFAULT NULL COMMENT '/files/folder/img.png',
  file_size BIGINT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX fk_media_media_types_idx (media_types_id),
  INDEX fk_media_users_idx (user_id),
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id),
  CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id)
);


/*
Приактическое задание к уроку 3
Придумать 2-3 таблицы для БД vk, которую мы создали на занятии (с перечнем полей, указанием индексов и внешних ключей). Прислать результат в виде скрипта *.sql.
*/
CREATE TABLE banlist (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- id
	user_id BIGINT UNSIGNED NOT NULL, -- кто в листе
	ban_type ENUM('temporary', 'permomently') NOT NULL, -- тип блокировки (временный, пожизненный)
	ban_theme VARCHAR(145) NOT NULL, -- короткое описание бана
	ban_info TEXT NOT NULL, -- за что посадил (текст)
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- когда посадили
	CONSTRAINT fk_ban_user FOREIGN KEY (user_id) REFERENCES users (id),-- внешний ключ юзера
	INDEX fk_user_id_idx (user_id),
	INDEX fk_ban_theme_idx (ban_theme)
);

CREATE TABLE blog ( -- стена или микроблог
	news_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,-- id
	user_id BIGINT UNSIGNED NOT NULL, -- кем создано
	theme VARCHAR(145) NOT NULL,-- заголовок
	ban_info TEXT NOT NULL, -- текст
	media_id BIGINT UNSIGNED NOT NULL, -- вложение медиа
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,-- когда создано
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- когда отредактировано
	private_perf ENUM('for_all', 'for_friends') NOT NULL,-- настройки приватности (публичная или для друзей)
	CONSTRAINT fk_news_creator_id FOREIGN KEY (user_id) REFERENCES users (id), -- внешний ключ создателя
	CONSTRAINT fk_news_media_id FOREIGN KEY (media_id) REFERENCES media (id), -- внешний ключ медиа
	INDEX fk_theme_idx (theme), -- поиск по теме
	INDEX fk_user_id_idx (user_id)
);

