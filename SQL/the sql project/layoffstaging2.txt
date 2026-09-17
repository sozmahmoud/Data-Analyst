SELECT * FROM world_layoffs.layoffs_staging2;

SELECT * FROM world_layoffs.layoffs_staging2
where row_num>1;

delete from layoffs_staging2 where row_num>1;


select company,trim(company)from layoffs_staging2;

update layoffs_staging2 set company = trim(company);

select distinct industry from layoffs_staging2 order by 1;

select * from layoffs_staging2 where industry like "crypto%";
select * from layoffs_staging2 where industry like "crypto %";

update layoffs_staging2 set industry =  "crypto"
where industry like "crypto %";

select * from layoffs_staging2 where industry like "CryptoCurrency";

update layoffs_staging2 set industry =  "crypto"
where industry like "CryptoCurrency";

select distinct industry from layoffs_staging2 order by 1;

select distinct country from layoffs_staging2 where country like 'United States%';

select distinct country,trim(country) from layoffs_staging2;
 
update layoffs_staging2
set country =trim(trailing '.' from country)
where country like 'United States%';

select `date` from layoffs_staging2;

select `date`, str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2 set date=str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2 modify column `date` date;

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select distinct industry from layoffs_staging2
where industry is null 
or industry ='';



update layoffs_staging2
set industry=null where industry='';

select* from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company
where (t1.industry is null) and
t2.industry is not null;

update layoffs_staging2 t1 
join layoffs_staging2 t2
on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null) and
t2.industry is not null;

delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
 
select * from layoffs_staging2 ;

select year(`date`),sum(total_laid_off) from layoffs_staging2
group by Year(`date`) order by 1 desc;

select stage,sum(total_laid_off) from layoffs_staging2
group by stage order by 1 desc;

select substring(`date`,1,7) as `month`,
sum(total_laid_off) from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc;

WITH Rolling_total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS `month`,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging2 
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `month` 
    ORDER BY 1 ASC
)
SELECT 
    `month`,
    SUM(total_off) OVER (ORDER BY `month`) AS rolling_total
FROM Rolling_total;

WITH company_year(company, year, total_laid_off) AS (
    SELECT 
        company,
        YEAR(`date`),
        SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
)
SELECT *,
       DENSE_RANK() OVER (
           PARTITION BY year 
           ORDER BY total_laid_off DESC
       ) AS ranking
FROM company_year
WHERE year IS NOT NULL
ORDER BY ranking ASC;

WITH company_year(company, year, total_laid_off) AS (
    SELECT 
        company,
        YEAR(`date`),
        SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), company_year_rank as
(SELECT *,
       DENSE_RANK() OVER (
           PARTITION BY year 
           ORDER BY total_laid_off DESC
       ) AS ranking
FROM company_year
WHERE year IS NOT NULL
)
select * from company_year_rank
where ranking<=5;








