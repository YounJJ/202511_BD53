/*
 * 연습문제 - scott 계정을 사용
*/

-- 페이징(paging) 처리
-- 1. 직원 테이블을 사번 오름차순으로 정렬했을 때 1 ~ 5번 행까지 출력
-- 2. 직원 테이블을 사번 오름차순으로 정렬했을 때 6 ~ 10번 행까지 출력
-- 3. 직원 테이블을 사번 오름차순으로 정렬했을 때 11 ~ 15번 행까지 출력

-- rownum: Oracle에서 제공되는 가상(pseudo) 컬럼.
select rownum, e.* from emp e order by sal;

select
    rownum, t.*
from (
    select * from emp order by empno
) t;
-- where rownum between 6 and 10; 이런 방식은 rownum이 가상컬럼이라 작동하지 않음.

select
    t2.*
from (
    select rownum as "RN", t1.*
    from (
        select * from emp order by empno
    ) t1
) t2
where t2.RN between 11 and 15;

with t2 as (
    select rownum as "RN", t1.*
    from(
        select * from emp order by empno
    ) t1
)
select t2.*
from t2
where t2.RN between 11 and 15;

-- row_number() 윈도우 함수 사용:
select
    emp.*,
    row_number() over (order by empno) as "RN"
from emp;   

with t as (
    select
        emp.*,
        row_number() over (order by empno) as "RN"
    from emp    
)
select t.*
from t
where t.RN between 11 and 15;

-- Top-N 쿼리(query)
select *
from emp
order by empno
offset 10 rows
fetch next 5 rows only;
--> offset x rows: 첫 x개의 행을 건너뛰고
--> fetch next y rows only: 그다음 y개의 행들만 출력.


/*
 * 연습문제 - hr 계정을 사용
 * - hr.sql 스크립트를 실행
 * - hr 계정의 테이블 내용을 파악
 * - 연습문제들에서 직원의 이름은 이름(first_name)과 성(last_name)을 붙여서 하나의 컬럼으로 출력.
 *    (예) Steven King
*/

-- 1. 직원의 이름과 부서 이름을 출력. (inner join)
select 
    e.first_name || ' ' || e.last_name as "직원이름",
    d.department_name "부서이름"
from employees e
    inner join departments d on e.department_id = d.department_id
;

select 
    e.first_name || ' ' || e.last_name as "직원이름",
    d.department_name "부서이름"
from employees e, departments d
where e.department_id = d.department_id
;

-- 2. 직원의 이름과 부서 이름을 출력. 부서 번호가 없는 직원도 출력.
select 
    e.first_name || ' ' || e.last_name as "직원이름",
    d.department_name "부서이름"
from employees e
    left join departments d on e.department_id = d.department_id
;

select 
    e.first_name || ' ' || e.last_name as "직원이름",
    d.department_name "부서이름"
from employees e, departments d
where e.department_id = d.department_id(+)
;

-- 3. 직원의 이름과 직무 이름(job title)을 출력.
select
    e.first_name || ' ' || e.last_name 직원이름,
    j.job_title 직무이름
from employees e
    inner join jobs j on e.job_id = j.job_id;
    
select
    e.first_name || ' ' || e.last_name 직원이름,
    j.job_title 직무이름
from employees e, jobs j
where e.job_id = j.job_id;

-- 4. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력.
select
    e.first_name || ' ' || e.last_name 직원이름,
    l.city 근무도시
from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id;
    
select
    e.first_name || ' ' || e.last_name 직원이름,
    l.city 근무도시
from employees e, departments d, locations l
where e.department_id = d.department_id 
    and d.location_id = l.location_id;
    
-- 5. 직원의 이름과 직원이 근무하는 도시 이름(city)를 출력. 근무 도시를 알 수 없는 직원도 출력.
select
    e.first_name || ' ' || e.last_name 직원이름,
    l.city 근무도시
from employees e
    left join departments d on e.department_id = d.department_id
    left join locations l on d.location_id = l.location_id;
    
select
    e.first_name || ' ' || e.last_name 직원이름,
    l.city 근무도시
from employees e, departments d, locations l
where e.department_id = d.department_id(+)
    and d.location_id = l.location_id(+);

-- 6. 2008년에 입사한 직원들의 이름을 출력.
-- 입사일을 DATE 타입의 크기 비교를 사용
select
    first_name || ' ' || last_name 직원이름
from employees
where hire_date between to_date('2008-01-01', 'YYYY-MM-DD') and to_date('2008-12-31', 'YYYY-MM-DD');

select
    first_name || ' ' || last_name 직원이름
from employees
where hire_date between '2008-01-01' and '2008-12-31';
--> '2008-01-01' 문자열을 암묵적으로 DATE 타입으로 변환한 다음에 크기 비교.

-- 입사일(DATE 타입)을 문자열로 변환해서 문자열 비교.
select
    first_name || ' ' || last_name 직원이름,
    to_char(hire_date, 'YYYY') 입사년도
from employees
where to_char(hire_date, 'YYYY') = '2008';

-- 7. 2008년에 입사한 직원들의 부서 이름과 부서별 인원수 출력.
select 
    d.department_name "부서 이름",
    count(*) "부서별 인원수"
from employees e
    inner join departments d on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
;

select 
    d.department_name "부서 이름",
    count(*) "부서별 인원수"
from employees e, departments d
where e.department_id = d.department_id
    and to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
;

-- 8. 2008년에 입사한 직원들의 부서 이름과 부서별 인원수 출력.
--    단, 부서별 인원수가 5명 이상인 경우에만 출력.
select 
    d.department_name "부서 이름",
    count(*) "부서별 인원수"
from employees e
    inner join departments d on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
having count(*) >= 5
;

select 
    d.department_name "부서 이름",
    count(*) "부서별 인원수"
from employees e, departments d
where e.department_id = d.department_id
    and to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
having count(*) >= 5
;

-- 9. 부서번호, 부서별 급여 평균을 검색. 소숫점 한자리까지 반올림 출력.
select
    department_id 부서번호,
    round(avg(salary), 1) "부서별 급여 평균"
from employees
group by department_id
order by 부서번호
;

-- 10. 부서별 급여 평균이 최대인 부서의 부서번호, 급여 평균을 출력.
-- (1) having 절과 서브쿼리 사용
select
    department_id 부서번호,
    round(avg(salary), 1) 급여평균
from employees
group by department_id
having avg(salary) = (
    select max(avg(salary)) from employees group by department_id
);

-- (2) from 절에서의 서브쿼리 사용
select t.*
from (
    select department_id 부서번호, avg(salary) as "급여 평균"
    from employees
    group by department_id
    order by avg(salary) desc
) t
where rownum = 1;

-- (3) with 식별자 as (서브쿼리) 사용
with t as (
    select department_id 부서번호, avg(salary) 급여평균
    from employees
    group by department_id
)
select *
from t
where t."급여평균" = (
    select max(t."급여평균") from t
);

-- (참고) employees 테이블에서 급여가 최대인 직원 정보.
select * from employees
where salary = (select max(salary) from employees);

-- (4) offset-fetch 사용
select department_id 부서번호, round(avg(salary), 1) 급여평균
from employees
group by department_id
order by 급여평균 desc
offset 0 rows
fetch next 1 rows only;
--> select 문장에서 offset-fetch 절은 order by 다음에 사용할 수 있음.

-- 11. 사번, 직원 이름, 국가 이름, 급여 출력.
select
    e.employee_id,
    e.first_name || ' ' || e.last_name EMP_NAME,
    c.country_name,
    e.salary
from employees e
    left join departments d on e.department_id = d.department_id
    left join locations l on d.location_id = l.location_id
    left join countries c on l.country_id = c.country_id;
    
select
    e.employee_id,
    e.first_name || ' ' || e.last_name EMP_NAME,
    c.country_name,
    e.salary
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id(+)
    and d.location_id = l.location_id(+)
    and l.country_id = c.country_id(+);
    
-- 12. 국가이름, 국가별 급여 합계 출력.
select
    c.country_name, sum(e.salary)
from employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name;

select
    c.country_name, sum(e.salary)
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id
group by c.country_name;

-- 13. 사번, 직원이름, 직무 이름, 급여를 출력.
select
    e.employee_id,
    e.first_name || ' ' || e.last_name EMP_NAME,
    j.job_title,
    e.salary
from employees e
    inner join jobs j on e.job_id = j.job_id;
    
select
    e.employee_id,
    e.first_name || ' ' || e.last_name EMP_NAME,
    j.job_title,
    e.salary
from employees e, jobs j
where e.job_id = j.job_id;

-- 14. 직무 이름, 직무별 급여 평균, 최솟값, 최댓값을 출력.
select
    j.job_title,
    avg(salary),
    min(salary),
    max(salary)
from employees e
    inner join jobs j on e.job_id = j.job_id
group by j.job_title;

-- 15. 국가 이름, 직무 이름, 국가별 직무별 급여 평균을 출력.
select 
    c.country_name,
    j.job_title,
    round(avg(salary), 1) AVG_SAL
from employees e
    left join departments d on e.department_id = d.department_id
    left join locations l on d.location_id = l.location_id
    left join countries c on l.country_id = c.country_id
    left join jobs j on e.job_id = j.job_id
group by rollup(c.country_name, j.job_title)
order by c.country_name, j.job_title;

-- 16. 국가 이름, 직무 이름, 국가별 직무별 급여 합계를 출력.
--    미국에서, 국가별 직무별 급여 합계가 50,000 이상인 레코드만 출력.
select 
    c.country_name,
    j.job_title,
    sum(e.salary)
from employees e
    left join departments d on e.department_id = d.department_id
    left join locations l on d.location_id = l.location_id
    left join countries c on l.country_id = c.country_id
    left join jobs j on e.job_id = j.job_id
where c.country_id = 'US'    
group by c.country_name, j.job_title
having sum(e.salary) >= 50000
order by c.country_name, j.job_title;


-- 17. 부서번호, 부서이름, 부서 매니저 사번, 부서 매니저 이름, 부서 매니저 직무, 부서 매니저 급여 출력.
select distinct
    e1.department_id,
    d.department_name,
    d.manager_id,
    e2.first_name || ' ' || e2.last_name DEP_MAN,
    j.job_title,
    e2.salary
from employees e1
    join departments d on e1.department_id = d.department_id
    join employees e2 on d.manager_id = e2.employee_id
    join jobs j on e2.job_id = j.job_id
;

-- 아래는 강사님 예시
select
    d.department_id, d.department_name, d.manager_id,
    e.first_name || e.last_name, j.job_title, e.salary
from departments d
    join employees e on d.manager_id = e.employee_id
    join jobs j on e.job_id = j.job_id
order by d.department_id;