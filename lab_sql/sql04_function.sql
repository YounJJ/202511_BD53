/*
 * 오라클 함수(function)
 * 1. 단일 행 함수:
 *    - 행(row)이 하나씩 함수의 아규먼트로 전달되고, 행마다 결과값 반환되는 함수.
 *    - (예) to_number, to_date, to_char, lower, upper, ...
 * 2. 다중 행 함수:
 *    - 테이블에서 여러개의 행들이 함수의 아규먼트로 전달되고, 하나의 결과값이 반환되는 함수.
 *    - 통계 관련 함수. (예) count, sum, avg, ...
*/

-- 단일 행 함수
-- to_char(컬럼, '포맷'): 컬럼의 값들을 '포맷' 형식의 문자열로 변환.
select
    ename,
    to_char(hiredate, 'YYYY-MM-DD') 입사일1,
    to_char(hiredate, 'MM/DD/YYYY') 입사일2
from emp;

-- 직원이름, 입사연도를 출력
select ename, to_char(hiredate, 'YYYY') 입사연도
from emp;

-- lower(문자열 타입 컬럼): 소문자로 변환.
-- upper(문자열 타입 컬럼): 대문자로 변환.
-- initcap(문자열 타입 컬럼): 첫글자만 대문자, 나머지는 소문자로 변환.
select
    ename, lower(ename), upper(ename), initcap(ename)
from emp;

-- 이름 중에 대/소문자 구분없이 'a'가 포함된 직원들의 레코드.
select * from emp
where lower(ename) like '%a%';


-- replace(문자열 [컬럼], 변환전 문자, 변환할 문자)
select replace('smith', 'i', '*') from dual;
select replace('allen', 'l', '*') from dual;
select ename, replace(ename, 'A', '-') from emp;

-- substr(문자열[컬럼], 자르기 시작 인덱스, 자를 문자 개수)
select substr('hello sql', 3, 5) from dual;
select ename, substr(ename, 1, 2) from emp;

-- substr(문자열[컬럼], 자르기 시작 인덱스): 시작 인덱스부터 문자열 끝까지 자름.
select substr('hello sql', 2) from dual;

-- length(문자열[컬럼]): 글자수를 반환.
-- lengthb(문자열[컬럼]): 문자 바이트 개수를 반환.
select length('hello'), lengthb('hello') from dual;
select length('안녕하세요'), lengthb('안녕하세요') from dual;
--> 영문자, 숫자, 특수기호들은 저장할 때 1바이트(byte)를 사용.
--> 한글 1글자는 저장할 때 3바이트를 사용.

select ename, length(ename) from emp;

-- 직원 이름이 6글자 이상인 직원들의 레코드를 출력.
select * from emp where length(ename) >= 6;

-- 직원 이름의 첫글자와 마지막 글자만 표기하고 중간은 '*'로만 출력.
select substr(ename, 1, 1) || '*' || substr(ename, length(ename), 1)
from emp;

-- nvl(var, value): var가 null이면 value를 반환하고, null이 아니면 var를 그대로 반환.
select comm, nvl(comm, -1)
from emp;

-- nvl2(var, value1, value2): var가 null이 아니면 value1을, null이면 value2를 반환.
select comm, nvl2(comm, '수당있음', '수당없음')
from emp;

select comm, nvl2(comm, comm, -1)
from emp;

-- 직원이름, 급여, 수당, 연봉(= 급여 * 12 + 수당)을 출력
select
    ename, sal, comm, sal * 12 + nvl(comm, 0) ANUAL_SAL
from emp;

-- 연봉이 30,000 이상인 직원들의 이름, 급여, 수당, 연봉을 출력.
-- 연봉 내림차순 정렬해서 출력.
select
    ename, sal, comm,
    sal * 12 + nvl(comm, 0) as ANUAL_SAL -- 3번
from emp -- 1번
where sal * 12 + nvl(comm, 0) >= 30000 -- 2번
order by ANUAL_SAL desc; -- 4번
--> select 절에서 설정한 별명(alias)는 from, where 등의 절에서는 사용할 수 없음.
-- order by 절에서만 사용할 수 있음.

-- 연봉이 10,000 이상 30,000 이하인 직원들의 이름, 급여, 수당, 연봉을 연봉 내림차순으로 출력.
select
    ename, sal, comm,
    sal * 12 + nvl(comm, 0) ANUAL_SAL
from emp
where sal * 12 + nvl(comm, 0) between 10000 and 30000
order by ANUAL_SAL desc;

-- round() 함수: 반올림
select
    10 / 3,
    round(10 / 3),    --> 소수점 첫째 자리에서 반올림 해서 정수로 표현
    round(10 / 3, 1), --> 소수점 둘째 자리에서 반올림 해서 소수점 한자리까지 표현
    round(10 / 3, 2)  --> 소수점 둘째자리까지만 표현.
from dual;

-- round(값, 음의정수): 정수 자릿수에서 반올림.
select round(153, -1), round(153, -2) from dual;

-- trunc() 함수: 버림. 잘라냄. 내림.
select trunc(3.141592, 2), trunc(3.141592, 3) from dual;
select round(3.141592, 2), round(3.141592, 3) from dual;

-- decode(var, value, return1, return2)
-- var의 값이 value와 같으면 return1 반환, 그렇지 않으면 return2를 반환.
-- 부서번호가 10번인 직원은 보너스가 100, 그렇지 않으면 보너스 200.
select
    ename, deptno,
    decode(deptno, 10, 100, 200) BONUS
from emp;

-- decode(var, value1, return1, value2, return2, return3)
-- var의 값이 value1이면 return1을, var의 값이 value2이면 return2를, 그렇지 않으 return3을 반환.
-- 부서번호가 10이면 보너스는 50, 부서번호가 20이면 100, 그렇지 않으면 0.
select
    ename, deptno,
    decode(deptno, 10, 50, 20, 100, 0) BONUS
from emp;

-- case-when 구문: decode() 함수를 대신할 수 있는 구문
select
    ename, deptno,
    case when deptno = 10 then 50
         when deptno = 20 then 100
         else 0
    end as "BONUS"
from emp;

-- 급여가 3000 이상이면 보너스 100, 2000 이상이면 150, 1000 이상이면 170, 그렇지 않으면 200
select
    ename, sal,
    case
        when sal >= 3000 then 100
        when sal >= 2000 then 150
        when sal >= 1000 then 170
        else 200
    end BONUS
from emp;

-- case-when 구문에서 when 조건절의 순서는 중요할 수 있음.
select ename, sal,
    case
        when sal >= 1000 then 100
        when sal >= 2000 then 200
        else 0
    end BONUS
from emp;
