/*
 * 다중행 함수: 여러개의 행들이 함수의 아규먼트로 전달되고 하나의 값이 반환되는 함수.
 * 통계 함수: count, sum, avg, ...
*/

-- count(var): var(컬럼)에서 null이 아닌 행의 개수를 반환.
select count(empno) from emp;
select count(mgr) from emp;

-- count(*): 테이블의 전체 행의 개수를 반환.
select count(*) from emp;

-- 통계(집계) 함수: null을 제외하고 계산.
-- sum(): 합계
select sum(sal) from emp;
select sum(comm) from emp;

-- avg(): average. 평균.
select avg(sal) from emp;
-- select 29025 / 14 from dual;

select avg(comm) from emp;
-- select 2200 / 4 from dual;

-- variance(): 분산
-- stddev(): 표준편차
-- max(): 최댓값
-- min(): 최솟값

-- 급여 개수, 합계, 평균, 분산, 표준편차, 최댓값, 최솟값 출력
select
    count(sal) 개수,
    sum(sal) 합계,
    round(avg(sal), 2) 평균,
    round(variance(sal), 2) 분산,
    round(stddev(sal), 2) 표준편차,
    max(sal) 최댓값,
    min(sal) 최솟값
from emp;

-- 다중행 함수는 단일행 함수와 함께 사용될 수 없음!
-- select count(comm), nvl(comm, 0) from emp;
-- select comm, count(comm) from emp;

/*
 * 그룹별 쿼리
 * (예) 부서별 직원수, 부서별 급여 평균, ...
 * (문법)
 * select 컬럼, 그룹함수, ... --5번
 * from 테이블, ... -- 1번
 * where 조건식(1) --2번
 * group by 컬럼(그룹을 묶기 위한 필드), ... --3번
 * having 조건식(2) --4번
 * order by 컬럼(정렬 기준이 되는 필드), ...; --6번
 *
 * where 조건식(1): 그룹을 묶기 전에 조건을 만족하는 행들만 선택하기 위한 조건식.
 * having 조건식(2): 그룹을 묶은 다음에 조건에 맞는 그룹들만 선택하기 위한 조건식.
*/

-- group by에서 사용한 그룹을 묶기 위한 컬럼 이름은 select에서 사용할 수 있음.
-- 부서별 인원수
select deptno, count(*)
from emp
group by deptno
order by deptno;

-- 부서별 급여 평균(소숫점 2자리까지)
select deptno, round(avg(sal), 2) AVG_SAL
from emp
group by deptno
order by deptno;

-- 소수가 나오는 경우는 반올림해서 소숫점 둘째 자리까지만 표현.
-- PRESIDENT를 제외하고 업무별 직원수, 급여 평균, 최댓값, 최솟값을 출력.
select 
    job,
    count(*) COUNT_EMP,
    round(avg(sal), 2) AVG_SAL,
    max(sal) MAX_SAL,
    min(sal) MIN_SAL
from emp
where job != 'PRESIDENT'
group by job
order by job;

select 
    job,
    count(*) COUNT_EMP,
    round(avg(sal), 2) AVG_SAL,
    max(sal) MAX_SAL,
    min(sal) MIN_SAL
from emp
group by job
having job != 'PRESIDENT'
order by job;

-- 매니저 있는(null이 아닌) 직원들 중에서 업무별 직원수, 급여 평균 출력.

select 
    job,
    count(*) CNT,
    round(avg(sal), 2) AVG
from emp
where mgr is not null
group by job
order by job;

/*
select 
    job,
    count(*) CNT,
    round(avg(sal), 2) AVG
from emp
group by job
having mgr is not null
order by job;
*/

-- 업무별 급여 평균이 2000이상인 그룹들을 출력.
select job, round(avg(sal), 2)
from emp
group by job
having avg(sal) >= 2000
order by job;

-- 매니저 있는 직원들 중에서 업무별 급여 평균이 2000 이상인 업무들을 출력.
select
    job, round(avg(sal), 2) as AVG_SAL
from emp
where mgr is not null
group by job
having avg(sal) >= 2000
order by job;

-- 부서별 업무별 직원수, 급여 평균/최솟값/최댓값을 출력.
select deptno, job, count(*), round(avg(sal), 2), min(sal), max(sal)
from emp
group by deptno, job
order by deptno, job;

-- 매니저가 있는 직원들 중에서
-- 부서별 업무별 급여 평균이 1000 이상인 그룹들만
-- 부서별 업무별 직원수, 급여 평균/최솟값/최댓값을 출력.
select deptno, job, count(*) CNT, round(avg(sal), 2) AVG_SAL, min(sal) MIN_SAL, max(sal) MAX_SAL
from emp
where mgr is not null
group by deptno, job
having avg(sal) >= 1000
order by deptno, job;

-- 입사년도별 직원수를 입사년도 오름차순으로 출력.
select to_char(hiredate, 'YYYY') HIRE_YEAR, count(*) CNT
from emp
group by to_char(hiredate, 'YYYY')
order by HIRE_YEAR;

-- 입사년도별 부서별 직원수 출력.
select to_char(hiredate, 'YYYY') HIRE_YEAR, deptno, count(*) CNT
from emp
group by to_char(hiredate, 'YYYY'), deptno
order by HIRE_YEAR, deptno;