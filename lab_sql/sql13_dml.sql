/*
 * DML: insert, update, delete
*/

-- INSERT INTO table_name [(column1, column2, ...)] VALUES (value1, value2, ...);
-- INSERT INTO table_name [(column1, column2, ...)] SELECT 문장;
-- select의 결과를 테이블 table_name에 삽입(저장). 여러 개의 행들이 한 번에 삽입될 수 있음.

-- bonus 테이블에서 이름, 업무, 급여, 수당을 삽입.
insert into bonus
values ('홍길동', '도적', 100, 10);

-- bonus 테이블에 이름, 급여를 삽입.
insert into bonus (ename, sal)
values ('오쌤', 200);

-- emp 테이블에서 comm이 null이 아닌 직원들의 이름, 업무, 급여, 수당을 bonus 테이블에 삽입.
insert into bonus /* (ename, job, sal, comm) */
select ename, job, sal, comm
from emp
where comm is not null;

commit;

select * from bonus;

-- update 문장: 테이블의 특정 컬럼(들)의 값을 수정(업데이트)
-- (문법) UPDATE 테이블이름 SET 컬럼이름 = 값, ... [WHERE 조건절];
-- where 절은 생략 가능. where 절을 생략하면 테이블의 모든 행들이 업데이트됨.

select * from emp;

update emp set job = 'CLERK';
--> where 절이 없는 경우, 테이블의 모든 행(15개 행)의 job 컬럼 값들이 업데이트!

-- 직전(마지막) commit 상태로 되돌림.
rollback;


-- 사번이 1004인 직원의 업무를 'MANAGER', 입사일을 오늘날짜로 업데이트.
update emp
set job = 'MANAGER', hiredate = sysdate
where empno = 1004;

commit;
--> 변경 내용 저장.

rollback;
--> rollback을 하더라도 이미 commit된 내용을 되돌릴 수는 없음.

-- 사번이 7369인 직원의 급여를 1000, 수당을 100으로 업데이트.
update emp
set sal = 1000, comm = 100
where empno = 7369;

-- 업무가 'CLERK'인 직원들의 급여를 10% 인상.
update emp
set sal = sal * 1.1
where job = 'CLERK';

-- ACCOUNTING 부서에서 일하는 직원들의 급여를 10% 인상.
update emp
set sal = sal * 1.1
where deptno = (
    select d.deptno
    from dept d
    where dname = 'ACCOUNTING'
);    

-- 급여 등급이 1인 직원들의 급여를 20% 인상.
select *
from emp join salgrade on emp.sal between salgrade.losal and salgrade.hisal
where salgrade.grade = 1;

select * from emp
where sal between (select losal from salgrade where grade = 1)
    and
    (select hisal from salgrade where grade = 1);
    
update emp
set sal = sal * 1.2
where sal between (select losal from salgrade where grade = 1)
    and
    (select hisal from salgrade where grade = 1);

rollback;

select * from emp;

update emp
set sal = sal * 1.2
where empno in (
    select e.empno
    from emp e
        join salgrade s on e.sal between s.losal and s.hisal
    where s.grade = 1    
);

commit;

-- comm이 null인 직원들의 comm을 0으로 업데이트.
update emp set comm = 0
where comm is null;

-- emp 테이블에서 부서번호가 dept 테이블에 없는 직원의 부서번호를 null로 업데이트.
update emp set deptno = null
where deptno not in (
    select d.deptno
    from dept d
);

commit;

select * from emp;

/* 
 * = 연산자의 의미:
 * (1) where 절에서의 = 연산자: 비교 연산자
 *     (예) where 컬럼 = 값: 컬럼이 값과 같으면.
 * (2) set 절에서의 = 연산자: 할당(대입) 연산자
 *     (예) set 컬럼 = 값: 컬럼에 값을 저장(할당).
 * (참고) is 연산자: null인 지를 비교할 때 사용하는 비교 연산자.
*/


-- delete 문장: 테이블에서 (조건을 만족하는) 행(들)을 삭제하는 DML.
-- (비교) truncate, drop: DDL (rollback이 되지 않음)
-- (문법) DELETE FROM 테이블이름 [WHERE 조건절];
-- 조건절은 생략 가능. 조건절이 없으면 테이블의 모든 행들이 삭제됨.

delete from emp;
select * from emp;

rollback;

-- 사번이 1004인 직원 정보를 테이블에서 삭제.
delete from emp where empno = 1004;

-- 이름이 SMITH인 직원 정보를 삭제.
delete from emp where ename = 'SMITH';

-- 급여등급이 5인 직원정보를 삭제.
delete from emp where sal between (
    select s.losal
    from salgrade s
    where s.grade = 5)
and (
    select s.hisal
    from salgrade s
    where s.grade = 5
);

select * from emp;

commit;

-- 급여등급이 4인 직원(들)의 정보를 삭제
select e.*, s.*
from emp e
    join salgrade s on e.sal between s.losal and s.hisal
where s.grade = 4;

delete from emp
where empno in (
    select e.empno
    from emp e
        join salgrade s on e.sal between s.losal and s.hisal
    where s.grade = 4   
);

commit;