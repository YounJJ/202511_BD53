/*
 * call_chicken.csv 데이터 분석
 * 1. github에 있는 CSV 파일을 다운로드.
 * 2. CSV 파일 내용을 저장할 수 있는 테이블 생성
 *    테이블 이름(call_chicken), 컬럼 이름(call_date, call_day, gu, ages, gender, calls)
 * 3. CSV 파일 데이터를 테이블로 임포트(import)
 * 4. 분석:
 *    (1) 통화 건수의 최댓값, 최솟값
 *    (2) 통화 건수가 최댓값이거나 최솟값인 레코드 출력
 *    (3) 통화 요일별 통화 건수의 평균
 *    (4) 연령대별 통화 건수의 평균
 *    (5) 통화 요일별 연령대별 통화 건수의 평균
 *    (6) 구별 성별 통화 건수의 평균
 *    (7) 요일별 구별 연령대별 통화 건수의 평균
*/

-- CSV(Comma-Separated Values) 파일:
-- 값들들 쉼표(,)로 구분해서 테이블 모양의 데이터를 텍스트로 작성한 파일.

drop table call_chicken purge;

-- 2. 테이블 생성
create table call_chicken (
    call_date   date,
    call_day    char(5 char), /* char: 고정길이 문자열 */
    gu          varchar2(5 char), /* varchar2: 가변길이 문자열 */
    ages        varchar2(5 char),
    gender      char(1 char),
    calls       number(4)
);


select * from call_chicken;
select count(*) from call_chicken;
--> 행(row) 개수

select distinct call_date from call_chicken order by call_date;

select distinct call_day from call_chicken;

select distinct gu from call_chicken order by gu;

select distinct ages from call_chicken order by ages;

select distinct gender from call_chicken;

-- (1) 통화 건수의 최댓값, 최솟값
select max(calls), min(calls)
from call_chicken;

-- (2) 통화 건수가 최댓값이거나 최솟값인 레코드 출력
select * from call_chicken
where calls = (select max(calls) from call_chicken)
    or
    calls = (select min(calls) from call_chicken);

select stats_mode(c.ages)
from (
    select * from call_chicken
    where calls = (select max(calls) from call_chicken)
    or
    calls = (select min(calls) from call_chicken)
) c;

select * from call_chicken
where calls in 
    ((select max(calls) from call_chicken),
    (select min(calls) from call_chicken));

-- (3) 통화 요일별 통화 건수의 평균
select call_day,
       round(avg(calls), 2) as "CALLS"
from call_chicken
group by call_day
order by case call_day
    when '월' then 1
    when '화' then 2
    when '수' then 3
    when '목' then 4
    when '금' then 5
    when '토' then 6
    when '일' then 7
end;

-- (4) 연령대별 통화 건수의 평균
select ages, round(avg(calls), 2) as "CALLS"
from call_chicken
group by ages
order by calls desc;

-- (5) 통화 요일별 연령대별 통화 건수의 평균
select call_day, ages, round(avg(calls), 2) "CALLS"
from call_chicken
group by call_day, ages
order by calls desc;

select call_day, ages, round(avg(calls), 2) "CALLS"
from call_chicken
group by call_day, ages
order by calls desc
offset 0 rows
fetch next 10 rows only;

-- (6) 구별 성별 통화 건수의 평균
select gu, gender, round(avg(calls), 2) "CALLS"
from call_chicken
group by gu, gender
order by CALLS desc;

-- (7) 요일별 구별 연령대별 통화 건수의 평균
select call_day, gu, ages, round(avg(calls), 2) CALLS
from call_chicken
group by call_day, gu, ages
order by CALLS desc;