/*
 * 기본 질의(Query) 문법: 테이블에서 데이터를 검색.
 * (문법) select 컬럼이름, 컬럼이름, ... from 테이블이름;
 * 테이블의 모든 컬럼을 검색: select * from 테이블이름;
*/

-- 직원 테이블(EMP)에서 사번(EMPNO),과 직원 이름(ename)을 검색:
select empno, ename from emp;

-- 직원 테이블의 모든 컬럼을 검색:
select * from emp;
--> 테이블이 만들어진 컬럼의 순서 그대로 출력.

-- 직원들의 정보를 부서번호, 사번, 이름, 업무, 급여, 수당, 입사일, 매니저 사번 순서로 출력.
select deptno, empno, ename, job, sal, comm, hiredate, mgr
from emp;

-- 컬럼 이름에 별명(alias) 주기: 컬럼이름 as "별명"
-- as 키워드는 생략 가능.
-- 별명에 공백이 없는 경우에는 큰따옴표를("") 생략 가능.
-- 별명 이름에서는 작은따옴표('')는 사용 불가!
select
    empno as "사번",
    ename "직원 이름",
    sal 급여
from emp;    
-- 부서 테이블(dept)에서 부서 번호, 부서 이름, 위치를 검색
-- 실제 컬럼 이름 대신 한글로 별명을 사용해서 출력.
select
    deptno "부서 번호",
    dname "부서 이름",
    loc 위치
from dept;

-- 연결 연산자(||): 2개 이상의 컬럼 값들을 합쳐서 하나의 문자열로 만들어줌.
-- 'SMITH'의 급여는 800입니다.' 형식으로 검색 결과를 출력.
select
    ename || '의 급여는 ' || sal || '입니다.' as "이름-급여"
from emp;

-- 부서 테이블에서 부서 번호와 이름을 '10-ACCOUNTING'과 같은 형식으로 출력.
select
    deptno || '-' || dname 부서
from dept;   

-- 검색 결과를 정렬해서 출력하기:
-- (문법) select ... from 테이블 order by 정렬기준컬럼 [asc/desc], ...;
-- asc: 오름차순(ascending order). 정렬의 기본은 오름차순 정렬. 생략 가능.
-- desc: 내림차순(descending order). 생략 불가!

-- 사번, 이름을 검색. 사번 오름차순으로 출력.
select empno, ename
from emp
order by empno;
-- order by empno asc와 같음.

-- 사번, 이름을 검색. 사번 내림차순으로 출력.
select empno, ename
from emp
order by empno desc;

-- 부서번호, 이름, 급여를 검색.
-- 정렬 순서: (1) 부서 번호 오름차순, (2)급여 내림차순.
select deptno, ename, sal 
from emp 
order by deptno, sal desc;

-- 직원 이름 오름차순 정렬 출력
select ename from emp order by ename;

-- 부서번호, 이름, 입사일을 검색
-- 정렬 순서: (1) 부서번호 오름차순, (2) 입사일 오름차순.
select deptno, ename, hiredate
from emp
order by deptno, hiredate;

-- 사번, 이름, 업무, 급여를 검색.
-- 정렬 순서: (1) 업무 오름차순, (2) 급여 오름차순
select empno, ename, job, sal
from emp
order by job, sal;

-- 중복되는 데이터는 제거하고 출력.
-- (문법) select distinct 컬럼, ... from 테이블;
select distinct deptno from emp;

-- select 문장과 select distinct 문장 비교
select deptno, job from emp order by deptno, job;
select distinct deptno, job from emp order by deptno, job;

-- (주의) distinct 키워드는 한번만 사용!
-- select distinct deptno, distinct job from emp;