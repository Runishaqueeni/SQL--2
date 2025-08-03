CREATE DATABASE movies;
USE movies;

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50));

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    rating INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

INSERT INTO movies VALUES
(1, 'Inception', 'Sci-Fi'),
(2, 'Titanic', 'Romance'),
(3, 'The Matrix', 'Sci-Fi'),
(4, 'The Notebook', 'Romance'),
(5,'Interstellar','Sci-Fi');

INSERT INTO users VALUES
(101, 'Alice'),
(102, 'Bob');

INSERT INTO ratings VALUES
(101, 1, 5),
(101, 3, 4), 
(102, 2, 5), 
(102, 4, 4);

select * from movies;
select * from users;
select * from ratings;

select m.title,r.rating # show movie rates by a user 101.
from ratings r
join movies m on r.movie_id=m.movie_id
where r.user_id=101;

select m.title,avg(r.rating) as average_rating  #show average rating for each movie.
from ratings r 
join movies m on r.movie_id=m.movie_id
group by m.title;

select m.title,avg(r.rating) as avg_rating  #show top rated movies(avg>=4).
from ratings r
join movies m on r.movie_id=m.movie_id
group by m.title
having avg(r.rating)>=4;

select u.name,r.rating  #find users who rated a specific movie.
from ratings r
join users u on r.user_id=u.user_id
where r.movie_id=1;

SELECT DISTINCT m.title  #recommend movies for alice(user_id=101).
FROM movies m
WHERE m.genre IN (
    SELECT genre
    FROM movies
    WHERE movie_id IN (
        SELECT movie_id
        FROM ratings
        WHERE user_id = 101 AND rating >= 4
    )
)
AND m.movie_id NOT IN (
    SELECT movie_id FROM ratings WHERE user_id = 101
);