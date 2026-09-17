SELECT * FROM world_layoffs.layoffs;
create table layoffs_staging like layoffs;
insert into layoffs_staging select * from layoffs;