Create Database Movie_Streamer;
Use Movie_streamer;



CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_date DATE NOT NULL,
    duration INT NOT NULL,  --  minutes
    video_url VARCHAR(255) NOT NULL,
    avg_rating DECIMAL(3,2) DEFAULT 0.00
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE movie_genre (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

CREATE TABLE playback_history (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    last_watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_watch_duration INT DEFAULT 0,  -- minutes
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

CREATE TABLE watch_later (
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);


-- DUMMY DATA:

INSERT INTO users (name, email, password) VALUES
('John Doe', 'john.doe@example.com', 'hashed_password_1'),
('Jane Smith', 'jane.smith@example.com', 'hashed_password_2'),
('Michael Brown', 'michael.brown@example.com', 'hashed_password_3'),
('Emily Davis', 'emily.davis@example.com', 'hashed_password_4'),
('Chris Johnson', 'chris.johnson@example.com', 'hashed_password_5'),
('Sophia Wilson', 'sophia.wilson@example.com', 'hashed_password_6');


INSERT INTO subscriptions (user_id, start_date, end_date) VALUES
(1, '2024-01-01', '2026-12-31'),
(2, '2024-02-15', '2024-08-15'),
(3, '2024-03-10', '2025-09-10'),
(4, '2024-04-05', '2025-10-05'),
(5, '2024-05-20', '2024-11-20');



INSERT INTO movies (title, description, release_date, duration, video_url, avg_rating) VALUES
('Inception', 'A mind-bending thriller about dream invasion.', '2010-07-16', 148, 'http://example.com/inception', 4.8),
('The Matrix', 'A hacker discovers the nature of reality.', '1999-03-31', 136, 'http://example.com/matrix', 4.7),
('Interstellar', 'A sci-fi journey beyond the stars.', '2014-11-07', 169, 'http://example.com/interstellar', 4.9),
('The Dark Knight', 'Batman faces off against the Joker.', '2008-07-18', 152, 'http://example.com/dark_knight', 4.9),
('Forrest Gump', 'A simple man changes the world.', '1994-07-06', 142, 'http://example.com/forrest_gump', 4.6);


INSERT INTO genres (genre_name) VALUES
('Action'), ('Sci-Fi'), ('Drama'), ('Thriller'), ('Comedy');


INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 4), (1, 2), -- Inception (Thriller, Sci-Fi)
(2, 2), (2, 1), -- The Matrix (Sci-Fi, Action)
(3, 2), (3, 3), -- Interstellar (Sci-Fi, Drama)
(4, 1), (4, 4), -- The Dark Knight (Action, Thriller)
(5, 3), (5, 5); -- Forrest Gump (Drama, Comedy)


INSERT INTO reviews (user_id, movie_id, rating, review_text) VALUES
(1, 1, 5, 'Amazing movie with mind-blowing twists!'),
(2, 2, 4, 'A classic sci-fi masterpiece.'),
(3, 3, 5, 'Visually stunning and emotionally moving.'),
(4, 4, 5, 'One of the best superhero movies ever made.'),
(5, 5, 4, 'Heartwarming and inspiring story.');


INSERT INTO playback_history (user_id, movie_id, last_watched_at, last_watch_duration) VALUES
(1, 1, '2024-02-10 14:30:00', 90),
(2, 2, '2024-02-11 18:45:00', 60),
(3, 3, '2024-02-12 20:00:00', 120),
(4, 4, '2024-02-13 22:10:00', 80),
(5, 5, '2024-02-14 19:20:00', 100);


INSERT INTO watch_later (user_id, movie_id, added_at) VALUES
(1, 2, '2024-02-01 12:00:00'),
(2, 3, '2024-02-02 13:15:00'),
(3, 4, '2024-02-03 14:30:00'),
(4, 5, '2024-02-04 15:45:00'),
(5, 1, '2024-02-05 16:00:00');



-- QUERIES:

SELECT user_id, name, email FROM users;

SELECT user_id, name, email FROM users WHERE user_id = 1;


-- Retrieve all movies a specific user has saved to watch later.
SELECT wl.user_id, u.name, m.movie_id, m.title, wl.added_at
FROM watch_later wl
JOIN users u ON wl.user_id = u.user_id
JOIN movies m ON wl.movie_id = m.movie_id
WHERE wl.user_id = 1;


-- Retrieve all movies a specific user has watched and their last progress.
SELECT ph.user_id, u.name, m.movie_id, m.title, ph.last_watched_at, ph.last_watch_duration
FROM playback_history ph
JOIN users u ON ph.user_id = u.user_id
JOIN movies m ON ph.movie_id = m.movie_id
WHERE ph.user_id = 1;

-- Retrieve a specific user’s active subscription
SELECT s.subscription_id, u.name, s.start_date, s.end_date
FROM subscriptions s
JOIN users u ON s.user_id = u.user_id
WHERE s.user_id = 1;

-- Retrieve all active subscriptions (not expired).
SELECT s.subscription_id, u.name, s.start_date, s.end_date
FROM subscriptions s
JOIN users u ON s.user_id = u.user_id
WHERE s.end_date >= CURDATE();


-- Retrieve all reviews written by a specific user.
SELECT r.user_id, u.name, m.title, r.rating, r.review_text
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.user_id = 1;

-- Retrieve all reviews for a specific movie.
SELECT r.movie_id, m.title, u.name, r.rating, r.review_text
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE r.movie_id = 2;


 -- Different Genres of a Particular Movie
 SELECT m.movie_id, m.title, g.genre_name
FROM movie_genre mg
JOIN movies m ON mg.movie_id = m.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE m.movie_id = 1;

-- Different Movies That Belong to a Particular Genre
SELECT g.genre_id, g.genre_name, m.movie_id, m.title
FROM movie_genre mg
JOIN genres g ON mg.genre_id = g.genre_id
JOIN movies m ON mg.movie_id = m.movie_id
WHERE g.genre_id = 3; -- genre_id

















