/*

https://datasets.imdbws.com/

https://www.imdb.com/interfaces/

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

CREATE TABLE public.basics_load
(
    nconst character varying(255) COLLATE pg_catalog."default",
    primaryname character varying(255) COLLATE pg_catalog."default",
    birthyear character varying(255) COLLATE pg_catalog."default",
    deathyear character varying(255) COLLATE pg_catalog."default",
    primaryprofession character varying(255) COLLATE pg_catalog."default",
    knownfortitles character varying(255) COLLATE pg_catalog."default"
)

CREATE TABLE Persons (
	nid char(10),
	primaryName varchar(250),
	birthYear int,
    deathYear int,
    primaryProfession varchar(66),
    knownForTitles varchar(69));

COPY basics_load FROM 'C:\Users\krismorte\Downloads\data.tsv' DELIMITER E'\t' ;

insert into Persons
select nconst,primaryName,cast (birthYear as integer),cast (deathYear as integer),primaryProfession,knownForTitles from basics_load
where nconst<>'nconst'

create table title_load
(
    tconst varchar(255),
    titleType  varchar(255),
    primaryTitle  varchar(500),
    originalTitle  varchar(500),
    isAdult  varchar(255),
    startYear  varchar(255),
    endYear  varchar(255),
    runtimeMinutes  varchar(255),
    genres  varchar(500)
)

CREATE TABLE Titles (
	tid char(9),
	ttype varchar(12),
	primaryTitle varchar(408),
	originalTitle varchar(408),
	isAdult int,
	startYear int,
	endYear int,
	runtimeMinutes int,
	genres varchar(200));

COPY title_load FROM 'C:\Users\krismorte\Downloads\data.tsv' DELIMITER E'\t' ;
insert into Titles
select tconst,titleType,primaryTitle,originalTitle,cast (isAdult as integer),cast (startYear as integer),cast (endYear as integer),
    cast (runtimeMinutes as integer),genres 
    from title_load
where tconst<>'tconst'

create table principal_load (
tconst varchar(255),
ordering varchar(255),
nconst varchar(255),
category varchar(255),
job varchar(500),
characters varchar(800)
)

CREATE TABLE Principals (
	tid char(9),
	ordering int,
	nid char(10),
	category varchar(19),
	job varchar(286),
	characters varchar(463));

COPY principal_load FROM 'C:\Users\krismorte\Downloads\data.tsv' DELIMITER E'\t' ;

CREATE TABLE Ratings (
        tid char(9),
        avg_rating numeric,
        num_votes numeric);

COPY ratings_load FROM 'C:\Users\krismorte\Downloads\data.tsv' CSV HEADER DELIMITER E'\t' ;

create table movie 
(tid char(9),
title varchar(408),
year int,
lenght int,
rating numeric)


insert into movie
select t.tid,t.primarytitle,t.startyear,t.runtimeminutes,r.avg_rating from titles t
inner join Ratings r on t.tid = r.tid
where t.ttype='movie'
order by r.avg_rating desc
limit 5000

create table director
(nid char(10),
name varchar(250),
birthYear int,
deathYear int)

insert into director
select pe.nid,pe.primaryname,pe.birthyear,pe.deathyear from persons pe
inner join principals pr on pe.nid = pr.nid
where pr.category='director'
and pr.tid in (select tid from movie)

create table directs
(tid char(9),
id char(10))

insert into directs
select tid,nid from principals 
where category='director'
and tid in (select tid from movie)		

create table startin
(tid char(9),
id char(10))
		
insert into startin
select tid,nid from principals 
where category='actor'
and tid in (select tid from movie)