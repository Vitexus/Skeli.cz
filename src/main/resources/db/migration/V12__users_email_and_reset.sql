START TRANSACTION;

ALTER TABLE `users`
  ADD COLUMN `email` varchar(255) DEFAULT NULL,
  ADD UNIQUE KEY `uq_users_email` (`email`);

CREATE TABLE `password_resets` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`token`),
  KEY `idx_password_resets_user` (`user_id`),
  CONSTRAINT `fk_password_resets_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;