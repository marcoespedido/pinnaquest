-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 12, 2026 at 07:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pinnaquest_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `date_uploaded` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `title`, `file_path`, `date_uploaded`) VALUES
(39, 'Understanding the Self', 'uploads/1782221709_PSY100-Week-8-The-Sexual-Self-20231022233243 (1).pdf', '2026-06-23 21:35:09'),
(40, 'Science and Development of Reading', 'uploads/1782295058_Chapter-6-Lecture-Week-8-READ100-1-20231028171016.pdf', '2026-06-24 17:57:38'),
(42, 'Readings in Philippine History', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', '2026-06-24 18:06:10');

-- --------------------------------------------------------

--
-- Table structure for table `solo_quiz_answers`
--

CREATE TABLE `solo_quiz_answers` (
  `id` int(11) NOT NULL,
  `result_id` int(11) NOT NULL COMMENT 'FK -> solo_quiz_results.id',
  `question_number` int(11) NOT NULL DEFAULT 0,
  `question_text` text NOT NULL,
  `question_type` varchar(30) NOT NULL DEFAULT 'multiple_choice',
  `options` text DEFAULT NULL COMMENT 'JSON array of the 4 MCQ options, empty for fill_blank',
  `correct_answer` varchar(500) DEFAULT NULL,
  `user_answer` varchar(500) DEFAULT NULL COMMENT 'NULL = timed out / no answer given',
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `solo_quiz_answers`
--

INSERT INTO `solo_quiz_answers` (`id`, `result_id`, `question_number`, `question_text`, `question_type`, `options`, `correct_answer`, `user_answer`, `is_correct`, `created_at`) VALUES
(1, 94, 1, 'What is Theater?', 'multiple_choice', '[\"Characteristic features of dyslexia are difficulties in phonological awareness, verbal\",\"On the other hand, a student who struggles with comprehension\",\"Provides students with an opportunity to practice their reading skills\",\"By increasing the amount of time they are independently reading\"]', 'Provides students with an opportunity to practice their reading skills', 'Characteristic features of dyslexia are difficulties in phonological awareness, verbal', 0, '2026-07-12 13:02:11'),
(2, 94, 2, 'Which of the following best describes Dyslexia?', 'multiple_choice', '[\"Occurs across the range of intellectual abilities\",\"Reader’s Theater provides students with an opportunity to practice\",\"Teachers intervene to reteach and provide instruction that strengthens students’\",\"Characteristic features of dyslexia are difficulties in phonological awareness, verbal\"]', 'Occurs across the range of intellectual abilities', 'Characteristic features of dyslexia are difficulties in phonological awareness, verbal', 0, '2026-07-12 13:02:11'),
(3, 94, 3, 'What does with it, their fluency rate improves?', 'multiple_choice', '[\"Automatically and their comprehension of the material will get better\",\"On the other hand, a student who struggles with comprehension\",\"By increasing the amount of time they are independently reading\",\"Reader’s Theater provides students with an opportunity to practice\"]', 'Automatically and their comprehension of the material will get better', 'Automatically and their comprehension of the material will get better', 1, '2026-07-12 13:02:11'),
(4, 94, 4, 'Which of the following is true about reading?', 'multiple_choice', '[\"Teachers intervene to reteach and provide instruction that strengthens students’ skills\",\"Today’s updated list, Fry’s instant sight words, represents the most commonly used words\",\"The first 25 words alone make up about one-third of all written material\",\"Reader’s Theater provides students with an opportunity to practice their reading skills while performing\"]', 'Reader’s Theater provides students with an opportunity to practice their reading skills while performing', 'Teachers intervene to reteach and provide instruction that strengthens students’ skills', 0, '2026-07-12 13:02:11'),
(5, 94, 5, 'What is Teachers?', 'multiple_choice', '[\"Characteristic features of dyslexia are difficulties in phonological awareness, verbal\",\"On the other hand, a student who struggles with comprehension\",\"Intervene to reteach and provide instruction that strengthens students’ skills\",\"By increasing the amount of time they are independently reading\"]', 'Intervene to reteach and provide instruction that strengthens students’ skills', 'Characteristic features of dyslexia are difficulties in phonological awareness, verbal', 0, '2026-07-12 13:02:11');

-- --------------------------------------------------------

--
-- Table structure for table `solo_quiz_pools`
--

CREATE TABLE `solo_quiz_pools` (
  `id` int(11) NOT NULL,
  `batch_id` varchar(50) NOT NULL COMMENT 'Unique id per forge/generate attempt',
  `user_id` int(11) DEFAULT NULL COMMENT 'Student who generated this pool (nullable if not logged in)',
  `quest_title` varchar(255) DEFAULT NULL,
  `material_path` varchar(255) DEFAULT NULL,
  `difficulty` varchar(20) DEFAULT NULL,
  `quiz_type` varchar(50) DEFAULT NULL,
  `requested_count` int(11) NOT NULL COMMENT 'The N the student actually asked for (e.g. 10)',
  `pool_count` int(11) NOT NULL COMMENT 'How many questions were actually generated in the pool (target 3N)',
  `pool_json` longtext NOT NULL COMMENT 'JSON array of ALL generated questions (the full pool)',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `solo_quiz_pools`
--

INSERT INTO `solo_quiz_pools` (`id`, `batch_id`, `user_id`, `quest_title`, `material_path`, `difficulty`, `quiz_type`, `requested_count`, `pool_count`, `pool_json`, `created_at`) VALUES
(1, 'pool_6a4a425c3b3a86.26471984', 22, 'we', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'multiple_choice', 5, 14, '[{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about levied?\",\"options\":[\"LAND TAX wherein they collect levied on both urban and rural area\",\"In exchange on taxes the government promises to improve the country and its governance\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"The constitution defines the nature and extent of government. democratic republic type government\"],\"answer_index\":0,\"answer\":\"LAND TAX wherein they collect levied on both urban and rural area\"},{\"type\":\"multiple_choice\",\"question\":\"What does Primary source of funds enables?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"The government to function effectively and fulfill its promises\",\"Vice President cannot preside over the Senate Source of funds\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":1,\"answer\":\"The government to function effectively and fulfill its promises\"},{\"type\":\"multiple_choice\",\"question\":\"What is History?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"Primary source of funds that enable the government to function\",\"Vice President cannot preside over the Senate Source of funds\",\"Encompass narrative records of how an institution\'s ways and structure\"],\"answer_index\":3,\"answer\":\"Encompass narrative records of how an institution\'s ways and structure\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Senate Source?\",\"options\":[\"The constitution defines the nature and extent of government. democratic\",\"In exchange on taxes the government promises to improve\",\"Vice President cannot preside over the Senate Source of funds\",\"Of funds that allows our government to function well\"],\"answer_index\":3,\"answer\":\"Of funds that allows our government to function well\"},{\"type\":\"multiple_choice\",\"question\":\"What is Reformed?\",\"options\":[\"In exchange on taxes the government promises to improve\",\"The tax system through the 1986 Tax Reform Program -\",\"Quirino regime tax revenue\",\"Primary source of funds that enable the government to function\"],\"answer_index\":1,\"answer\":\"The tax system through the 1986 Tax Reform Program -\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about government?\",\"options\":[\"LAND TAX wherein they collect levied on both urban and rural area\",\"Vice President cannot preside over the Senate Source of funds that allows our government\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\"],\"answer_index\":1,\"answer\":\"Vice President cannot preside over the Senate Source of funds that allows our government\"},{\"type\":\"multiple_choice\",\"question\":\"How many the fee for cedula to are described?\",\"options\":[\"The fee for cedula to support the maintenance and construction\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\",\"Primary source of funds that enable the government to function\",\"Vice President cannot preside over the Senate Source of funds\"],\"answer_index\":0,\"answer\":\"The fee for cedula to support the maintenance and construction\"},{\"type\":\"multiple_choice\",\"question\":\"What does on taxes the government promises improves?\",\"options\":[\"The constitution defines the nature and extent of government. democratic\",\"In exchange on taxes the government promises to improve\",\"Vice President cannot preside over the Senate Source of funds\",\"The country and its governance\"],\"answer_index\":3,\"answer\":\"The country and its governance\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Aquino?\",\"options\":[\"Present roxas regime\",\"Regime (1986 - 1992) - Reformed the tax system\",\"Marcos authoritarian regime\",\"Diosdado macapagal regime\"],\"answer_index\":1,\"answer\":\"Regime (1986 - 1992) - Reformed the tax system\"},{\"type\":\"multiple_choice\",\"question\":\"What is Vigan?\",\"options\":[\"Spaniards spanish american war\",\"It was the main point of Spanish colonial power\",\"Spanish colonial power\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":1,\"answer\":\"It was the main point of Spanish colonial power\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about regime?\",\"options\":[\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\",\"In exchange on taxes the government promises to improve the country and its governance\",\"The constitution defines the nature and extent of government. democratic republic type government\"],\"answer_index\":1,\"answer\":\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Spanish?\",\"options\":[\"In exchange on taxes the government promises to improve\",\"Colonial power in the northern Luzon\",\"The constitution defines the nature and extent of government. democratic\",\"Luzon equal\"],\"answer_index\":1,\"answer\":\"Colonial power in the northern Luzon\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Senate?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"The constitution defines the nature and extent of government. democratic\",\"Source of funds that allows our government to function well\",\"In exchange on taxes the government promises to improve\"],\"answer_index\":2,\"answer\":\"Source of funds that allows our government to function well\"},{\"type\":\"multiple_choice\",\"question\":\"How many the tax system still are described?\",\"options\":[\"Quirino regime tax revenue\",\"The tax system was still heavily dependent on indirect taxes\",\"Primary source of funds that enable the government to function\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\"],\"answer_index\":1,\"answer\":\"The tax system was still heavily dependent on indirect taxes\"}]', '2026-07-05 19:39:08'),
(2, 'pool_6a4a4260c7c9f4.03950968', 21, 'we', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'multiple_choice', 5, 14, '[{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about government?\",\"options\":[\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"LAND TAX wherein they collect levied on both urban and rural area\",\"Vice President cannot preside over the Senate Source of funds that allows our government\"],\"answer_index\":3,\"answer\":\"Vice President cannot preside over the Senate Source of funds that allows our government\"},{\"type\":\"multiple_choice\",\"question\":\"What does on taxes the government promises improves?\",\"options\":[\"In exchange on taxes the government promises to improve\",\"The constitution defines the nature and extent of government. democratic\",\"Vice President cannot preside over the Senate Source of funds\",\"The country and its governance\"],\"answer_index\":3,\"answer\":\"The country and its governance\"},{\"type\":\"multiple_choice\",\"question\":\"What is Reformed?\",\"options\":[\"Primary source of funds that enable the government to function\",\"Quirino regime tax revenue\",\"The tax system through the 1986 Tax Reform Program -\",\"In exchange on taxes the government promises to improve\"],\"answer_index\":2,\"answer\":\"The tax system through the 1986 Tax Reform Program -\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about levied?\",\"options\":[\"The constitution defines the nature and extent of government. democratic republic type government\",\"In exchange on taxes the government promises to improve the country and its governance\",\"LAND TAX wherein they collect levied on both urban and rural area\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\"],\"answer_index\":2,\"answer\":\"LAND TAX wherein they collect levied on both urban and rural area\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about regime?\",\"options\":[\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"The constitution defines the nature and extent of government. democratic republic type government\",\"In exchange on taxes the government promises to improve the country and its governance\"],\"answer_index\":0,\"answer\":\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\"},{\"type\":\"multiple_choice\",\"question\":\"What is Spanish?\",\"options\":[\"Colonial power in the northern Luzon\",\"The constitution defines the nature and extent of government. democratic\",\"Luzon equal\",\"In exchange on taxes the government promises to improve\"],\"answer_index\":0,\"answer\":\"Colonial power in the northern Luzon\"},{\"type\":\"multiple_choice\",\"question\":\"How many the fee for cedula to are described?\",\"options\":[\"Primary source of funds that enable the government to function\",\"Vice President cannot preside over the Senate Source of funds\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\",\"The fee for cedula to support the maintenance and construction\"],\"answer_index\":3,\"answer\":\"The fee for cedula to support the maintenance and construction\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Aquino?\",\"options\":[\"Diosdado macapagal regime\",\"Marcos authoritarian regime\",\"Regime (1986 - 1992) - Reformed the tax system\",\"Present roxas regime\"],\"answer_index\":2,\"answer\":\"Regime (1986 - 1992) - Reformed the tax system\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Vigan?\",\"options\":[\"It was the main point of Spanish colonial power\",\"The constitution defines the nature and extent of government. democratic\",\"Spanish colonial power\",\"Spaniards spanish american war\"],\"answer_index\":0,\"answer\":\"It was the main point of Spanish colonial power\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Senate?\",\"options\":[\"The constitution defines the nature and extent of government. democratic\",\"In exchange on taxes the government promises to improve\",\"Source of funds that allows our government to function well\",\"Natural Park It is a home for nesting sites\"],\"answer_index\":2,\"answer\":\"Source of funds that allows our government to function well\"},{\"type\":\"multiple_choice\",\"question\":\"What does Primary source of funds enables?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"Vice President cannot preside over the Senate Source of funds\",\"The government to function effectively and fulfill its promises\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":2,\"answer\":\"The government to function effectively and fulfill its promises\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes History?\",\"options\":[\"Encompass narrative records of how an institution\'s ways and structure\",\"Primary source of funds that enable the government to function\",\"Natural Park It is a home for nesting sites\",\"Vice President cannot preside over the Senate Source of funds\"],\"answer_index\":0,\"answer\":\"Encompass narrative records of how an institution\'s ways and structure\"},{\"type\":\"multiple_choice\",\"question\":\"How many the tax system still are described?\",\"options\":[\"Quirino regime tax revenue\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\",\"Primary source of funds that enable the government to function\",\"The tax system was still heavily dependent on indirect taxes\"],\"answer_index\":3,\"answer\":\"The tax system was still heavily dependent on indirect taxes\"},{\"type\":\"multiple_choice\",\"question\":\"What is Senate Source?\",\"options\":[\"Of funds that allows our government to function well\",\"Vice President cannot preside over the Senate Source of funds\",\"In exchange on taxes the government promises to improve\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":0,\"answer\":\"Of funds that allows our government to function well\"}]', '2026-07-05 19:39:12'),
(3, 'pool_6a4a4271110f22.23627057', 22, 'we', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'multiple_choice', 5, 14, '[{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Vigan?\",\"options\":[\"Spaniards spanish american war\",\"Spanish colonial power\",\"It was the main point of Spanish colonial power\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":2,\"answer\":\"It was the main point of Spanish colonial power\"},{\"type\":\"multiple_choice\",\"question\":\"What does Primary source of funds enables?\",\"options\":[\"The government to function effectively and fulfill its promises\",\"Natural Park It is a home for nesting sites\",\"Vice President cannot preside over the Senate Source of funds\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":0,\"answer\":\"The government to function effectively and fulfill its promises\"},{\"type\":\"multiple_choice\",\"question\":\"What is Senate?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"In exchange on taxes the government promises to improve\",\"Source of funds that allows our government to function well\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":2,\"answer\":\"Source of funds that allows our government to function well\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Aquino?\",\"options\":[\"Regime (1986 - 1992) - Reformed the tax system\",\"Diosdado macapagal regime\",\"Marcos authoritarian regime\",\"Present roxas regime\"],\"answer_index\":0,\"answer\":\"Regime (1986 - 1992) - Reformed the tax system\"},{\"type\":\"multiple_choice\",\"question\":\"What is History?\",\"options\":[\"Natural Park It is a home for nesting sites\",\"Primary source of funds that enable the government to function\",\"Vice President cannot preside over the Senate Source of funds\",\"Encompass narrative records of how an institution\'s ways and structure\"],\"answer_index\":3,\"answer\":\"Encompass narrative records of how an institution\'s ways and structure\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about government?\",\"options\":[\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"LAND TAX wherein they collect levied on both urban and rural area\",\"Vice President cannot preside over the Senate Source of funds that allows our government\",\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\"],\"answer_index\":2,\"answer\":\"Vice President cannot preside over the Senate Source of funds that allows our government\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Senate Source?\",\"options\":[\"Of funds that allows our government to function well\",\"Vice President cannot preside over the Senate Source of funds\",\"In exchange on taxes the government promises to improve\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":0,\"answer\":\"Of funds that allows our government to function well\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Reformed?\",\"options\":[\"The tax system through the 1986 Tax Reform Program -\",\"In exchange on taxes the government promises to improve\",\"Quirino regime tax revenue\",\"Primary source of funds that enable the government to function\"],\"answer_index\":0,\"answer\":\"The tax system through the 1986 Tax Reform Program -\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about levied?\",\"options\":[\"The constitution defines the nature and extent of government. democratic republic type government\",\"In exchange on taxes the government promises to improve the country and its governance\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"LAND TAX wherein they collect levied on both urban and rural area\"],\"answer_index\":3,\"answer\":\"LAND TAX wherein they collect levied on both urban and rural area\"},{\"type\":\"multiple_choice\",\"question\":\"What does on taxes the government promises improves?\",\"options\":[\"In exchange on taxes the government promises to improve\",\"Vice President cannot preside over the Senate Source of funds\",\"The country and its governance\",\"The constitution defines the nature and extent of government. democratic\"],\"answer_index\":2,\"answer\":\"The country and its governance\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following best describes Spanish?\",\"options\":[\"In exchange on taxes the government promises to improve\",\"The constitution defines the nature and extent of government. democratic\",\"Luzon equal\",\"Colonial power in the northern Luzon\"],\"answer_index\":3,\"answer\":\"Colonial power in the northern Luzon\"},{\"type\":\"multiple_choice\",\"question\":\"Which of the following is true about regime?\",\"options\":[\"In exchange on taxes the government promises to improve the country and its governance\",\"Badjao - known for their beautifully woven sails and ocean-faring lifestyle\",\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\",\"The constitution defines the nature and extent of government. democratic republic type government\"],\"answer_index\":2,\"answer\":\"Ramon Magsaysay, Carlos Garcia, & Diosdado Macapagal Regime (1953 - 1965) - The period\"},{\"type\":\"multiple_choice\",\"question\":\"How many the tax system still are described?\",\"options\":[\"The tax system was still heavily dependent on indirect taxes\",\"Quirino regime tax revenue\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\",\"Primary source of funds that enable the government to function\"],\"answer_index\":0,\"answer\":\"The tax system was still heavily dependent on indirect taxes\"},{\"type\":\"multiple_choice\",\"question\":\"How many the fee for cedula to are described?\",\"options\":[\"Primary source of funds that enable the government to function\",\"Aquino Regime (1986 - 1992) - Reformed the tax system\",\"The fee for cedula to support the maintenance and construction\",\"Vice President cannot preside over the Senate Source of funds\"],\"answer_index\":2,\"answer\":\"The fee for cedula to support the maintenance and construction\"}]', '2026-07-05 19:39:29'),
(4, 'pool_6a4f9e3e109578.08196966', 21, 'qwe', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'multiple_choice', 5, 16, '[{\"question\":\"What type of government does the Philippines have?\",\"options\":[\"Monarchy\",\"Dictatorship\",\"Democratic Republic\",\"Theocracy\"],\"answer_index\":2,\"answer\":\"Democratic Republic\"},{\"question\":\"What was the first constitution of the Philippines?\",\"options\":[\"1897 Constitution\",\"1935 Constitution\",\"1973 Constitution\",\"1987 Constitution\"],\"answer_index\":0,\"answer\":\"1897 Constitution\"},{\"question\":\"What is the purpose of the cedula tax?\",\"options\":[\"To tax urban properties\",\"To tax businesses and industries\",\"To tax males\",\"To tax foreigners\"],\"answer_index\":2,\"answer\":\"To tax males\"},{\"question\":\"Who introduced the cedula tax?\",\"options\":[\"Spanish colonizers\",\"American colonizers\",\"Filipino revolutionaries\",\"Japanese occupiers\"],\"answer_index\":1,\"answer\":\"American colonizers\"},{\"question\":\"What is the industria tax?\",\"options\":[\"A tax on urban properties\",\"A tax on businesses and industries\",\"A tax on males\",\"A tax on foreigners\"],\"answer_index\":1,\"answer\":\"A tax on businesses and industries\"},{\"question\":\"Who introduced the industria tax?\",\"options\":[\"Spanish colonizers\",\"American colonizers\",\"Filipino revolutionaries\",\"Japanese occupiers\"],\"answer_index\":1,\"answer\":\"American colonizers\"},{\"question\":\"What is the tributos tax?\",\"options\":[\"A tax on urban properties\",\"A tax on businesses and industries\",\"A tax on males\",\"A tax on goods and services\"],\"answer_index\":3,\"answer\":\"A tax on goods and services\"},{\"question\":\"Who introduced the tributos tax?\",\"options\":[\"Spanish colonizers\",\"American colonizers\",\"Filipino revolutionaries\",\"Japanese occupiers\"],\"answer_index\":0,\"answer\":\"Spanish colonizers\"},{\"question\":\"What is the ur bana tax?\",\"options\":[\"A tax on urban properties\",\"A tax on businesses and industries\",\"A tax on males\",\"A tax on foreigners\"],\"answer_index\":0,\"answer\":\"A tax on urban properties\"},{\"question\":\"Who introduced the ur bana tax?\",\"options\":[\"Spanish colonizers\",\"American colonizers\",\"Filipino revolutionaries\",\"Japanese occupiers\"],\"answer_index\":0,\"answer\":\"Spanish colonizers\"},{\"question\":\"What is the current taxation system of the Philippines?\",\"options\":[\"Income tax and value-added tax\",\"Income tax and sales tax\",\"Income tax and property tax\",\"Income tax and franchise tax\"],\"answer_index\":0,\"answer\":\"Income tax and value-added tax\"},{\"question\":\"What is the purpose of taxation?\",\"options\":[\"To punish citizens\",\"To reward citizens\",\"To fund government services and projects\",\"To promote economic growth\"],\"answer_index\":2,\"answer\":\"To fund government services and projects\"},{\"question\":\"What is the effect of taxation on the economy?\",\"options\":[\"It reduces economic growth\",\"It increases economic growth\",\"It has no effect on economic growth\",\"It promotes economic stability\"],\"answer_index\":1,\"answer\":\"It increases economic growth\"},{\"question\":\"What is the role of taxation in the Philippine economy?\",\"options\":[\"It is the primary source of government revenue\",\"It is the secondary source of government revenue\",\"It is not a significant source of government revenue\",\"It is not a source of government revenue\"],\"answer_index\":0,\"answer\":\"It is the primary source of government revenue\"},{\"question\":\"What is the impact of taxation on citizens?\",\"options\":[\"It reduces their income\",\"It increases their income\",\"It has no effect on their income\",\"It promotes economic stability\"],\"answer_index\":0,\"answer\":\"It reduces their income\"},{\"question\":\"What is the purpose of tax reforms?\",\"options\":[\"To reduce government revenue\",\"To increase government revenue\",\"To promote economic growth\",\"To punish citizens\"],\"answer_index\":2,\"answer\":\"To promote economic growth\"}]', '2026-07-09 21:12:30'),
(5, 'pool_6a4f9eee2178a8.81967530', 21, 'qwe', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'fill_blanks', 5, 16, '[{\"question\":\"The Philippine Constitution is a set of rules that govern the country, it is also known as the _______\",\"options\":[],\"answer_index\":-1,\"answer\":\"fundamental law\",\"distractors\":[\"executive order\",\"administrative code\",\"civil service commission\"]},{\"question\":\"The first Philippine Constitution was written in _______\",\"options\":[],\"answer_index\":-1,\"answer\":\"1897\",\"distractors\":[\"1899\",\"1913\",\"1935\"]},{\"question\":\"The Malolos Constitution was promulgated on _______\",\"options\":[],\"answer_index\":-1,\"answer\":\"January 21, 1899\",\"distractors\":[\"June 12, 1898\",\"August 23, 1902\",\"October 14, 1913\"]},{\"question\":\"The Philippine Organic Act served as a fundamental piece of legislation for the _______\",\"options\":[],\"answer_index\":-1,\"answer\":\"Insular Government\",\"distractors\":[\"National Assembly\",\"Civil Service Commission\",\"Commission on Elections\"]},{\"question\":\"The 1913 _______ Tariff Act led to a decline in government revenue\",\"options\":[],\"answer_index\":-1,\"answer\":\"Underwood-Simmons\",\"distractors\":[\"Jones Law\",\"Tydings-McDuffie Act\",\"Harrison Act\"]},{\"question\":\"The 1935 Constitution prepared the nation for _______\",\"options\":[],\"answer_index\":-1,\"answer\":\"independence\",\"distractors\":[\"democracy\",\"decentralization\",\"parliamentary system\"]},{\"question\":\"The 1973 Constitution revised the retirement age for members of the _______ to 70 years old\",\"options\":[],\"answer_index\":-1,\"answer\":\"judiciary\",\"distractors\":[\"legislature\",\"executive\",\"civil service commission\"]},{\"question\":\"The 1987 Constitution established a _______ system\",\"options\":[],\"answer_index\":-1,\"answer\":\"semi-presidential\",\"distractors\":[\"parliamentary\",\"presidential\",\"monarchic\"]},{\"question\":\"The Constitutional Commission includes the _______, Civil Service Commission, and Commission on Elections\",\"options\":[],\"answer_index\":-1,\"answer\":\"Commission on Audit\",\"distractors\":[\"National Assembly\",\"Supreme Court\",\"Department of Justice\"]},{\"question\":\"The 1987 Constitution provides for the creation of laws through _______ and resolutions\",\"options\":[],\"answer_index\":-1,\"answer\":\"bills\",\"distractors\":[\"executive orders\",\"administrative orders\",\"proclamations\"]},{\"question\":\"The Philippine Constitution history is a record of the country\'s _______ principles and structures\",\"options\":[],\"answer_index\":-1,\"answer\":\"governance\",\"distractors\":[\"economic\",\"social\",\"cultural\"]},{\"question\":\"The Philippines has a _______ type of government\",\"options\":[],\"answer_index\":-1,\"answer\":\"democratic republic\",\"distractors\":[\"monarchy\",\"dictatorship\",\"oligarchy\"]},{\"question\":\"The Constitution defines the _______ and extent of government\",\"options\":[],\"answer_index\":-1,\"answer\":\"nature\",\"distractors\":[\"structure\",\"powers\",\"functions\"]},{\"question\":\"The Philippine government is highly _______ with power equally distributed\",\"options\":[],\"answer_index\":-1,\"answer\":\"decentralized\",\"distractors\":[\"centralized\",\"federalized\",\"unitary\"]},{\"question\":\"The 1987 Constitution provides for the creation of laws through _______ and resolutions in the Philippine legislative body\",\"options\":[],\"answer_index\":-1,\"answer\":\"bills\",\"distractors\":[\"proclamations\",\"executive orders\",\"administrative orders\"]},{\"question\":\"The system of government in the Philippines revolves around three separate and sovereign yet interdependent _______: Executive, Legislature, Judiciary\",\"options\":[],\"answer_index\":-1,\"answer\":\"branches\",\"distractors\":[\"departments\",\"agencies\",\"commissions\"]}]', '2026-07-09 21:15:26'),
(6, 'pool_6a4f9fe0e16bf4.70669668', 21, 'qwe', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'easy', 'fill_blanks', 5, 15, '[{\"question\":\"The Philippine Constitution sets out the fundamental _______ by which the state is governed.\",\"options\":[],\"answer_index\":-1,\"answer\":\"principles\",\"type\":\"fill_blank\",\"distractors\":[\"laws\",\"regulations\",\"policies\"]},{\"question\":\"The country has a _______ type of government.\",\"options\":[],\"answer_index\":-1,\"answer\":\"democratic republic\",\"type\":\"fill_blank\",\"distractors\":[\"monarchy\",\"oligarchy\",\"dictatorship\"]},{\"question\":\"The _______ Constitution was the first formal constitution in the Philippines.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Malolos\",\"type\":\"fill_blank\",\"distractors\":[\"Biak na Bato\",\"Jones\",\"Tydings-McDuffie\"]},{\"question\":\"The _______ Act served as the country\'s constitution until the Tydings-McDuffie Act was passed in 1934.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Jones\",\"type\":\"fill_blank\",\"distractors\":[\"Malolos\",\"Biak na Bato\",\"Philippine Organic\"]},{\"question\":\"The _______ Act outlined the transition of the Philippines to independence.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Tydings-McDuffie\",\"type\":\"fill_blank\",\"distractors\":[\"Jones\",\"Malolos\",\"Biak na Bato\"]},{\"question\":\"________ is a source of funds that allows the government to function well.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Taxation\",\"type\":\"fill_blank\",\"distractors\":[\"Donations\",\"Grants\",\"Loans\"]},{\"question\":\"The _______ Tariff Act resulted in the decline of government revenue.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Underwood-Simmons\",\"type\":\"fill_blank\",\"distractors\":[\"Jones\",\"Malolos\",\"Biak na Bato\"]},{\"question\":\"The _______ Law of 1904 introduced a new taxation system.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Internal Revenue\",\"type\":\"fill_blank\",\"distractors\":[\"Jones\",\"Malolos\",\"Biak na Bato\"]},{\"question\":\"The _______ regime rejected the advised of the United States in tax collection.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Roxas\",\"type\":\"fill_blank\",\"distractors\":[\"Quirino\",\"Magsaysay\",\"Marcos\"]},{\"question\":\"The _______ regime saw a rise in corruption.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Magsaysay, Garcia, and Macapagal\",\"type\":\"fill_blank\",\"distractors\":[\"Roxas\",\"Quirino\",\"Marcos\"]},{\"question\":\"The _______ regime reformed the tax system through the 1986 Tax Reform Program.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Aquino\",\"type\":\"fill_blank\",\"distractors\":[\"Roxas\",\"Quirino\",\"Marcos\"]},{\"question\":\"The _______ system was heavily dependent on indirect taxes during the Marcos regime.\",\"options\":[],\"answer_index\":-1,\"answer\":\"tax\",\"type\":\"fill_blank\",\"distractors\":[\"fiscal\",\"monetary\",\"economic\"]},{\"question\":\"The _______ Law was passed in 1907 to support the maintenance and construction of roads.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Cedula\",\"type\":\"fill_blank\",\"distractors\":[\"Jones\",\"Malolos\",\"Biak na Bato\"]},{\"question\":\"The _______ tax was introduced in 1919.\",\"options\":[],\"answer_index\":-1,\"answer\":\"inheritance\",\"type\":\"fill_blank\",\"distractors\":[\"income\",\"sales\",\"property\"]},{\"question\":\"The _______ tax was levied on the business community and became a highly complex system.\",\"options\":[],\"answer_index\":-1,\"answer\":\"industria\",\"type\":\"fill_blank\",\"distractors\":[\"urbana\",\"cedula\",\"excise\"]}]', '2026-07-09 21:19:28'),
(7, 'pool_6a4fa08e96e659.51644470', 21, 'qwe', 'uploads/1782295570_HIS101.FINALS.REVIEWER (1)-compressed.pdf', 'hard', 'multiple_choice', 5, 16, '[{\"question\":\"What type of government does the Philippines have?\",\"options\":[\"Monarchy\",\"Dictatorship\",\"Democratic Republic\",\"Theocracy\"],\"answer_index\":2,\"answer\":\"Democratic Republic\",\"type\":\"multiple_choice\"},{\"question\":\"Who wrote the 1897 Biak na Bato Republic constitution?\",\"options\":[\"Isabelo Artacho and Felix Ferrer\",\"Felipe Calderon\",\"Jose P. Laurel\",\"Claro Recto\"],\"answer_index\":0,\"answer\":\"Isabelo Artacho and Felix Ferrer\",\"type\":\"multiple_choice\"},{\"question\":\"What was the purpose of the tributo tax imposed by the Spanish colonizers?\",\"options\":[\"To generate resources to finance the maintenance of islands and salaries of government officials\",\"To impose a tax on annual rental\",\"To tax salaries, dividends, and profits\",\"To introduce a real estate tax\"],\"answer_index\":0,\"answer\":\"To generate resources to finance the maintenance of islands and salaries of government officials\",\"type\":\"multiple_choice\"},{\"question\":\"What law introduced various types of taxes, including license taxes and excise taxes?\",\"options\":[\"Internal Revenue Law of 1904\",\"Underwood-Simmons Tariff Act of 1913\",\"National Internal Revenue Code\",\"1986 Tax Reform Program\"],\"answer_index\":0,\"answer\":\"Internal Revenue Law of 1904\",\"type\":\"multiple_choice\"},{\"question\":\"What was the result of the Underwood-Simmons Tariff Act of 1913?\",\"options\":[\"An increase in government revenue\",\"A decline in government revenue\",\"The introduction of a new tax system\",\"The abolition of the cedula tax\"],\"answer_index\":1,\"answer\":\"A decline in government revenue\",\"type\":\"multiple_choice\"},{\"question\":\"Who urged an increase in tax receipts to compensate for the loss in revenue caused by the Underwood-Simmons Tariff Act?\",\"options\":[\"Francis Burton Harrison\",\"Felipe Calderon\",\"Jose P. Laurel\",\"Claro Recto\"],\"answer_index\":0,\"answer\":\"Francis Burton Harrison\",\"type\":\"multiple_choice\"},{\"question\":\"What type of tax was introduced in 1919?\",\"options\":[\"Income tax\",\"Inheritance tax\",\"Real estate tax\",\"_license tax\"],\"answer_index\":1,\"answer\":\"Inheritance tax\",\"type\":\"multiple_choice\"},{\"question\":\"What era saw the introduction of income tax and inheritance tax?\",\"options\":[\"Spanish era\",\"American era\",\"Commonwealth era\",\"Post-war era\"],\"answer_index\":2,\"answer\":\"Commonwealth era\",\"type\":\"multiple_choice\"},{\"question\":\"Who drafted the National Internal Revenue Code?\",\"options\":[\"The Commonwealth government\",\"The American government\",\"The Spanish government\",\"The Philippine government\"],\"answer_index\":0,\"answer\":\"The Commonwealth government\",\"type\":\"multiple_choice\"},{\"question\":\"What was the result of the 1986 Tax Reform Program?\",\"options\":[\"A decline in government revenue\",\"An increase in government revenue\",\"The introduction of a new tax system\",\"The abolition of the cedula tax\"],\"answer_index\":2,\"answer\":\"The introduction of a new tax system\",\"type\":\"multiple_choice\"},{\"question\":\"What was the purpose of the 1987 Constitution?\",\"options\":[\"To establish a democratic republic type of government\",\"To introduce a new tax system\",\"To abolish the cedula tax\",\"To establish a presidential system of government\"],\"answer_index\":0,\"answer\":\"To establish a democratic republic type of government\",\"type\":\"multiple_choice\"},{\"question\":\"What type of system was established by the 1987 Constitution?\",\"options\":[\"Presidential system\",\"Parliamentary system\",\"Monarchical system\",\"Dictatorial system\"],\"answer_index\":0,\"answer\":\"Presidential system\",\"type\":\"multiple_choice\"},{\"question\":\"What was the result of the Marcos authoritarian regime on the tax system?\",\"options\":[\"The tax system became more dependent on direct taxes\",\"The tax system became more dependent on indirect taxes\",\"The tax system was reformed to introduce a new tax system\",\"The tax system was abolished\"],\"answer_index\":1,\"answer\":\"The tax system became more dependent on indirect taxes\",\"type\":\"multiple_choice\"},{\"question\":\"Who reformed the tax system through the 1986 Tax Reform Program?\",\"options\":[\"Ferdinand Marcos\",\"Corazon Aquino\",\"Jose P. Laurel\",\"Claro Recto\"],\"answer_index\":1,\"answer\":\"Corazon Aquino\",\"type\":\"multiple_choice\"},{\"question\":\"What was the purpose of the tributo tax?\",\"options\":[\"To generate resources to finance the maintenance of islands and salaries of government officials\",\"To impose a tax on annual rental\",\"To tax salaries, dividends, and profits\",\"To introduce a real estate tax\"],\"answer_index\":0,\"answer\":\"To generate resources to finance the maintenance of islands and salaries of government officials\",\"type\":\"multiple_choice\"},{\"question\":\"What era saw the introduction of the real estate tax?\",\"options\":[\"Spanish era\",\"American era\",\"Commonwealth era\",\"Post-war era\"],\"answer_index\":1,\"answer\":\"American era\",\"type\":\"multiple_choice\"}]', '2026-07-09 21:22:22');
INSERT INTO `solo_quiz_pools` (`id`, `batch_id`, `user_id`, `quest_title`, `material_path`, `difficulty`, `quiz_type`, `requested_count`, `pool_count`, `pool_json`, `created_at`) VALUES
(8, 'pool_6a51e281a17340.32805155', 21, 'try', 'uploads/1782295058_Chapter-6-Lecture-Week-8-READ100-1-20231028171016.pdf', 'easy', 'multiple_choice', 10, 33, '[{\"type\":\"multiple_choice\",\"question\":\"What is a reading disorder?\",\"options\":[\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A core problem in the phonological processing system of oral language\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":0,\"answer\":\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\"},{\"type\":\"multiple_choice\",\"question\":\"What is dyslexia?\",\"options\":[\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A core problem in the phonological processing system of oral language\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":1,\"answer\":\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\"},{\"type\":\"multiple_choice\",\"question\":\"What is phonological deficit?\",\"options\":[\"A core problem in the phonological processing system of oral language\",\"Affecting speed and accuracy of printed word recognition\",\"Often coinciding with phonological deficit, but specifically found in children with social-linguistic disabilities\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":0,\"answer\":\"A core problem in the phonological processing system of oral language\"},{\"type\":\"multiple_choice\",\"question\":\"What is processing speed\\/orthographic processing deficit?\",\"options\":[\"A core problem in the phonological processing system of oral language\",\"Affecting speed and accuracy of printed word recognition\",\"Often coinciding with phonological deficit, but specifically found in children with social-linguistic disabilities\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":1,\"answer\":\"Affecting speed and accuracy of printed word recognition\"},{\"type\":\"multiple_choice\",\"question\":\"What is comprehension deficit?\",\"options\":[\"A core problem in the phonological processing system of oral language\",\"Affecting speed and accuracy of printed word recognition\",\"Often coinciding with phonological deficit, but specifically found in children with social-linguistic disabilities\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":2,\"answer\":\"Often coinciding with phonological deficit, but specifically found in children with social-linguistic disabilities\"},{\"type\":\"multiple_choice\",\"question\":\"What is Response to Intervention (RTI)?\",\"options\":[\"A federally mandated process that provides reading intervention to students who need additional support\",\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A core problem in the phonological processing system of oral language\"],\"answer_index\":0,\"answer\":\"A federally mandated process that provides reading intervention to students who need additional support\"},{\"type\":\"multiple_choice\",\"question\":\"What is Multi-Tiered System of Support (MTSS)?\",\"options\":[\"A federally mandated process that provides reading intervention to students who need additional support\",\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A process that provides reading intervention to students who need additional support\"],\"answer_index\":3,\"answer\":\"A process that provides reading intervention to students who need additional support\"},{\"type\":\"multiple_choice\",\"question\":\"What is differentiated instruction?\",\"options\":[\"An approach that adjusts curriculum and instruction to maximize the learning of all students\",\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":0,\"answer\":\"An approach that adjusts curriculum and instruction to maximize the learning of all students\"},{\"type\":\"multiple_choice\",\"question\":\"What is Fry\'s Instant Sight Words?\",\"options\":[\"A list of commonly used words in the English language\",\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":0,\"answer\":\"A list of commonly used words in the English language\"},{\"type\":\"multiple_choice\",\"question\":\"What is Reader\'s Theater?\",\"options\":[\"A strategy that provides students with an opportunity to practice their reading skills while performing\",\"A learning disorder that involves significant impairment of reading accuracy, speed, or comprehension\",\"A learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling\",\"A federally mandated process that provides reading intervention to students who need additional support\"],\"answer_index\":0,\"answer\":\"A strategy that provides students with an opportunity to practice their reading skills while performing\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of reviewing Fry\'s Instant Sight Words?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":0,\"answer\":\"To improve reading accuracy\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of repeated reading?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":1,\"answer\":\"To improve reading speed\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of systematic and sequential phonics and decoding?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":0,\"answer\":\"To improve reading accuracy\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of increased independent reading time?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":2,\"answer\":\"To improve reading comprehension\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of technology-assisted reading?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":1,\"answer\":\"To improve reading speed\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of Reader\'s Theater?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":2,\"answer\":\"To improve reading comprehension\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of differentiated instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the main goal of reading intervention?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the role of Response to Intervention (RTI) in reading instruction?\",\"options\":[\"To provide extra support to students who need it\",\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\"],\"answer_index\":0,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the role of Multi-Tiered System of Support (MTSS) in reading instruction?\",\"options\":[\"To provide extra support to students who need it\",\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\"],\"answer_index\":0,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of assessing readiness in differentiated instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of teaching to the student\'s zone of proximal development?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of employing effective classroom management procedures?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of grouping students for instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of technology-assisted reading programs?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":1,\"answer\":\"To improve reading speed\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of Reader\'s Theater in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":2,\"answer\":\"To improve reading comprehension\"},{\"type\":\"multiple_choice\",\"question\":\"What is the main goal of evidence-based reading interventions?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"},{\"type\":\"multiple_choice\",\"question\":\"What is the role of Fry\'s Instant Sight Words in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":0,\"answer\":\"To improve reading accuracy\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of repeated reading in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":1,\"answer\":\"To improve reading speed\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of systematic and sequential phonics and decoding in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":0,\"answer\":\"To improve reading accuracy\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of increased independent reading time in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":2,\"answer\":\"To improve reading comprehension\"},{\"type\":\"multiple_choice\",\"question\":\"What is the purpose of technology-assisted reading programs in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":1,\"answer\":\"To improve reading speed\"},{\"type\":\"multiple_choice\",\"question\":\"What is the main goal of differentiated instruction in reading instruction?\",\"options\":[\"To improve reading accuracy\",\"To improve reading speed\",\"To improve reading comprehension\",\"To provide extra support to students who need it\"],\"answer_index\":3,\"answer\":\"To provide extra support to students who need it\"}]', '2026-07-11 14:28:17'),
(9, 'pool_6a51e5a467b736.04007600', 21, 'try', 'uploads/1782295058_Chapter-6-Lecture-Week-8-READ100-1-20231028171016.pdf', 'easy', 'fill_blanks', 5, 16, '[{\"type\":\"fill_blank\",\"question\":\"Dyslexia is a learning difficulty that primarily affects ____ skills.\",\"options\":[],\"answer_index\":-1,\"answer\":\"word reading and spelling\",\"distractors\":[\"math\",\"science\",\"social studies\"]},{\"type\":\"fill_blank\",\"question\":\"Reading disorder is a learning disorder that involves significant impairment of ____ accuracy, speed, or comprehension.\",\"options\":[],\"answer_index\":-1,\"answer\":\"reading\",\"distractors\":[\"writing\",\"speaking\",\"listening\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a core problem in the phonological processing system of oral language.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Phonological deficit\",\"distractors\":[\"Processing speed deficit\",\"Comprehension deficit\",\"Orthographic processing deficit\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a federally mandated process that provides reading intervention to students who need additional support.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Response to Intervention (RTI)\",\"distractors\":[\"Multi-Tiered System of Support (MTSS)\",\"Differentiated Instruction\",\"Evidence-Based Reading Interventions\"]},{\"type\":\"fill_blank\",\"question\":\"____ is an approach that adjusts curriculum and instruction to maximize learning for all students.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Differentiated Instruction\",\"distractors\":[\"Response to Intervention (RTI)\",\"Multi-Tiered System of Support (MTSS)\",\"Evidence-Based Reading Interventions\"]},{\"type\":\"fill_blank\",\"question\":\"Reviewing ____ is an evidence-based reading intervention that can help improve reading skills.\",\"options\":[],\"answer_index\":-1,\"answer\":\"sight words\",\"distractors\":[\"phonics\",\"decoding\",\"vocabulary\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a type of reading disability that affects speed and accuracy of printed word recognition.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Processing speed\\/orthographic processing deficit\",\"distractors\":[\"Phonological deficit\",\"Comprehension deficit\",\"Dyslexia\"]},{\"type\":\"fill_blank\",\"question\":\"____ is an evidence-based reading intervention that involves having students read a passage repeatedly to improve fluency.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Repeated reading\",\"distractors\":[\"Systematic and sequential phonics and decoding\",\"Increased independent reading time\",\"Technology-assisted reading\"]},{\"type\":\"fill_blank\",\"question\":\"____ is an evidence-based reading intervention that involves using technology to provide reading support.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Technology-assisted reading\",\"distractors\":[\"Repeated reading\",\"Systematic and sequential phonics and decoding\",\"Increased independent reading time\"]},{\"type\":\"fill_blank\",\"question\":\"____ is an evidence-based reading intervention that involves having students perform a reading passage to improve fluency and expression.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Reader\'s theater\",\"distractors\":[\"Repeated reading\",\"Systematic and sequential phonics and decoding\",\"Increased independent reading time\"]},{\"type\":\"fill_blank\",\"question\":\"Assessing ____ is an important aspect of differentiated instruction.\",\"options\":[],\"answer_index\":-1,\"answer\":\"readiness\",\"distractors\":[\"intelligence\",\"motivation\",\"learning style\"]},{\"type\":\"fill_blank\",\"question\":\"Teaching to the student\'s ____ of proximal development is an important aspect of differentiated instruction.\",\"options\":[],\"answer_index\":-1,\"answer\":\"zone\",\"distractors\":[\"level\",\"stage\",\"phase\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a type of reading disability that affects understanding what is being read.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Comprehension deficit\",\"distractors\":[\"Phonological deficit\",\"Processing speed\\/orthographic processing deficit\",\"Dyslexia\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a learning difficulty that primarily affects the skills involved in accurate and fluent word reading and spelling.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Dyslexia\",\"distractors\":[\"Reading disorder\",\"Phonological deficit\",\"Comprehension deficit\"]},{\"type\":\"fill_blank\",\"question\":\"____ is an approach that provides extra support and instruction for students who are struggling to learn to read.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Reading intervention\",\"distractors\":[\"Differentiated instruction\",\"Response to Intervention (RTI)\",\"Multi-Tiered System of Support (MTSS)\"]},{\"type\":\"fill_blank\",\"question\":\"____ is a process that provides reading intervention to students who need additional support to become proficient readers.\",\"options\":[],\"answer_index\":-1,\"answer\":\"Multi-Tiered System of Support (MTSS)\",\"distractors\":[\"Response to Intervention (RTI)\",\"Differentiated Instruction\",\"Evidence-Based Reading Interventions\"]}]', '2026-07-11 14:41:40');

-- --------------------------------------------------------

--
-- Table structure for table `solo_quiz_results`
--

CREATE TABLE `solo_quiz_results` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `student_name` varchar(150) DEFAULT NULL,
  `quiz_title` varchar(255) DEFAULT NULL,
  `score` int(11) DEFAULT 0,
  `correct_answers` int(11) DEFAULT 0,
  `total_questions` int(11) DEFAULT 0,
  `xp_earned` int(11) DEFAULT 0,
  `completed_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `solo_quiz_results`
--

INSERT INTO `solo_quiz_results` (`id`, `user_id`, `student_name`, `quiz_title`, `score`, `correct_answers`, `total_questions`, `xp_earned`, `completed_at`) VALUES
(92, 21, 'Marco', 'we', 685, 1, 10, 70, '2026-07-12 12:58:10'),
(93, 21, 'Marco', 'we', 0, 0, 1, 50, '2026-07-12 13:00:27'),
(94, 21, 'Marco', 'we', 800, 1, 5, 70, '2026-07-12 13:02:11'),
(95, 21, 'Marco', 'qwe', 2400, 3, 5, 110, '2026-07-12 13:04:00');

-- --------------------------------------------------------

--
-- Table structure for table `synchro_answers`
--

CREATE TABLE `synchro_answers` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `participant_nickname` varchar(50) NOT NULL,
  `answer_given` varchar(500) NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `time_taken_ms` int(11) NOT NULL DEFAULT 0 COMMENT 'Milliseconds taken to answer',
  `points_earned` int(11) NOT NULL DEFAULT 0,
  `answered_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `synchro_answers`
--

INSERT INTO `synchro_answers` (`id`, `session_id`, `question_id`, `participant_nickname`, `answer_given`, `is_correct`, `time_taken_ms`, `points_earned`, `answered_at`) VALUES
(74, 57, 236, 'Makoi', 'A', 0, 1617, 0, '2026-07-12 12:59:50');

-- --------------------------------------------------------

--
-- Table structure for table `synchro_game_state`
--

CREATE TABLE `synchro_game_state` (
  `session_id` int(11) NOT NULL,
  `current_question` int(11) NOT NULL DEFAULT 0 COMMENT 'Index of current question (0 = lobby/not started)',
  `question_started_at` datetime DEFAULT NULL COMMENT 'Timestamp when current question was shown',
  `phase` enum('lobby','question','results','leaderboard','finished') NOT NULL DEFAULT 'lobby'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `synchro_game_state`
--

INSERT INTO `synchro_game_state` (`session_id`, `current_question`, `question_started_at`, `phase`) VALUES
(57, 10, '2026-07-12 07:00:22', 'finished');

-- --------------------------------------------------------

--
-- Table structure for table `synchro_participants`
--

CREATE TABLE `synchro_participants` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `avatar_key` varchar(50) DEFAULT NULL,
  `joined_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `synchro_participants`
--

INSERT INTO `synchro_participants` (`id`, `session_id`, `nickname`, `avatar_key`, `joined_at`) VALUES
(86, 57, 'Makoi', 'gorilla_vr', '2026-07-12 12:59:38');

-- --------------------------------------------------------

--
-- Table structure for table `synchro_questions`
--

CREATE TABLE `synchro_questions` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `question_order` int(11) NOT NULL DEFAULT 0,
  `question_text` text NOT NULL,
  `option_a` varchar(500) DEFAULT NULL,
  `option_b` varchar(500) DEFAULT NULL,
  `option_c` varchar(500) DEFAULT NULL,
  `option_d` varchar(500) DEFAULT NULL,
  `correct_answer` varchar(10) NOT NULL COMMENT 'A, B, C, D or the actual answer text for identification',
  `question_type` enum('multiple_choice','identification') NOT NULL DEFAULT 'multiple_choice',
  `time_limit` int(11) NOT NULL DEFAULT 20
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `synchro_scores`
--

CREATE TABLE `synchro_scores` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `avatar_key` varchar(50) DEFAULT NULL,
  `total_score` int(11) NOT NULL DEFAULT 0,
  `correct_answers` int(11) NOT NULL DEFAULT 0,
  `streak` int(11) NOT NULL DEFAULT 0,
  `powerups_used` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `synchro_scores`
--

INSERT INTO `synchro_scores` (`id`, `session_id`, `nickname`, `avatar_key`, `total_score`, `correct_answers`, `streak`, `powerups_used`) VALUES
(241, 57, 'Makoi', 'gorilla_vr', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `synchro_sessions`
--

CREATE TABLE `synchro_sessions` (
  `id` int(11) NOT NULL,
  `room_code` varchar(10) NOT NULL,
  `title` varchar(255) NOT NULL,
  `material_id` int(11) NOT NULL,
  `difficulty` varchar(20) NOT NULL,
  `quiz_type` varchar(50) NOT NULL,
  `item_count` int(11) NOT NULL,
  `timer_mins` int(11) DEFAULT 0,
  `status` enum('waiting','started','question','results','leaderboard','finished') DEFAULT 'waiting',
  `created_at` datetime DEFAULT current_timestamp(),
  `questions_json` longtext DEFAULT NULL COMMENT 'JSON array of questions from AI engine'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `synchro_sessions`
--

INSERT INTO `synchro_sessions` (`id`, `room_code`, `title`, `material_id`, `difficulty`, `quiz_type`, `item_count`, `timer_mins`, `status`, `created_at`, `questions_json`) VALUES
(57, 'PQ-421158', 'we', 6, 'easy', 'multiple_choice', 10, 0, 'finished', '2026-07-12 12:58:48', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_materials`
--

CREATE TABLE `teacher_materials` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `date_uploaded` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_materials`
--

INSERT INTO `teacher_materials` (`id`, `title`, `file_path`, `date_uploaded`) VALUES
(6, 'demo', 'uploads/teacher_vault/1775045562_CSP109_Week 9-10-System Modeling (20260303072549).pdf', '2026-04-01 12:12:42');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','teacher') NOT NULL,
  `display_name` varchar(50) DEFAULT NULL,
  `avatar_key` varchar(50) DEFAULT 'default',
  `xp` int(10) UNSIGNED DEFAULT 0,
  `level` int(10) UNSIGNED DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `role`, `display_name`, `avatar_key`, `xp`, `level`) VALUES
(12, '', 'marcotaopoespedido@gmail.com', '$2y$10$EkXpJcoZeWrqu.prnmwC/Oy.gj6q9TjN458dyuDUm9rqk1X3yjxRa', 'student', 'Pedro', 'robot', 2890, 1),
(13, '', 'makoidemo@gmail.com', '$2y$10$sSHK56O/f3fJ1vKmEIFD9e6VxSodpktxb.BMDiybwNv7XrOp2ig0.', 'teacher', NULL, 'default', 0, 1),
(14, '', 'melai@gmail.com', '$2y$10$HOcOoMUaOQB8a2E6tTGy5OVSgW8DQg/Cc7bNW/0i7f29RhIGFwKVG', 'student', 'Melissa', 'crown', 185, 1),
(15, '', 'mac@gmail.com', '$2y$10$LjLgAgNIE6AGdAEjuy8C9eoopXJ9c0vguUiGGR39DEVEBtYMTnBSG', 'student', 'Marco', 'crown', 0, 1),
(16, '', 'gave@gmail.com', '$2y$10$i5Kc2sWI1PC7K3x/Wp5n2etru.fmJYfjIFR4qu6CkAzlnKSZYTA92', 'teacher', NULL, 'default', 330, 1),
(17, '', 'macdemo@gmail.com', '$2y$10$RTcRBAkxWUZSsoF28Npb1u/o2uSg13mOkDsCnU94axyqFb.NHbH3i', 'student', NULL, 'default', 0, 1),
(18, '', 'jdc@gmail.com', '$2y$10$.J4l9P0.req7RsXZIF8moeBmLcO/EKIt5C5p3weVokZe9WE7NcJU6', 'teacher', 'Juan', 'dragon', 400, 1),
(20, '', 'marcotaopoespedido01@gmail.com', '$2y$10$SbHEmlJJ6LLaJxg1/h1mWuRA5j2yl3feaBVMatNEJEmExdXtMUzJW', 'teacher', 'Pedro', 'default', 200, 1),
(21, '', 'makoi@demo.com', '$2y$10$JNN0Gec3Y3lHeuyUkmCyuuF.xbxBd3bU0el0BljhI0CAjki/WGdNO', 'student', 'Marco', 'fire', 7130, 1),
(22, '', 'tata@f.com', '$2y$10$/Zr0IBJqaQfcFITFtqcM2OvbCxQgx.JkCYkABouactp2Uv3PE0mI2', 'student', NULL, 'default', 50, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_achievements`
--

CREATE TABLE `user_achievements` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `achievement_key` varchar(50) NOT NULL,
  `unlocked_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_achievements`
--

INSERT INTO `user_achievements` (`id`, `user_id`, `achievement_key`, `unlocked_at`) VALUES
(469, 21, 'first_quest', '2026-07-12 12:58:10'),
(470, 21, 'xp_warrior', '2026-07-12 12:58:10'),
(471, 21, 'legend', '2026-07-12 12:58:10');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `solo_quiz_answers`
--
ALTER TABLE `solo_quiz_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_result_id` (`result_id`);

--
-- Indexes for table `solo_quiz_pools`
--
ALTER TABLE `solo_quiz_pools`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `batch_id` (`batch_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `solo_quiz_results`
--
ALTER TABLE `solo_quiz_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `synchro_answers`
--
ALTER TABLE `synchro_answers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_answer` (`session_id`,`question_id`,`participant_nickname`);

--
-- Indexes for table `synchro_game_state`
--
ALTER TABLE `synchro_game_state`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `synchro_participants`
--
ALTER TABLE `synchro_participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id` (`session_id`);

--
-- Indexes for table `synchro_questions`
--
ALTER TABLE `synchro_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id` (`session_id`);

--
-- Indexes for table `synchro_scores`
--
ALTER TABLE `synchro_scores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_player` (`session_id`,`nickname`);

--
-- Indexes for table `synchro_sessions`
--
ALTER TABLE `synchro_sessions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teacher_materials`
--
ALTER TABLE `teacher_materials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_achievements`
--
ALTER TABLE `user_achievements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_achievement` (`user_id`,`achievement_key`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `solo_quiz_answers`
--
ALTER TABLE `solo_quiz_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `solo_quiz_pools`
--
ALTER TABLE `solo_quiz_pools`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `solo_quiz_results`
--
ALTER TABLE `solo_quiz_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT for table `synchro_answers`
--
ALTER TABLE `synchro_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `synchro_participants`
--
ALTER TABLE `synchro_participants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `synchro_questions`
--
ALTER TABLE `synchro_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT for table `synchro_scores`
--
ALTER TABLE `synchro_scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=253;

--
-- AUTO_INCREMENT for table `synchro_sessions`
--
ALTER TABLE `synchro_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `teacher_materials`
--
ALTER TABLE `teacher_materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `user_achievements`
--
ALTER TABLE `user_achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=481;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `solo_quiz_answers`
--
ALTER TABLE `solo_quiz_answers`
  ADD CONSTRAINT `fk_solo_quiz_answers_result` FOREIGN KEY (`result_id`) REFERENCES `solo_quiz_results` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `synchro_participants`
--
ALTER TABLE `synchro_participants`
  ADD CONSTRAINT `synchro_participants_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `synchro_sessions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
