/*
 블록 주석(block comment)
 - 파일 또는 코드에 대한 설명을 작성. 실행되지 않는 내용.
 *
 * SQL 문장 실행:
 * (1) - Ctrl+Enter: 하나의 명령문을 실행.
 *      - 현재 커서가 있는 위치의 한 문장을 실행.
 *      - 마우스 드래그로 선택된 문장(들)을 실행. 
 * (2) F5: 스크립트(sql 파일) 첫번째 줄부터 마지막 줄까지 순서대로 실행.
 *      - 스크립트 실행 중에 에러가 발생하면 그 이후의 명령문들은 실행되지 않음.
 
 * Alt+F10: 새 워크시트 만들기
*/
 
 -- inline comment(한줄 주석)
 -- 그 줄의 끝까지 주석.
 
 -- 현재 접속한 사용자 계정을 출력(검색).
select user
from dual;

-- DB 시스템의 현재 시간 정보를 출력(검색). 
select sysdate from dual;

-- SQL 키워드(예약어)는 대/소문자를 구분하지 않음.
-- SQL 문장은 세미콜론(;)으로 끝남.
SELECT SYSDATE FROM DUAL;
SELECT sysdate FROM dual;
select SYSDATE from DUAL;