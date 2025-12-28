/*
 * github의 gapminder.tsv 파일 다운로드, 테이블에 데이터 임포트.
 * TSV(tab-separated values): 값들이 탭으로 구분된 텍스트 파일. csv 파일의 일종.
 * 테이블 이름: gapminder
 * 컬럼 이름: country, continent, year, life_exp(기대수명), pop(인구수), gdp_percap(1인당GDP)
 *
 * 1. 테이블에는 모두 몇 개의 나라가 있을까요?
 * 2. 테이블에는 모두 몇 개의 대륙이 있을까요?
 * 3. 테이블에는 저장된 데이터는 몇년도부터 몇년도까지 조사한 내용일까요?
 * 4. 기대 수명이 최댓값인 레코드(row)를 찾으세요.
 * 5. 인구가 최댓값인 레코드(row)를 찾으세요.
 * 6. 1인당 GDP가 최댓값인 레코드(row)를 찾으세요.
 * 7. 우리나라의 통계 자료만 출력하세요.
 * 8. 연도별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 9. 대륙별 1인당 GDP의 최댓값인 레코드를 찾으세요.
 * 10. 연도별, 대륙별, 인구수를 출력하세요.
 *     인구수가 가장 많은 연도와 대륙은 어디인가요?
 * 11. 연도별, 대륙별 기대 수명의 평균을 출력하세요.
 *     기대 수명이 가장 긴 연도와 대륙은 어디인가요?
 * 12. 연도별, 대륙별 1인당 GDP의 평균을 출력하세요.
 *     1인당 GDP의 평균이 가장 큰 연도와 대륙은 어디인가요?
 * 13. 10번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 14. 11번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
 * 15. 12번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
*/

create table gapminder (
    country         varchar2(30),
    continent       varchar2(10),
    year            number(4),
    life_exp        number(6, 3), -- number 라고만 적어도 오라클이 제공하는 최대 범위의 범위를 할당해줌.
    pop             number(10),
    gdp_percap      number(15, 8)
);

-- 데이터 탐색
-- 테이블 전체 행 개수
select count(*) from gapminder;

-- 각 컬럼에 null이 아닌 데이터들의 개수
select
    count(country), count(continent), count(year),
    count(life_exp), count(pop), count(gdp_percap)
from gapminder;
--> 결과: null이 있는 컬럼은 없음.

-- 연속형 변수 vs 범주(카테고리)형 변수
-- 연속형 변수 -> 통계량(평균, 표준편차, 최댓값, 최솟값, 중위값, ...)
-- 범주형 변수 -> 개수(빈도수)

select * from gapminder
order by country, year;

-- 국가 이름 개수
select distinct country from gapminder order by country;

select count(distinct country) from gapminder;

-- 연도 개수
select distinct year from gapminder order by year;

select count(distinct year) from gapminder;

select 142 * 12 from dual;

-- 대륙 개수
select distinct continent from gapminder;


-- 기대수명의 기술 통계량
select
    round(avg(life_exp), 2) as 평균,
    round(variance(life_exp), 2) as 분산,
    round(stddev(life_exp), 2) as 표준편차,
    min(life_exp) 최솟값,
    max(life_exp) 최댓값,
    median(life_exp) 중위값
from gapminder;

-- 인구 기술 통계량
select
    round(avg(pop), 2) as 평균,
    round(variance(pop), 2) as 분산,
    round(stddev(pop), 2) as 표준편차,
    min(pop) 최솟값,
    max(pop) 최댓값,
    median(pop) 중위값
from gapminder;

-- 1인당 GDP 기술 통계량
select
    round(avg(gdp_percap), 2) as 평균,
    round(variance(gdp_percap), 2) as 분산,
    round(stddev(gdp_percap), 2) as 표준편차,
    min(gdp_percap) 최솟값,
    max(gdp_percap) 최댓값,
    median(gdp_percap) 중위값
from gapminder;

-- 1. 테이블에는 모두 몇 개의 나라가 있을까요?
select count(distinct country) from gapminder;

-- 2. 테이블에는 모두 몇 개의 대륙이 있을까요?
select count(distinct continent) from gapminder;

-- 3. 테이블에는 저장된 데이터는 몇년도부터 몇년도까지 조사한 내용일까요?
select distinct year
from gapminder
order by year;

with y as (
    select distinct year
    from gapminder
    order by year
)
select min(year), max(year)
from y;

-- 4. 기대 수명이 최댓값인 레코드(row)를 찾으세요.
select max(life_exp)
from gapminder;

select *
from gapminder
where life_exp = (
    select max(life_exp)
    from gapminder
);

-- 5. 인구가 최댓값인 레코드(row)를 찾으세요.
select max(pop)
from gapminder;

select *
from gapminder
where pop = (
    select max(pop)
    from gapminder
);

-- 6. 1인당 GDP가 최댓값인 레코드(row)를 찾으세요.
select max(gdp_percap)
from gapminder;

select *
from gapminder
where gdp_percap =(
    select max(gdp_percap)
    from gapminder
);

-- 7. 우리나라의 통계 자료만 출력하세요.
select distinct country from gapminder
where lower(country) like '%kor%';

select *
from gapminder
where lower(country) = 'korea, rep.';

-- 8. 연도별 1인당 GDP의 최댓값인 레코드를 찾으세요.
select year, max(gdp_percap)
from gapminder
group by year
order by year;

select * from gapminder
where (year, gdp_percap) in (
    select year, max(gdp_percap) from gapminder
    group by year
)
order by year;

-- rank() 함수를 이용한 그룹별 최댓값 찾기
select
    g.*,
    rank() over (partition by year order by g.gdp_percap desc) as "RANKING"
from gapminder g;

with t as (
    select
        g.*,
        rank() over (partition by year order by g.gdp_percap desc) as "RANKING"
    from gapminder g    
)
select * from t
where t.RANKING <= 3;

-- 9. 대륙별 1인당 GDP의 최댓값인 레코드를 찾으세요.
select continent, max(gdp_percap)
from gapminder
group by continent
order by continent;

select *
from gapminder
where (continent, gdp_percap) in (
    select continent, max(gdp_percap)
    from gapminder
    group by continent
)
order by continent;

-- 10. 연도별, 대륙별, 인구수를 출력하세요. 인구수가 가장 많은 연도와 대륙은 어디인가요?
select year, continent, sum(pop) as "TOTAL_POP"
from gapminder
group by year, continent
order by continent, year;
-- order by year, continent;

select year, continent, sum(pop) "TOTAL_POP"
from gapminder
group by year, continent
order by TOTAL_POP desc
offset 0 rows
fetch next 1 rows only
;

with t as (
    select year, continent, sum(pop) TOTAL_POP
    from gapminder
    group by year, continent
)
select t.* from t
where t.TOTAL_POP = (
    select max(t.TOTAL_POP)
    from t
);

-- 11. 연도별, 대륙별 기대 수명의 평균을 출력하세요. 기대 수명이 가장 긴 연도와 대륙은 어디인가요?
select year, continent, round(avg(life_exp), 2) AVG_LIFE_EXP
from gapminder
group by year, continent
order by year, continent;

select year, continent, round(avg(life_exp), 2) AVG_LIFE_EXP
from gapminder
group by year, continent
order by AVG_LIFE_EXP desc
offset 0 rows
fetch next 1 rows only;

with m as (
    select year, continent, avg(life_exp) "AVG_LIFE_EXP"
    from gapminder
    group by year, continent
)
select * from m
where AVG_LIFE_EXP = (
    select max(AVG_LIFE_EXP) from m
);

-- 12. 연도별, 대륙별 1인당 GDP의 평균을 출력하세요. 1인당 GDP의 평균이 가장 큰 연도와 대륙은 어디인가요?
select year, continent, avg(gdp_percap) "AVG_GDP"
from gapminder
group by year, continent
order by year, continent;

select max(AVG_GDP)
from (
    select year, continent, avg(gdp_percap) "AVG_GDP"
    from gapminder
    group by year, continent
);

with g as (
    select year, continent, avg(gdp_percap) "AVG_GDP"
    from gapminder
    group by year, continent
)
select * from g
where AVG_GDP = (
    select max(AVG_GDP) from g
);

-- 13. 10번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
-- pivot() 함수를 사용한 연도별, 대륙별 인구수
with t as(
    select year, continent, pop from gapminder
)
select * from t
pivot(sum(pop) for continent in ('Africa' as "AFRICA",
                                'Americas' as "AMERICAS",
                                'Asia' as "ASIA",
                                'Europe' as "EUROPE",
                                'Oceania' as "OCEANIA"))
order by year;

with t as (
    select year, continent, pop from gapminder
)
select * from t
pivot(
    sum(pop) for year in (1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, 2002, 2007)
)
order by continent;

-- pivot() 함수를 사용한 연도별 대륙별 기대수명 평균
with t as(
    select year, continent, life_exp from gapminder
)
select
    year,
    round(AFRICA, 2) as AFRICA,
    round(AMERICAS, 2) as AMERICAS,
    round(ASIA, 2) as ASIA,
    round(EUROPE, 2) as EUROPE,
    round(OCEANIA, 2) as OCEANIA
from t
pivot(avg(life_exp) for continent in ('Africa' as "AFRICA",
                                'Americas' as "AMERICAS",
                                'Asia' as "ASIA",
                                'Europe' as "EUROPE",
                                'Oceania' as "OCEANIA"))
order by year;

with t as(
    select year, continent, life_exp from gapminder
)
select *
from t
pivot(avg(life_exp) for continent in ('Africa' as "AFRICA",
                                'Americas' as "AMERICAS",
                                'Asia' as "ASIA",
                                'Europe' as "EUROPE",
                                'Oceania' as "OCEANIA"))

-- pivot() 함수를 사용한 연도별 대륙별 1인당 GDP 평균
with t as(
    select year, continent, gdp_percap from gapminder
)
select
    year,
    round(AFRICA, 2) as AFRICA,
    round(AMERICAS, 2) as AMERICAS,
    round(ASIA, 2) as ASIA,
    round(EUROPE, 2) as EUROPE,
    round(OCEANIA, 2) as OCEANIA
from t
pivot(avg(gdp_percap) for continent in ('Africa' as "AFRICA",
                                'Americas' as "AMERICAS",
                                'Asia' as "ASIA",
                                'Europe' as "EUROPE",
                                'Oceania' as "OCEANIA"))
order by year;

-- 아래는 연습용 그냥
select '10' 십, '20' 이십, '30' 삼십
from (select deptno, sal from emp)
pivot(sum(sal) for deptno in (10, 20, 30));

select round(영업사원, 2) 영업사원, round(점원, 2) 점원
from (select job, sal from emp)
pivot(avg(sal) for job in ('SALESMAN' as 영업사원, 'CLERK' as 점원));

select empno, col, data
from emp
unpivot(data for col in (ename, job));

-- 년도별 가장 적은 1인당 gdp를 나라 이름과 함께 출력해보기.
select year, country, min(gdp_percap)
from gapminder
group by year, country
order by year, country;

/* 뻘짓...
with k as (
select year, continent, sum(pop) "TOTAL_POP"
from gapminder
group by year, continent
order by TOTAL_POP desc
offset 0 rows
fetch next 1 rows only
),
j as (
    select continent, to_char(total_pop) TOTAL_POP_CHAR from k
)
select * from j
unpivot(data for col in (continent, TOTAL_POP_CHAR));


-- 14. 11번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
with m as (
    select year, continent, avg(life_exp) "AVG_LIFE"
    from gapminder
    group by year, continent
)
select year, continent, AVG_LIFE
from m
where AVG_LIFE = (
    select max(AVG_LIFE) from m
);

with m as (
    select year, continent, avg(life_exp) "AVG_LIFE"
    from gapminder
    group by year, continent
),
l as (
    select year, continent, to_char(AVG_LIFE) "AVG_LIFE_CHAR"
    from m
    where AVG_LIFE = (select max(AVG_LIFE) from m)
)    
select * from l
unpivot(data for col in (continent, avg_life_char));

-- 15. 12번 문제의 결과에서 대륙이름이 컬럼이 되도록 출력하세요.
with g as (
    select year, continent, avg(gdp_percap) "AVG_GDP"
    from gapminder
    group by year, continent
)
select year, continent, AVG_GDP
from g
where AVG_GDP = (
    select max(AVG_GDP) from g
);

with g as (
    select year, continent, avg(gdp_percap) "AVG_GDP"
    from gapminder
    group by year, continent
),
p as (
    select year, continent, to_char(AVG_GDP) "AVG_GDP_CHAR"
    from g
    where AVG_GDP = (select max(AVG_GDP) from g)
)
select * from p
unpivot (data for col in (continent, avg_gdp_char));
*/