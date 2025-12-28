# DQL(Data Query Language): select
from oracledb import DatabaseError

from src.oracleutil.connect import get_connection

def select_all():
    """"dept_ex 테이블의 모든 레코드를 검색해서 출력"""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = "select * from dept_ex"
                cursor.execute(sql)
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)


def select_by_deptno(deptno):
    """dept_ex 테이블에서 부서번호 deptno가 일치하는 레코드를 검색."""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = "select * from dept_ex where deptno = :id"
                cursor.execute(sql, id=deptno)
                #> sql 문장에서 :id를 아규먼트 deptno로 대체하고, 완성된 SQL 문장 실행.
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)


def select_by_dname(name):
    """dept_ex 테이블에서 dname 컬럼의 값이 아규먼트 name 문자열을 포함하는 레코드들을 검색."""
    with get_connection() as conn:
        with conn.cursor() as cursor:
            try:
                sql = "select * from dept_ex where upper(dname) like upper(:dept_name)"
                keyword = f'%{name}%'
                cursor.execute(sql, dept_name=keyword)
                # sql = f"select * from dept_ex where upper(dname) like upper('%{name}%')"
                # cursor.execute(sql)
                for row in cursor:
                    print(row)
            except DatabaseError as e:
                print(e)

if __name__ == '__main__':
    # select_all()
    # dno = int(input('부서 번호 입력>> '))
    # select_by_deptno(dno)
    select_by_dname('acc')