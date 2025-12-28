/*
 * SQL 문장의 종류:
 * 1. DDL(Data Definition Language): create, alter, truncate, drop
 * 2. DQL(Data Query Language): select
 * 3. DML(Data Manipulation Language): insert, update, delete
 * 4. TCL(Transaction Control Language): commit, rollback
 *
 * 테이블 생성하기:
 * create table 테이블이름 (
 *     컬럼이름 데이터타입 [[기본값] [제약조건]], []은 생략가능 의미
 *     ...
 * );
 *
 * 데이터 타입으로 사용되는 키워드들은 데이터베이스 종류에 따라서 다를 수 있음.
 * 오라클의 데이터 타입: number, varchar2(가변길이 문자열), date, timestamp,
 *                  clob(character large object), blob(binary large object), ...
 *
*/


/*
 * 테이블 이름: ex_students
 * 컬럼:
 *    (1) stu_no: 아이디(학번). 숫자 타입(4자리 정수)
 *    (2) stu_name: 학생 이름. 문자열 타입(최대 10글자)
 *    (3) birthday: 학생 생일. 날짜 타입.
*/
create table ex_students (
    stu_no number(4, 0),
    stu_name varchar2(10 char),
    birthday date
);

/*
 * 테이블에 행(row)을 삽입(저장):
 * insert into 테이블이름 (컬럼이름, ...) values (값, ...);
 *
 * 테이블에 삽입하는 값들의 개수가 컬럼 개수와 같고, 값들의 순서가 테이블 컬럼 순서와 같으면,
 * insert into 테이블이름 values(값, ...);
*/
insert into ex_students (stu_no, stu_name, birthday)
values (1001, '홍길동', '2025/11/27');

-- 테이블의 모든 컬럼에, 테이블 컬럼 순서대로 값들을 삽입(저장)
insert into ex_students values (1002, '오쌤', '2000/12/01');

select * from ex_students;

-- insert into에서 컬럼 순서들은 테이블 컬럼 순서와 같아야 할 필요는 없음.
insert into ex_students (birthday, stu_name, stu_no)
values ('2010/01/01', 'Scott', 2000);

-- 제약조건이 없으면 테이블의 모든 컬럼에 값을 삽입할 필요는 없음.
insert into ex_students (stu_no, stu_name)
values (2001, 'King');

commit;
--> 커밋(commit): DB에서 작업한(변경한) 내용(들)을 영구적으로 저장.

-- insert into ex_students values (2002, '김길동');
--> ex_students 테이블의 컬럼은 3개인데, 삽입하려는 값은 2개 밖에 없어서 에러.

-- insert into ex_students values ('2025/11/27', 1234, '홍길동');
--> 테이블의 컬럼 순서와 삽입하려는 값들의 순서가 달라서(데이터 타입이 달라서)

-- insert into ex_students (stu_no) values (12345);
--> stu_no에 저장할 수 있는 자릿수(4자리)보다 큰 값을 삽입하려고 해서.


-- varchar2 타입의 단위: byte(기본값) vs char
-- varchar2(10)는 varchar2(10 byte)와 같다.
-- 오라클에서 문자를 저장할 때 UTF-8 인코딩 타입을 사용하는 경우,
-- 영문자, 숫자, 특수기후 -> 1글자를 저장할 때 1바이트를 사용.
-- 한글 -> 1글자를 저장할 때 3바이트를 사용.
-- 테이블 컬럼의 데이터 타입이 varchar2(n char)인 경우, 한글/영문 상관없이 n개까지 문자를 저장할 수 있음.
-- 컬럼 데이터 타입이 varchar2(n byte)인 경우, 저장할 수 있는 한글/영문 문자 개수가 다름!

insert into ex_students (stu_name) values ('1234567890');
-- insert into ex_students (stu_name) values ('01234567890');
--> 글자가 너무 큼(글자수가 10개를 넘음) 오류

insert into ex_students (stu_name) values ('가나다라마바사아자차');
-- insert into ex_students (stu_name) values ('가나다라마바사아자차a');

select * from ex_students;
commit;

create table ex_byte (
    col_str varchar2(5) -- varchar2(5 byte)와 같음. 
);

insert into ex_byte values ('abc12');
-- 문자열 'abc12'의 길이는 5바이트이기 때문에 insert 성공.

-- insert into ex_byte values ('홍길동');
--> 문자열 '홍길동'은 한글로만 이루어져 있기 때문에 3*3 = 9 바이트.

commit;


-- create table 연습: emp 테이블과 같은 이름, 같은 타입의 컬럼들을 갖는 테이블(ex_emp)
create table ex_emp (
    EMPNO NUMBER(4, 0),
    ENAME varchar2(10),
    JOB varchar2(9),
    MGR number(4, 0),
    hiredate date,
    sal number(7, 2),
    comm number(7, 2),
    deptno number(2, 0)
);


-- create table-as select 구문: 테이블을 생성하면서 기존 테이블의 내용을 복사.
-- dept 테이블을 전체 복사
create table dept_copy
as select * from dept;

-- dept 테이블 구조(컬럼 & 데이터 타입)는 복사, 데이터는 복사하지 않기.
create table dept_copy2
as select * from dept where deptno = -1;

-- emp 테이블에서 10번 부서 직원들의 사번, 이름, 부서번호, 급여를 복사한 테이블 emp_copy1
create table emp_copy1
as select empno, ename, deptno, sal from emp
    where deptno = 10;
    
-- emp_copy2: emp 테이블과 dept 테이블을 inner join 해서 emp 테이블의 모든 컬럼과 부서이름, 위치 컬럼을 갖는 테이블
create table emp_copy2 as
    select e.*, d.dname, d.loc
    from emp e inner join dept d on e.deptno = d.deptno
    order by e.empno;
    
select * from emp_copy2;

-- create table-as select는 물리적인 테이블을 생성.
-- view: 가상 테이블. table 과는 달리 원 table에 수정이 생기면 view에도 반영됨. 일종의 링크
create view vw_emp_dept as
    select e.*, d.dname, d.loc
    from emp e join dept d on e.deptno = d.deptno
    order by e.empno;
    
select * from vw_emp_dept;