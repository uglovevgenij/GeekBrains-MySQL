DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;

SHOW tables;

CREATE TABLE users (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- UNSIGNED(íå áóäåò îòðèöàòåëüíûì), AUTO_INCREMENT (àâòîìàòè÷åñêè çàïîëíÿåòñÿ ïðè äîáàâëåíèè ñòðîê), PRIMARY KEY (ïåðâè÷íûé êëþ÷, âêëþ÷àþùèé â ñåáè èíäåêñàöèþ è NOT NULL - âîçìîæíîñòü ñîçäàòü ïóñòîå çíà÷åíèå)
	first_name VARCHAR(145) NOT NULL, -- Èìÿ
	last_name VARCHAR(145) NOT NULL, -- Ôàìèëèÿ
	email VARCHAR(145) NOT NULL,
	phone INT UNSIGNED NOT NULL,
	password_hash CHAR(65) DEFAULT NULL, -- hash - êîìáèíàöèÿ öèôð è áóêâ (fdjkgh34khsd -> catmeow), DEFAULT NULL  - ïî äåôîëòó 0. NULL - ýòî îáîçíà÷åíèå ïóñòîãî çíà÷åíèå(íåèçâåñòíîãî). Âàæíî çíàòü, ÷òî îäèí NULL íå ðàâåí äðóãîìó NULL
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- (DATETIME - ôîðìàò äàòàâðåìÿ), (CURRENT_TIMESTAMP - áåðåò òåêóùåå âðåìÿ è äàòó ïðè äîáàâëåíèè, àíàëîã NOW())
	-- UNIQUE INDEX email_unique (email, phone) -- êàê ñîñòàâíîé PRIMARY KEY. Èíäåêñ ñðàáàòûâàåò òîëüêî êîãäà îáå êîëîíêè ïðèñóòñòâóþò â çàïðîñå, ïîýòîìó ñäåëàåì äâà ðàçíûõ èíäåêñà äàëåå
	UNIQUE INDEX email_unique (email),
	UNIQUE INDEX phone_unique (phone)
) ENGINE=InnoDB; -- InnoDB ñàìûé òðàíçàêöèîííî áåçîïàñíûé äâèæîê

-- SELECT * FROM users; -- ïðîñìîòð ñîäåðæèìîãî

-- DESCRIBE users; -- ïðîñìîòð õàðàêòåðèñòèê òàáëèöû

ALTER TABLE users ADD COLUMN passport_number VARCHAR(10); -- ÈÇÌÅÍßÅÌ ÒÀÁËÈÖÓ þçåðñ ÄÎÁÀÂËßß ÊÎËÎÍÊÓ íîìåð ïàñïîðòà

ALTER TABLE users MODIFY COLUMN passport_number VARCHAR(20); -- ÈÇÌÅÍßÅÌ ÒÀÁËÈÖÓ þçåðñ ÌÎÄÈÔÈÖÈÐÓß ÊÎËÎÍÊÓ íîìåð ïàñïîðòà

ALTER TABLE users RENAME COLUMN passport_number TO passport; -- ... ÌÅÍßÅÌ ÊÎËÎÍÊÓ èìÿ ÍÀ èìÿ

ALTER TABLE users ADD UNIQUE KEY passport_unique (passport); -- ÈÇÌÅÍßÅÌ ÒÀÁËÈÖÓ þçåðñ ÄÎÁÀÂËßß ÓÍÈÊÀËÜÍÛÉ ÊËÞ×

ALTER TABLE users DROP INDEX passport_unique; -- ïåðåäóìàëè è óäàëèëè èíäåêñàöèþ

ALTER TABLE users DROP COLUMN passport; -- ïîëíîñòüþ óäàëèëè êîëîíêó


SELECT * FROM users;

DESCRIBE users;


-- 1:1 ñâÿçü
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL,
	gender ENUM('f', 'm', 'x') NOT NULL, -- char(1)
	birthday DATE NOT NULL,
	photo_id INT UNSIGNED,
	user_status VARCHAR(30),
	city VARCHAR(130),
	country VARCHAR(130),
	UNIQUE INDEX fk_profiles_users_to_idx (user_id),
	CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id) -- FOREIGN KEY èñïîëüçóåòñÿ äëÿ ñâÿçè òàáëèö
);

DESCRIBE profiles;


-- 1:n
CREATE TABLE messages (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
	from_user_id BIGINT UNSIGNED NOT NULL, -- id - 1, Âàñÿ
	to_user_id BIGINT UNSIGNED NOT NULL, -- id 2, Ïåòÿ
	txt TEXT NOT NULL, -- txt - ÏÐÈÂÅÒ
	is_delivered BOOLEAN DEFAULT FALSE,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- ON UPDATE CURRENT_TIMESTAMP COMMENT 'Âðåìÿ îáíîâëåíî',
	INDEX fk_messages_from_user_idx (from_user_id),
	INDEX fk_messages_to_user_idx (to_user_id),	
	CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
	CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;


-- n:m
CREATE TABLE friend_requests (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
	from_user_id BIGINT UNSIGNED NOT NULL, -- id - 1, Âàñÿ
	to_user_id BIGINT UNSIGNED NOT NULL, -- id 2, Ïåòÿ
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
  name varchar(45) NOT NULL -- ôîòî, ìóçûêà, äîêè
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
