/*
Name - Jeet Soni
Description - A database that keeps record of the movies and information related to it.
Database - postgreSQL 15.3
*/

-- movies table 
CREATE TABLE IF NOT EXISTS movie(
    movie_id SERIAL NOT NULL,
    title varchar(100) NOT NULL,
    description varchar(1000) NOT NULL,
    movie_year DATE NOT NULL,
    rating DECIMAL,
    runtime decimal NOT NULL,
    votes INT NOT NULL,
    revenue decimal NOT NULL,
    metascore int NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(movie_id)

);

-- genre table
CREATE TABLE IF NOT EXISTS genre(
    genre_id SERIAL NOT NULL,
    name varchar(75) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(genre_id)

);

-- actor table 
CREATE TABLE IF NOT EXISTS actor(
    actor_id SERIAL NOT NULL ,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    gender varchar(25) NOT NULL,
    age INT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    primary key(actor_id)
);

-- director table
CREATE TABLE IF NOT EXISTS director(
    director_id SERIAL NOT NULL ,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(director_id)
);

-- 1 movie_id N movie_id(movie_genre)
-- 1 genre_id N genre_id(movie_genre)
CREATE TABLE IF NOT EXISTS movie_genre(
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(movie_id, genre_id),
    CONSTRAINT fk_movie
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    CONSTRAINT fk_genre
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

-- 1 movie_id N movie_id(movie_actor)
-- 1 actor_id N actor_id(movie_actor)
CREATE TABLE IF NOT EXISTS movie_actor(
    movie_id INT NOT NULL,
    actor_id INT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(movie_id, actor_id),
    CONSTRAINT fk_movie
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    CONSTRAINT fk_actor
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);

-- 1 movie_id N movie_id(movie_director)
-- 1 actor_id N director_id(movie_director)
CREATE TABLE IF NOT EXISTS movie_director(
    movie_id INT NOT NULL,
    director_id INT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    primary key(movie_id, director_id),
    CONSTRAINT fk_movie
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    CONSTRAINT fk_director
    FOREIGN KEY (director_id) REFERENCES director(director_id)
);


--movie review table
CREATE TABLE IF NOT EXISTS movie_review(
    review_id SERIAL NOT NULL,
    movie_id INT NOT NULL,
    review INT NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_movie
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
);
-- trigger function add_movie_review
-- trigger function that inserts review to movie review table
CREATE OR REPLACE FUNCTION movies.add_movie_review()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

	INSERT INTO movies.movie_review(movie_id, review) VALUES(NEW.movie_id, floor(random() * 5 + 1)::int);
	INSERT INTO movies.movie_review(movie_id, review) VALUES(NEW.movie_id, floor(random() * 5 + 1)::int);
	INSERT INTO movies.movie_review(movie_id, review) VALUES(NEW.movie_id, floor(random() * 5 + 1)::int);
	INSERT INTO movies.movie_review(movie_id, review) VALUES(NEW.movie_id, floor(random() * 5 + 1)::int);
	INSERT INTO movies.movie_review(movie_id, review) VALUES(NEW.movie_id, floor(random() * 5 + 1)::int);
	RETURN NEW;

END;
$BODY$;

-- Trigger: add_review
-- Creates trigger on movie table and runs the function
CREATE TRIGGER add_review
    AFTER INSERT
    ON movies.movie
    FOR EACH ROW
    EXECUTE FUNCTION movies.add_movie_review();



