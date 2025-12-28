/*
 * 조건 검색 - where 구문
 * 조건을 만족하는 행(row)들을 선택하는 방법.
 * (문법) select 컬럼, ... from 테이블 where 조건식 [order by 컬럼, ...];
 * 
 * 조건식에서 사용되는 연산자:
 * (1) 비교 연산자: =, !=, >, >=, <, <=, is null, is not null, ...
 * (2) 논리 연산자: and, or, not
 *
*/

-- 10번 부서에서 근무하는 직원들의 사번, 이름, 부서번호를 출력.
select empno, ename, deptno
from emp
where deptno = 10;

-- 10번 부서가 아닌 직원들의 사번, 이름, 부서번호를 출력.
select empno, ename, deptno
from emp
where deptno != 10; -- !=, <>, ^= 전부 같은 의미

-- 수당(comm)이 null이 아닌 직원들의 모든 정보를 출력.
select * from emp
where comm is not null;

-- (주의) null인지 null이 아닌지를 비교할 때는 =, != 연산자를 사용하면 안됨!
-- ex) select * from emp where comm != null; (불가능)
-- 반드시 is null, is not null 키워드를 사용해야 됨.

-- 수당이 null인 직원들 정보
select * from emp where comm is null;

-- 수당이 null이 아닌 직원들의 부서번호, 사번, 이름, 급여, 수당을 검색
-- 정렬 순서: (1) 부서 번호 오름차순, (2) 사번 오름차순
select deptno, empno, ename, sal, comm
from emp
where comm is not null
order by deptno, empno;

-- 급여가 2000 이상인 직원들의 이름, 업무, 급여를 출력.
-- 정렬 순서: (1) 급여 내림차순, (2) 이름 오름차순
select ename, job, sal
from emp
where sal >= 2000
order by sal desc, ename;

-- 급여가 2000 이상이고 3000 이하인 직원들의 이름, 업무, 급여를 출력
-- 정렬 순서: 급여 내림차순.
select ename, job, sal
from emp
where sal >= 2000 and sal <= 3000
-- 2000 <= sal <= 3000 과 같은 문법은 사용 불가능!
order by sal desc;

select ename, job, sal
from emp
where sal between 2000 and 3000
order by sal desc;

-- 비교: 급여가 2000 이하이거나 3000 이상인 직원들.
select ename, job, sal
from emp
where sal <= 2000 or sal >= 3000
order by sal desc;

-- 수당은 null이 아니고, 급여는 1500 미만인 직원들
select * from emp 
where comm is not null and sal < 1500;

-- 10번 또는 20번 부서에서 근무하는 직원들의 부서번호, 이름, 급여를 출력.
-- 정렬: (1) 부서번호 오름차순, (2) 급여 내림차순.
select deptno, ename, sal
from emp
where deptno = 10 or deptno = 20
order by deptno, sal desc;

select deptno, ename, sal
from emp
where deptno in (10, 20)
order by deptno, sal desc;

-- 업무가 'CLERK'인 직원들의 이름, 업무, 급여를 출력. 이름순으로 출력.
select ename, job, sal
from emp
where job = 'CLERK'
order by ename;
--> (주의) SQL 식별자(예약어, 테이블 이름, 칼럼 이름)를 제외한 문자열은 작은따옴('')를 사용해야함.
-- 문자열 비교는 대/소문자를 구분함.
-- 식별자들은 대/소문자를 구분하지 않음.

-- 업무가 'CLERK' 또는 'MANAGER'인 직원들의 이름, 업무, 급여를 출력.
-- 정렬: (1) 업무, (2) 급여
select ename, job, sal
from emp
where job = 'CLERK' or job = 'MANAGER'
order by job, sal;

select ename, job, sal
from emp
where job in ('CLERK', 'MANAGER')
order by job, sal;

-- 업무가 영업사원, 관리자, 분석가인 직원들.
select * from emp
where job = 'SALESMAN' or job = 'MANAGER' or job = 'ANALYST'
order by job;

select * from emp
where job in ('SALESMAN', 'MANAGER', 'ANALYST')
order by job;

-- 20번 부서에서 근무하는 'CLERK'의 모든 레코드(모든 컬럼)를 출력.
select *
from emp
where deptno = 20 and job = 'CLERK';

-- CLERK, ANALYST, MANAGER가 아닌 직원들의 사번, 이름, 업무, 급여를 사번순 출력.
select empno, ename, job, sal
from emp
where job != 'CLERK' and job != 'ANALYST' and job != 'MANAGER'
order by empno;

select empno, ename, job, sal
from emp
where job not in ('CLERK', 'ANALYST', 'MANAGER')
order by empno;

-- like 검색: 특정 문자열이 포함된 값들을 찾는 검색 방법
-- like 검색에서 사용되는 wildcard:
-- (1) %: 글자수 상관없이 어떤 문자열이어도 상관 없음.
-- (2) _: 밑줄(underscore)이 있는 자리에 한 글자가 어떤 문자이더라도 상관 없음.

select * from emp where job like 'C%';
--> 업무가 'C'로 시작하는 모든 단어인 경우.

select * from emp where job like '%R';
--> 업무가 'R'로 끝나는 모든 단어인 경우.

select * from emp where job like '%A%';
--> 업무에 'A'가 포함된 경우.

select * from emp where job like 'C_';
--> C로 시작하는 두글자만 검색함.

select * from emp where job like '_LERK';
select * from emp where job like '__ERK';

-- 이름에 'A'가 포함된 직원들의 정보.
select * from emp where ename like '%A%';

-- 업무에 'MAN'이 포함된 직원들의 정보.
select * from emp where job like '%MAN%';


select * from emp where empno = 7369;
--> 사번(empno)가 숫자 7369와 같은 레코드.

-- 암묵적 타입 변환
select * from emp where empno = '7369';
--> 사번(empno)가 문자열 '7369'과 같은 레코드.
--> 오라클은 문자열 값을 숫자로 변환한 후에 empno 컬럼의 값들과 비교.

-- 명시적 타입 변환: 함수를 사용함.
select * from emp where empno = to_number('7369');

-- 날짜 타입의 크기 비교: 과거(2024년) < 현재(2025년) < 미래(2026년)
-- 입사일이 1982/01/01 이후에 입사한 직원들
select * from emp where hiredate >= '1982/01/01';
--> 오라클은 문자열 '1982/01/01'을 날짜 타입(DATE)으로 암묵적으로 변환한 후
-- hiredate 컬럼의 값들과 크기를 비교해서 조건에 맞는 레코드들을 검색.

select * from emp where hiredate >= '82/01/01';
--> 위 SQL 문장의 실행 결과는
-- 환경설정 -> 데이터베이스 -> NLS -> 날짜/시간 형식 설정에 따라서 다른 결과를 줌.
-- 날짜 형식의 문자열을 DATE 타입으로 암묵적 변환이 일어날 경우에는 환경 설정에 따라 다른 결과.
-- 날짜 형식의 문자열은 명시적인 타입 변환을 하는 것을 권장.
-- to_date('날짜 형식으로 작성된 문자열', '날짜 포맷') 함수 사용방법
select to_date('2025-11-20', 'YYYY-MM-DD') from dual;
select to_date('11/20/2025', 'MM/DD/YYYY') from dual;
select to_date('01/05/2025', 'MM/DD/YYYY') from dual;
select to_date('01/05/2025', 'DD/MM/YYYY') from dual;

-- 2자리 연도 표기: 
-- (1) YY(현재 세기): 현재 세기의 끝 두 자리.
-- (2) RR(반올림 세기): 현재 연도를 반올림해서 현재 세기가 될 수 있는 연도들.
--     2000 - 50 = 1950 ~ 2000 + 49 = 2049
select to_date('99/11/20', 'YY/MM/DD') from dual; --> 2009년
select to_date('99/11/20', 'RR/MM/DD') from dual; --> 1999년

-- 조건절에서의 날짜 크기 비교
select * from emp where hiredate > to_date('82/01/01', 'RR/MM/DD');