-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 02-Set-2025 às 23:52
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `victus`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `catalog_items`
--

CREATE TABLE `catalog_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `item_type` enum('course','event') NOT NULL,
  `title` varchar(160) NOT NULL,
  `slug` varchar(180) NOT NULL,
  `description` text DEFAULT NULL,
  `thumbnail_url` varchar(255) DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` datetime DEFAULT NULL,
  `event_kind` enum('masterclass','workshop','webinar','other') DEFAULT NULL,
  `event_start_at` datetime DEFAULT NULL,
  `event_end_at` datetime DEFAULT NULL,
  `event_location` varchar(255) DEFAULT NULL,
  `event_capacity` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `catalog_items`
--

INSERT INTO `catalog_items` (`id`, `item_type`, `title`, `slug`, `description`, `thumbnail_url`, `is_published`, `published_at`, `event_kind`, `event_start_at`, `event_end_at`, `event_location`, `event_capacity`, `created_at`, `updated_at`) VALUES
(1, 'course', 'Liberdade Alimentar', 'curso-liberdade-alimentar', 'Curso completo de alimentação consciente', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(2, 'course', 'Olimpo', 'curso-olimpo', 'Corpo e mente invencíveis', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(3, 'course', 'Joanaflix', 'curso-joanaflix', 'Aulas didáticas de nutrição', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(4, 'course', 'Workshops', 'curso-workshops', 'Coleção de workshops', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(5, 'course', 'Masterclasses', 'curso-masterclasses', 'Coleção de masterclasses', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(6, 'course', 'Desafio Corpo & Mente Sã', 'curso-desafio-corpo-mente', 'Programa de desafio', NULL, 1, '2025-08-31 15:22:16', NULL, NULL, NULL, NULL, NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(7, 'event', 'Masterclass Maio', 'event-masterclass-maio', NULL, NULL, 1, '2025-05-23 18:00:00', 'masterclass', '2025-05-23 18:00:00', NULL, 'Online', NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(8, 'event', 'Workshop Agosto', 'event-workshop-agosto', NULL, NULL, 1, '2025-08-12 18:00:00', 'workshop', '2025-08-12 18:00:00', NULL, 'Online', NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(9, 'event', 'Webinar Nutrição', 'event-webinar-nutricao', NULL, NULL, 1, '2025-09-05 19:00:00', 'webinar', '2025-09-05 19:00:00', NULL, 'Online', NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(10, 'event', 'Encontro Comunidade', 'event-encontro-comunidade', NULL, NULL, 1, '2025-10-10 17:00:00', 'other', '2025-10-10 17:00:00', NULL, 'Lisboa', NULL, '2025-08-31 15:22:16', '2025-08-31 15:22:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `enrollments`
--

CREATE TABLE `enrollments` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `item_id` bigint(20) UNSIGNED NOT NULL,
  `enrolled_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `enrollments`
--

INSERT INTO `enrollments` (`user_id`, `item_id`, `enrolled_at`) VALUES
(1, 2, '2025-08-31 15:22:16'),
(2, 1, '2025-08-31 15:22:16'),
(3, 1, '2025-08-31 15:22:16'),
(4, 2, '2025-08-31 15:22:16'),
(5, 2, '2025-08-31 15:22:16'),
(6, 3, '2025-08-31 15:22:16'),
(7, 4, '2025-08-31 15:22:16'),
(8, 5, '2025-08-31 15:22:16'),
(9, 6, '2025-08-31 15:22:16'),
(10, 3, '2025-08-31 15:22:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `home_banners`
--

CREATE TABLE `home_banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(160) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `cta_label` varchar(60) DEFAULT NULL,
  `cta_action` varchar(255) DEFAULT NULL,
  `item_id` bigint(20) UNSIGNED DEFAULT NULL,
  `position` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `home_banners`
--

INSERT INTO `home_banners` (`id`, `title`, `subtitle`, `image_url`, `cta_label`, `cta_action`, `item_id`, `position`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Bem-vinda à minha App!', 'Clica para começar', '/img/b1.jpg', 'Começa aqui', 'route:/item/1', 1, 1, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(2, 'Planos personalizados', 'Conteúdos feitos para ti', '/img/b2.jpg', 'Explorar', 'route:/item/2', 2, 2, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(3, 'Comunidade ativa', 'Junta-te ao grupo', '/img/b3.jpg', 'Entrar', 'route:/item/10', 10, 3, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(4, 'Masterclass Maio', 'Não percas', '/img/b4.jpg', 'Ver', 'route:/item/7', 7, 4, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(5, 'Workshop Agosto', 'Inscrições abertas', '/img/b5.jpg', 'Inscrever', 'route:/item/8', 8, 5, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(6, 'Webinar Nutrição', 'Ao vivo', '/img/b6.jpg', 'Assistir', 'route:/item/9', 9, 6, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(7, 'Curso Joanaflix', 'Aulas didáticas', '/img/b7.jpg', 'Ver curso', 'route:/item/3', 3, 7, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(8, 'Desafio Corpo & Mente', 'Começa já', '/img/b8.jpg', 'Participar', 'route:/item/6', 6, 8, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(9, 'Workshops', 'Agenda completa', '/img/b9.jpg', 'Abrir', 'route:/item/4', 4, 9, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(10, 'Masterclasses', 'Biblioteca de masterclasses', '/img/b10.jpg', 'Explorar', 'route:/item/5', 5, 10, 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17');

-- --------------------------------------------------------

--
-- Estrutura da tabela `lessons`
--

CREATE TABLE `lessons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_item_id` bigint(20) UNSIGNED NOT NULL,
  `section_index` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `section_title` varchar(160) NOT NULL,
  `lesson_index` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `title` varchar(160) NOT NULL,
  `description` text DEFAULT NULL,
  `video_url` varchar(255) NOT NULL,
  `duration_seconds` int(10) UNSIGNED DEFAULT NULL,
  `free_preview` tinyint(1) NOT NULL DEFAULT 0,
  `is_favorite` tinyint(1) NOT NULL DEFAULT 0,
  `favorite_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `lessons`
--

INSERT INTO `lessons` (`id`, `course_item_id`, `section_index`, `section_title`, `lesson_index`, `title`, `description`, `video_url`, `duration_seconds`, `free_preview`, `is_favorite`, `favorite_count`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '1 | Bem-vindas', 1, 'Boas-vindas', NULL, 'https://www.youtube.com/watch?v=K18cpp_-gP8', 900, 0, 1, 5, '2025-08-31 15:22:16', '2025-09-02 22:02:59'),
(2, 1, 1, '1 | Bem-vindas', 2, 'Como funciona o curso', NULL, 'https://exemplo.com/v/2', 840, 0, 0, 2, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(3, 1, 2, '2 | Fundamentos', 1, 'Princípios', NULL, 'https://exemplo.com/v/3', 720, 1, 0, 1, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(4, 2, 1, '1 | Introdução', 1, 'Abertura', NULL, 'https://exemplo.com/v/4', 600, 1, 0, 0, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(5, 2, 2, '2 | Treino', 1, 'Mente e Corpo', NULL, 'https://exemplo.com/v/5', 780, 0, 1, 3, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(6, 3, 1, '1 | Primeiros Passos', 1, 'Apresentação', NULL, 'https://exemplo.com/v/6', 540, 1, 0, 0, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(7, 3, 2, '2 | Nutrição', 1, 'Macronutrientes', NULL, 'https://exemplo.com/v/7', 660, 0, 0, 0, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(8, 4, 1, '1 | Workshop 1', 1, 'Organização', NULL, 'https://exemplo.com/v/8', 480, 1, 0, 0, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(9, 5, 1, '1 | Masterclass 1', 1, 'Planeamento', NULL, 'https://exemplo.com/v/9', 900, 0, 0, 0, '2025-08-31 15:22:16', '2025-08-31 15:22:16'),
(10, 6, 1, '1 | Desafio', 1, 'Introdução ao Desafio', NULL, 'https://exemplo.com/v/10', 720, 1, 1, 4, '2025-08-31 15:22:16', '2025-08-31 15:22:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `password_resets`
--

CREATE TABLE `password_resets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `token` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `password_resets`
--

INSERT INTO `password_resets` (`id`, `user_id`, `token`, `expires_at`, `created_at`) VALUES
(1, 1, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(2, 2, 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(3, 3, 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(4, 4, 'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(5, 5, 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(6, 6, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(7, 7, '1111111111111111111111111111111111111111111111111111111111111111', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(8, 8, '2222222222222222222222222222222222222222222222222222222222222222', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(9, 9, '3333333333333333333333333333333333333333333333333333333333333333', '2026-01-01 00:00:00', '2025-08-31 15:21:27'),
(10, 10, '4444444444444444444444444444444444444444444444444444444444444444', '2026-01-01 00:00:00', '2025-08-31 15:21:27');

-- --------------------------------------------------------

--
-- Estrutura da tabela `reminders`
--

CREATE TABLE `reminders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(160) DEFAULT NULL,
  `body` text NOT NULL,
  `active_from` date DEFAULT NULL,
  `active_to` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `reminders`
--

INSERT INTO `reminders` (`id`, `title`, `body`, `active_from`, `active_to`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Lembrete do dia', 'É importante agradecer pelo hoje, sem nunca desistir do amanhã!', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(2, 'Hidratação', 'Bebe água ao longo do dia.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(3, 'Movimento', 'Dá um pequeno passeio.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(4, 'Respira', 'Faz 1 min de respiração profunda.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(5, 'Sono', 'Tenta manter horário regular.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(6, 'Gratidão', 'Anota 3 coisas boas hoje.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(7, 'Postura', 'Estica as costas.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(8, 'Alongamento', '5 min de alongamentos.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(9, 'Alimentação', 'Inclui fruta hoje.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17'),
(10, 'Foco', 'Uma tarefa de cada vez.', '2025-01-01', '2025-12-31', 1, '2025-08-31 15:22:17', '2025-08-31 15:22:17');

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `status` enum('active','blocked','pending') NOT NULL DEFAULT 'active',
  `avatar_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `status`, `avatar_url`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@myapp.test', 'bcrypt123456', 'admin', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(2, 'Cristiana', 'cristiana@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(3, 'João', 'joao@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(4, 'Maria', 'maria@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(5, 'Ana', 'ana@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(6, 'Rui', 'rui@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(7, 'Inês', 'ines@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(8, 'Pedro', 'pedro@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(9, 'Sofia', 'sofia@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17'),
(10, 'Tiago', 'tiago@myapp.test', 'bcrypt123456', 'user', 'active', NULL, '2025-08-31 15:21:17', '2025-08-31 15:21:17');

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_item_registrations`
--

CREATE TABLE `user_item_registrations` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `item_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('registered','interested','attended','cancelled') NOT NULL DEFAULT 'registered',
  `registered_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `user_item_registrations`
--

INSERT INTO `user_item_registrations` (`user_id`, `item_id`, `status`, `registered_at`) VALUES
(1, 8, 'registered', '2025-08-31 15:22:16'),
(2, 7, 'registered', '2025-08-31 15:22:16'),
(3, 7, 'registered', '2025-08-31 15:22:16'),
(4, 8, 'registered', '2025-08-31 15:22:16'),
(5, 8, 'interested', '2025-08-31 15:22:16'),
(6, 9, 'registered', '2025-08-31 15:22:16'),
(7, 9, 'registered', '2025-08-31 15:22:16'),
(8, 10, 'registered', '2025-08-31 15:22:16'),
(9, 10, 'registered', '2025-08-31 15:22:16'),
(10, 7, 'cancelled', '2025-08-31 15:22:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_lesson_progress`
--

CREATE TABLE `user_lesson_progress` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `lesson_id` bigint(20) UNSIGNED NOT NULL,
  `watched_pct` decimal(5,2) NOT NULL DEFAULT 0.00,
  `last_position_seconds` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `last_watched_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `user_lesson_progress`
--

INSERT INTO `user_lesson_progress` (`user_id`, `lesson_id`, `watched_pct`, `last_position_seconds`, `is_completed`, `last_watched_at`) VALUES
(1, 10, 15.00, 108, 0, '2025-08-31 15:22:16'),
(2, 1, 80.00, 720, 0, '2025-08-31 15:22:16'),
(3, 2, 35.50, 298, 0, '2025-08-31 15:22:16'),
(4, 3, 100.00, 720, 1, '2025-08-31 15:22:16'),
(5, 4, 50.00, 300, 0, '2025-08-31 15:22:16'),
(6, 5, 10.00, 78, 0, '2025-08-31 15:22:16'),
(7, 6, 66.66, 360, 0, '2025-08-31 15:22:16'),
(8, 7, 20.00, 120, 0, '2025-08-31 15:22:16'),
(9, 8, 90.00, 432, 0, '2025-08-31 15:22:16'),
(10, 9, 75.00, 675, 0, '2025-08-31 15:22:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `user_weight_log`
--

CREATE TABLE `user_weight_log` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `weight_kg` decimal(5,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `user_weight_log`
--

INSERT INTO `user_weight_log` (`user_id`, `date`, `weight_kg`, `created_at`) VALUES
(2, '2025-08-01', 68.50, '2025-08-31 15:22:17'),
(2, '2025-08-05', 68.20, '2025-08-31 15:22:17'),
(2, '2025-08-10', 67.90, '2025-08-31 15:22:17'),
(3, '2025-08-01', 82.00, '2025-08-31 15:22:17'),
(3, '2025-08-10', 81.60, '2025-08-31 15:22:17'),
(4, '2025-08-01', 59.00, '2025-08-31 15:22:17'),
(4, '2025-08-08', 58.70, '2025-08-31 15:22:17'),
(5, '2025-08-01', 70.00, '2025-08-31 15:22:17'),
(5, '2025-08-10', 69.50, '2025-08-31 15:22:17'),
(6, '2025-08-01', 76.30, '2025-08-31 15:22:17');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `catalog_items`
--
ALTER TABLE `catalog_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_items_type_pub` (`item_type`,`is_published`,`published_at`),
  ADD KEY `idx_items_event_time` (`event_start_at`);

--
-- Índices para tabela `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`user_id`,`item_id`),
  ADD KEY `fk_enroll_item` (`item_id`);

--
-- Índices para tabela `home_banners`
--
ALTER TABLE `home_banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_banner_item` (`item_id`),
  ADD KEY `idx_banner_pos` (`is_active`,`position`);

--
-- Índices para tabela `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_course_section_lesson` (`course_item_id`,`section_index`,`lesson_index`);

--
-- Índices para tabela `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `fk_pw_user` (`user_id`);

--
-- Índices para tabela `reminders`
--
ALTER TABLE `reminders`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices para tabela `user_item_registrations`
--
ALTER TABLE `user_item_registrations`
  ADD PRIMARY KEY (`user_id`,`item_id`),
  ADD KEY `fk_reg_item` (`item_id`);

--
-- Índices para tabela `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD PRIMARY KEY (`user_id`,`lesson_id`),
  ADD KEY `fk_prog_lesson` (`lesson_id`);

--
-- Índices para tabela `user_weight_log`
--
ALTER TABLE `user_weight_log`
  ADD PRIMARY KEY (`user_id`,`date`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `catalog_items`
--
ALTER TABLE `catalog_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `home_banners`
--
ALTER TABLE `home_banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `reminders`
--
ALTER TABLE `reminders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `fk_enroll_item` FOREIGN KEY (`item_id`) REFERENCES `catalog_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_enroll_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `home_banners`
--
ALTER TABLE `home_banners`
  ADD CONSTRAINT `fk_banner_item` FOREIGN KEY (`item_id`) REFERENCES `catalog_items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `lessons`
--
ALTER TABLE `lessons`
  ADD CONSTRAINT `fk_lesson_course_item` FOREIGN KEY (`course_item_id`) REFERENCES `catalog_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `fk_pw_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `user_item_registrations`
--
ALTER TABLE `user_item_registrations`
  ADD CONSTRAINT `fk_reg_item` FOREIGN KEY (`item_id`) REFERENCES `catalog_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reg_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `user_lesson_progress`
--
ALTER TABLE `user_lesson_progress`
  ADD CONSTRAINT `fk_prog_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prog_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `user_weight_log`
--
ALTER TABLE `user_weight_log`
  ADD CONSTRAINT `fk_weight_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
