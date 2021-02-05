-- day15

/*
    WITH ADMIN OPTION
        ==> 권한을 줄때 관리자 권한 까지 주는 옵션
        
    -- system 계정으로 접속해서
    GRANT SELECT ANY TABLE TO hello WITH ADMIN OPTION;
    
    ------------------------------------------------------------------------------
    
    3. 특정 계정의 테이블을 조회할 수 있는 권한
        ==> 원칙적으로 하나의 계정은 그 계정에 존재하는 테이블만 사용할 수 있다.
        
            하지만 여러계정들이 다른 계정의 테이블을 공동으로 사용할 수 잇다.
            이렇게 사용하려면 권한을 설정 해줘야 한다.
            
            형식 ]
                GRANT 권한이름 ON   계정이름.테이블이름 TO   계정이름;
                
    ------------------------------------------------------------------------------
    -- SYSTEM 계정으로 접속해서 작업
    
        GRANT select, update, delete ON hr.employees TO hello;
    ------------------------------------------------------------------------------
    
    4. 관리자에게서 부여받은 권한을 다른 계정에게 전파하기
        
        형식 ]
            GRANT   권한  TO      계정이름
            WITH GRANT OPTION;
            
    ------------------------------------------------------------------------------
    -- SYSTEM 계정으로 접속해서 작업
    
        GRANT select ON hr.employees TO hello
        WITH GRANT OPTION
        ;
    ------------------------------------------------------------------------------
    hello 계정에서
    
        GRANT select ON hr.employees TO test01;
    
    -------------------------------------------------------------------------------
    test01로 접속후 실행
        SELECT * FROM hr.emplyees;
    
    ==> 107행의 결과가 조회
    
------------------------------------------------------------------------------------
    사용자 권한 수정하기
        
        GRANT 명령을 이용해서 필요한 권한을 관리자가 부여해주면 된다.
        
------------------------------------------------------------------------------------
    사용자 권한 회수하기
        
        형식 ]
            
            REVOKE  회수할권한    FROM    계정이름;
            
-------------------------------------------------------------------------------------
    
    사용자 삭제하기
    ==> 
        관리자 계정으로 접속해서
        
        DROP USER   계정이름    CASCADE;
        
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
롤을 이용한 사용자 권한 부여
==> 
    롤 이란?
        여러권한들을 묶어놓은 객체(권한들의 묶음)를 의미하는 용어
    
        따라서 롤을 사용한 권한 부여란?
        여러개의 권한을 동시에 부여하는 방법이다.
        
    1. 이미 만들어져 있는 롤을 이용하는 방법
        1) CONNECT
            ==> 데이터베이스 접속과 주로 CREATE와 관련된 권한을 모아 놓은 롤
            
        2) RESOUCE
            ==> 사용자 객체 생성에 권한을 모아 놓은 롤
            
        3) DBA
            ==> 관리자 계정에서 처리할 수 있는 관리자 권한을 모아 놓은 롤
            
            
        형식 ]
            
            GRANT 롤이름, 롤이름, ... TO  계정이름;
            
            참고 ]
                일반 권한들과 같이 나열해서 부여할 수 있다.
        
    2. 직접 만들어서 사용하는 방법
        ==> 롤 안에 필요한 권한을 사용자가 지정한 후 사용하는 방법
        
        형식 ]
            
            *****
            만드는 단계를 기억해주자.
            
                1. 롤을 만든다.
                    형식 ]
                        CREATE ROLE 롤이름;
                        
                2. 롤에다 권한을 부여한다.
                    형식 ]
                        GRANT    권한이름, 권한이름, ... TO 롤이름;
                
                3. 계정에게 권한을 부여할 때 롤로 부여한다.
                    형식 ]
                        
                        GRANT 롤이름   TO  계정이름;
                        
-----------------------------------------------------------------------------------------
실습과정 ]
    
    1. SYSTEM(관리자계정) 으로 접속해서
        
        DROP USER test01 CASCADE;
        DROP USER testuser CASCADE;
        
    2. test01 계정을 다시 만든다.
        
        CREATE USER test01 IDENTIFIED BY increpas;
        
    3. rl01 이라는 롤을 만든다.
        
        CREATE ROLE rl01;
        
    4. rl01 롤에 resource, connect, select any table 권한을 부여한다.
        
        GRANT resource, connect, select any table TO rl01;
        
    5. test01 계정에게 rl01 롤 권한을 부여한다.
        
        GRANT rl01 TO test01;
        
    6. test01 계정으로 접속해서
    
        conn test01/increpas
        
        SELECT * FROM hello.emp;


-----------------------------------------------------------------------------------------
    롤 회수하기
        형식 ]
            REVOKE  롤이름     FROM    계정이름;
        
-----------------------------------------------------------------------------------------
    롤 삭제하기
        
        형식 ]
            DROP ROLE 롤이름;
*/

GRANT UPDATE ANY TABLE, DELETE ANY TABLE TO hello;

GRANT SELECT ANY TABLE TO testuser;

REVOKE SELECT ANY TABLE FROM testuser; -- 권한 회수 명령
------------------------------------------------------------------------------
REVOKE SELECT ANY TABLE FROM hello;

-- 권한 확인
SELECT
    *
FROM
    hr.employees
;

GRANT select ON hr.employees TO testuser;

---------------------------------------------------------------------------------
/*
    동의어( SYNONYM )
    ==> 테이블 자체에 별칭을 부여해서 여러 사용자가 
        각각의 이름으로 하나의 테이블을 사용하도록 하는 것.
        
        즉, 실제 객체(테이블, 뷰, 시퀀스, 프로시저) 이름은 감추고
        사용자에게 만들어진 별칭을 이용하게해서
        객체를 보호할 수 있도록 하는 방법
        
        우리가 포털사이트에서 우리의 이름 대신에 ID를 사용하는 것과 
        마찬가지로 정보 보호를 목적으로 실제 이름을 감추기 위한 방법
        
        
        주로 다른 계정을 사용하는 사용자가
        테이블 이름을 알면 곤란하기 때문에
        이들에게는 거짓 테이블 이름을 알려줘서
        실제 테이블 이름을 감추기 위한 목적으로 사용.
        
        ------------------------------------------------------------
        참고 ]
            우리 수업에서 사용하는 범위의 기호
                ()  - 소괄호, 매개변수, 연산단위를 묶는 경우
                
                {}  - 중괄호, 블럭을 의미, 실제 실행되어야 할 코드들이 작성되는 곳.
                
                []  - 대괄호, 배열을 의미, 형식 설명시 생략해도 무방한 것을 의미
                
        ------------------------------------------------------------
        
        형식 ]
            CREATE  [ PULIC ] SYNONYM   동의어이름
            FOR     실제이름;
            
            [ PUBLIC ]  - 생략되면 이 동의어는 같은 계정에서만 사용하는 동의어가 된다.
                            ( 권한을 부여하면 다른 계정에서도 사용할 수는 있다.)
                            
                            이 키워드가 사용되면 자동적으로 다른 계정에서도 
                            이 동의어를 이용해서 테이블을 사용할 수 있게 된다.
                            
        ------------------------------------------------------------
        ==> system 계정으로 접속해서 작업
            
            GRANT create synonym TO hello;
        -------------------------------------------------------------
*/

CREATE SYNONYM sy01
FOR hr.employees;

SELECT
    *
FROM
    sy01
;

----------------------------------------------------------------------
/*
    PUBLIC 동의어 만들기
        
        ==> 모든 계정에서 특정 객체(테이블, 뷰, 시퀀스, ...)를 사용할 수 있도록 하는 것.
        
        참고 ]
            PUBLIC 동의어를 사용하기 위해서는
            해당 객체가 PUBLIC 사용 권한을 할당 받아야 한다.
            
    ----------------------------------------------------------------------------
    
    1. 
    system 계정으로 접속후 작업
        GRANT select ON scott.emp   TO public;
    
    또는
    scott 계정으로 접속 후 
        
        GRANT SELECT ON emp TO public;
        
    1-1.
        system 계정에서
        scott 계정에게 
        public synonym을 만들 수 있는 권한을 부여한다.
        
            GRANT CREATE PUBLIC SYNONYM TO scott;
            
            GRANT SELECT ON SCOTT.EMP TO hello;
            
    2. 
        1)
        system 계정으로 만드는 방법
        
        public 동의를 만들어준다.
        
        CREATE PUBLIC SYNONYM all_emp
        FOR scott.emp;
        
        2) scott 계정에서 만드는 방법
            CREATE PUBLIC SYNONYM all_emp
            FOR emp;
            
    3. test01 계정으로 접속 후
        
        select * from all_emp;
    ----------------------------------------------------------------------------
    
            
            
*/

select * from scott.emp;

---------------------------------------------------------------------------------
/*
    PL/SQL(Procedual Language/SQL)
    ==> 자바의 프로그램처럼
        오라클에서 사용하는 질의 명령 여러개 모아서
        순차적으로 실행시키는 일종의 프로그램을 말한다.
        
        
        장점 ]
            1. 프로그램화 해서 다수의 sql을 수행하게 함으로
                수행속도를 샹상 시킬 수 있다.
            2. 모듈화(부품화)가 가능하여 필요한 기능만 골라서
                여러개의 프로그램을 연결해서 사용할 수 있다.
                ==> 질의 명령을 제작함 에 있어서 편리하다.
                
            3. 동적 변수를 사용할 수 있기 때문에
                변경된 데이터를 이용해서 질의 명령을 수행하도록 할 수 있다.
                
                예 ]
                    
                    10 번 부서 소속의 사원들의 이름, 직급을 조회하세요.
                        SELECT
                            ename, job
                        FROM
                            emp
                        WHERE
                             deptno = 10
                        ;
                    20 번 부서 소속의 사원들의 이름, 직급을 조회하세요.
                        SELECT
                            ename, job
                        FROM
                            emp
                        WHERE
                             deptno = 20
                        ;
                ==> 동일한 질의 명령은 한번만 만든후
                    데이터만 바꿔서 실행 할 수 있다.
            4. 예외 처리가 가능하여 문제가 발생할 경우
                이것을 수정 처리할 수 있다.
                
    종류 ]
        1. 무명(익명) 프로시저
        ==> 질의명령을 모아놓은 후 프로그램이 완료되면
            즉각 실행할 수 있는 PL/SQL을 말한다.
            
            참고 ]
                sql 스크립트 파일 직접 실행하는 방법
                
                형식 ]
                    
                    @파일경로\( 또는 /)파일이름
                    
        2. 일반(저장) 프로시저
        ==> 프로시저 이름을 부여한 것을 이야기하고
            필요할 때 선택해서 실행할 수 있는 PL/SQL을 말한다.
            오라클에 객체로써 등록이 된다.
        
        3. FUNCTION(함수)
        ==> 우리가 알고있는 함수를 이야기하고
            사용자가 만든 함수를 의미한다.
            나중에 질의 명령을 처리할 때 
            그 질의 명령에 포함 시켜서 사용하는 PL/SQL 을 말한다.
        
        4. 기타 프로시저
        ==> 트리거, 스케줄러, ....
            특별한 기능을 가진 PL/SQL을 말한다.
            
    *****************************************************************
    PL/SQL 의 전체적인 구조
        
        DECLARE
            선언부(프로그램에서 필요한 변수나, ... 을 선언하는 부분)
        BEGIN
            실행부(실제 필요한 질의명령을 만들고 이것을 제어하는 부분)
        [EXCEPTION
            예외처리부분]
        END;
        /
        
    참고 ]
        sqlplus 에서 프로시저 메세지를 확인 하는 방법
        
        SET SERVEROUPUT ON  -- sqlplus 명령 ==> 따라서 세미콜론(;)  이 필요하지 않다.
        
        
    1. 무명(익명) 프로시저
        
        형식 ]
            
            DECLARE
                x NUMBER;   -- 이 부분을 우리는 "변수 선언"이라고 한다.
            BEGIN
                x := 1000;  -- 대입명령
                
                DBMS_OUTPUT.PUT_LINE('결과 = ');  -- 콘솔 화면에 '결과 = ' 이라는 문자열을 출력해준다.
                DBMS_OUTUPT.PUT_LINE(x);    -- 콘솔화면에 변수를 출력해준다.
            END;
            /
               
               
        참고 ]
            ==> DBMS_OUTPUT.PUT_LINE() 는 출력명령이다.
                항상 출력이 가능한 것이 아니고
                sqlplus가 출력 가능한 상태여야 결과가 출력이 된다.
                
                따라서 sqlplus를 출력 가능한 상태로 만들어주는 명령
                
                set serveroutput on
                
                
                
    무명 프로시저 사용방법    
        
        1. 프로시저를 만들어서 sql 파일로 저장해 놓는다.
            이때 확장자는 중요하지 않다.
            하지만 확장자는 되도록이면 .sql 로 만들어서 사용하세요.
            
        2. sqlplus 에서 저장된 파일을 실행한다.
            
            1) @파일경로\파일이름
                ==> 실행만 시켜준다.
                
            2) run 파일경로\파일이름
                ==> 소스를 보여주고 실행시켜준다.
                
                
                
            3) GET 파일경로\파일이름
                ==> 소스만 보여준다.
    
    2. 일반 프로시저 만들기
        -- 실습을 위해서 emp 테이블을 복사해서 tmp1 테이블을 만들어두자.
        
        CREATE TABLE tmp1
        AS
            SELECT * FROM emp;
        
        -- 10번 부서 사원들의 급여를 10% 인상하는 프로시저를 만들자.
        
        CREATE OR REPLACE PROCEDURE upsal01
        AS
        BEGIN
            UPDATE
                tmp1
            SET
                sal = sal * 1.1
            WHERE
                deptno = 10
            ;
            
            commit;
            
            DBMS_OUTPUT.PUT_LINE('10번 부서원 급여 10% 인상 완료');
            
        END;
        /
        
        rollback;
        SELECT * FROM tmp1;
        
        -- tmp1 테이블을 조회한다.
        SELECT * FROM tmp1;
        
        -- 프로시저를 실행시킨다.
        실행방법 ]
            execute 프로시저이름(파라미터);
            또는
            exec 프로시저이름(파라미터);
            
        exec upsal01;
            
        -- tmp1 테이블을 조회한다.
        SELECT * FROM tmp1;
        
        rollback;
        
        SELECT * FROM tmp1;
        
        
    3. FUNCTION(함수) 만들기
        ==> 함수는 오라클 내부에 함수를 저장한 후
            다른 질의 명령을 사용할 때 부가적으로 사용하는 것.
            
            예 ]
                연봉을 보여주는 함수가 totalsal 이라는 이름으로 저장이 되어있는 경우
                사원들의
                    사원이름, 직급, 급여, 연봉
                을 조회할 경우
                
                SELECT
                    ename, job, sal, totalsal(sal, comm)
                FROM
                    TMP1
                ;
                
        예 ]
            CREATE OR REPLACE FUNCTION test_func
            RETURN NUMBER AS
                x NUMBER;
            BEGIN
                
                x := 999;
                RETURN x;
            END;
            /
            
            ==> 사용
            SELECT test_func() FROM dual;
            
    참고 ]
        ==> 위 3가지는 혼합해서 사용할 수 있다.
        
        1. 무명 안에 함수를 포함해서 만든 방법
            @D:\class\db\git\11gxe\db\sql\exec\test01.sql
        
        2. 무명 안에 일반 프로시저를 포함해서 만드는 방법
        
            @D:\class\db\git\11gxe\db\sql\exec\test02.sql
        
        3. 무명 프로시저 안에 무명 프로시저를 포함해서 만드는 방법
            @D:\class\db\git\11gxe\db\sql\exec\test03.sql
-----------------------------------------------------------------------------------

*/
set serveroutput on;        



----------------------------------------------------------------------------------------

/*
    몸풀기 문제 1 ]
        
        사원 정보 테이블에서 직급별 최고급여를 조회하는데
            
            직급, 직급최고급여
        가 조회되도록 질의명령을 작성하세요.
*/
SELECT
    job 직급, MAX(sal) 직급최고급여
FROM
    emp
GROUP BY
    job
;
/*
    문제 2 ] 서브질의로 해결하세요.
        직급별 최고 급여자의
            사원이름, 직급, 급여, 직급최고급여
        를 조회하세요.
*/
SELECT
    ename 이름, job 직급, sal 급여, 
    (
        SELECT
            MAX(sal)
        FROM
            emp
        GROUP BY
            job
        HAVING
            job = e.job
    ) 직급최고급여
FROM
    emp e
WHERE
    sal = (
                SELECT
                    MAX(sal)
                FROM
                    emp
                GROUP BY
                    job
                HAVING
                    job = e.job
            )
;
/*
    문제 3 ] 문제 2번을 조인을 사용해서 처리하세요.
*/


CREATE TABLE tsal
AS
    SELECT
        job, MAX(sal) max
    FROM
        emp
    GROUP BY
        job
;

SELECT * FROM tsal;

SELECT
    ename 이름, e.job 직급, sal 급여, max 직급최대급여
FROM
    emp e, tsal t
WHERE
    e.job = t.job 
    AND sal = max
;

SELECT
    ename 이름, e.job 직급, sal 급여, max 직급최대급여
FROM
    emp e, 
    (
        SELECT
            job, MAX(sal) max
        FROM
            emp
        GROUP BY
            job
    ) t
WHERE
    e.job = t.job 
    AND sal = max
;

UPDATE
    emp
SET
    sal =   (
                SELECT
                    sal
                FROM
                    scott.emp
                WHERE
                    ename = 'JONES'
            )
WHERE
    ename = 'JONES'
;

COMMIT;