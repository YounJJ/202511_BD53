/*
 * sub query(서브 쿼리): SQL 문장의 일부로 다른 SQL 문장이 포함되는 것.
 * (1) select 절의 서브 쿼리
 * (2) from 절의 서브 쿼리
 * (3) where 절의 서브 쿼리
 * (4) having 절의 서브 쿼리
 * (주의) 서브 쿼리는 () 안에 작성. 서브 쿼리에서는 세미콜론(;)을 사용하지 않음.
*/

-- ALLEN의 급여보다 더 많은 급여를 받는 직원?
-- (step 1) ALLEN의 급여
select sal from emp where ename = 'ALLEN';

-- (step 2) 급여가 1600보다 많은 직원들
select * from emp where sal > 1600;

-- 서브 쿼리
select * from emp
where sal > (
    select sal from emp where ename = 'ALLEN'
);


-- 전체 사원의 급여 평균보다 더 많은 급여를 받는 직원들?
-- (step 1) 급여 평균
select avg(sal) from emp;
-- (step 2) 급여가 평균 초과하는 직원
select * from emp where sal > 2235;
-- 서브 쿼리
select *
from emp
where sal > (
    select avg(sal) from emp
);

-- 1. ALLEN보다 적은 급여를 받는 직원들의 사번, 이름, 급여를 출력.
select empno, ename, sal
from emp
where sal < (
    select sal from emp
    where ename = 'ALLEN'
);    

-- 2. ALLEN과 같은 업무를 담당하는 직원들의 사번, 이름, 부서번호, 업무, 급여를 출력.
select empno, ename, deptno, job, sal
from emp
where job = (
    select job from emp
    where ename = 'ALLEN'
)
    and ename != 'ALLEN';    

-- 3. SALESMAN의 급여 최댓값보다 더 많은 급여를 받는 직원들의 사번, 이름, 급여, 업무를 출력.
select empno, ename, sal, job
from emp
where sal > (
    select max(sal) from emp
    where job = 'SALESMAN'
);    

-- 4. WARD의 연봉보다 더 많은 연봉을 받는 직원들의 이름, 급여, 수당, 연봉을 출력.
--    연봉 = sal * 12 + comm. comm(수당)이 null인 경우에는 0으로 계산.
--    연봉 내림차순 정렬.
select ename, sal, nvl(comm, 0), sal * 12 + nvl(comm, 0) 연봉
from emp
where sal * 12 + nvl(comm, 0) > (
    select sal * 12 + nvl(comm, 0) from emp
    where ename = 'WARD'
)
order by 연봉 desc;

-- 5. SCOTT과 같은 급여를 받는 직원들의 이름과 급여를 출력. 단, SCOTT은 제외
select ename, sal
from emp
where sal = (
    select sal from emp
    where ename = 'SCOTT'
)
    and ename != 'SCOTT'
;

-- 6. ALLEN보다 늦게 입사한 직원들의 이름, 입사날짜를 최근입사일부터 출력.
select ename, hiredate
from emp
where hiredate > (
    select hiredate from emp
    where ename = 'ALLEN'
)
order by hiredate desc;

-- 7. 매니저가 KING인 직원들의 사번, 이름, 매니저 사번을 검색.
select empno, ename, mgr
from emp
where mgr = (
    select empno from emp
    where ename = 'KING'
);

-- 8. ACCOUNTING 부서에 일하는 직원들의 이름, 급여, 부서번호를 검색.
select ename, sal, deptno
from emp
where deptno = (
    select deptno from dept where dname = 'ACCOUNTING'
);

-- 9. CHICAGO에서 근무하는 직원들의 이름, 급여, 부서 번호를 검색.
select ename, sal, deptno
from emp
where deptno = (
    select deptno from dept
    where loc = 'CHICAGO'
);


-- 단일 행 서브쿼리: 서브쿼리의 결과 행의 개수가 1개인 경우.
-- 단일 행 서브쿼리는 동등비교(=)를 할 수 있음.

-- 다중 행 서브쿼리: 서브쿼리의 결과 행의 개수가 2개 이상인 경우.
-- 다중 행 서브쿼리는 동드비교(=)를 할 수 없음! in 연산자는 사용할 수 있음.
-- SALESMAN들의 급여와 같은 급여를 받는 직원들?
-- (step 1) SALESMAN의 급여
select sal from emp where job = 'SALESMAN';
-- (step 2) 급여는 1600 또는 1250 또는 1500인 직원
select * from emp
where sal = 1600 or sal = 1250 or sal = 1500;
-- or 조건절은 in 연산자로 대체할 수 있음.
select * from emp where sal in (1600, 1250, 1500);
-- 서브쿼리
select * from emp
where sal in (
    select sal from emp where job = 'SALESMAN'
);

-- 매니저인 직원들?
select * from emp
where empno in (
    select distinct mgr from emp
);

-- 매니저가 아닌 직원들?
select * from emp
where empno not in (
    select distinct mgr from emp
);
-- 결과 행이 1개도 없음!
-- 조건식 empno in (a, b, c) empno = a or empno = b or empno = c 와 같은 의미.
-- 조건식 empno not in (a, b, c)은 empno != a and empno != b and empno != c와 같은 의미.
-- in 연산자는 값을 비교할 때 동등비교 연산자(=, !=)를 사용. null과 비교할 때도 동등비교 연산자를 사용.
-- empno = null의 결과도 empno != null 결과는 항상 false
select * from emp where mgr != null;
select * from emp where mgr is not null;

select * from emp
where empno not in (
    select distinct mgr from emp
    where mgr is not null
);


-- 다중 행 서브쿼리와 exists, not exists
-- 매니저인 직원들?
select * from emp e1
where exists (
    select * from emp e2 where e2.mgr = e1.empno
);

-- 매니저가 아닌 직원들?
select * from emp e1
where not exists (
    select * from emp e2 where e2.mgr = e1.empno
);


-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하는 부서들만.
select * from dept d
where exists (
    select * from emp e where e.deptno = d.deptno
)
order by deptno;

-- 부서 테이블의 부서 정보(번호, 이름, 위치)를 출력. 단, 직원 테이블에 존재하지 않는 부서들만.
select * from dept d
where not exists (
    select * from emp e where e.deptno = d.deptno
);


-- 다중 행 서브쿼리에서 any vs all
select * from emp
where sal > any (
    select sal from emp where job = 'SALESMAN'
);
--> 영업사원 급여 최솟값보다 급여를 더 많이 받는 직원들

select * from emp
where sal > all (
    select sal from emp where job = 'SALESMAN'
);
--> 영업사원 급여 최댓값(1600)보다 급여를 더 많이 받는 직원들


-- having 절에서 사용되는 서브쿼리
-- 업무별 급여의 합계 출력. 단, 영업사원들의 급여 합계보다 큰 경우만 출력.
select job, sum(sal) as "TOTAL_SALARY"
from emp
group by job
having sum(sal) > (
    select sum(sal) from emp where job = 'SALESMAN'
)
order by TOTAL_SALARY;


-- select 절에서 사용되는 서브쿼리
-- CLERK들의 사번, 이름, 급여, clerk 급여의 최솟값, 최댓값 출력
select
    empno, ename, sal,
    (select min(sal) from emp where job = 'CLERK') as "MIN_SALARY",
    (select max(sal) from emp where job = 'CLERK') as "MAX_SALARY"
from emp
where job = 'CLERK';


-- from 절에서 사용되는 서브쿼리

-- 이름, 급여, 급여 순위(급여 내림차순) 출력
select
    ename, sal,
    rank() over (order by sal desc) as "RANKING"
from emp;

-- 이름, 입사일, 입사일 순서(입사일 오름차순) 출력
select
    ename, hiredate,
    rank() over (order by hiredate) as "RANK_YEAR"
from emp;

-- 오름차순(asc) 정렬에서는 null이 가장 마지막 순서.
-- 내림차순(desc) 정렬에서는 null이 가장 먼저.
-- 내림차순 정렬에서 null 값들을 마지막에 출력하려면 order by 컬럼 desc nulls last 형식으로 작성.


-- 이름, 급여, 급여 순위를 출력. 1 ~ 5위까지만 출력.
select
    t.*
from (
        select
            ename, sal,
            rank() over (order by sal desc) as "RANKING"
        from emp    
    ) t
where t.RANKING <= 5;


-- with 식별자 as (서브쿼리) 구문: 주된 SQL 문장을 간단히 작성하기 위해서.
with t as (
    select ename, sal,
        rank() over (order by sal desc) as "RANKING"
    from emp    
)
select t.*
from t
where t.RANKING <= 5;