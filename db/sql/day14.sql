-- day13 EXTRA SOLV

CREATE TABLE board(
    bno NUMBER(6)
        CONSTRAINT BRD_NO_PK PRIMARY KEY,
    title VARCHAR2(50 CHAR)
        CONSTRAINT BRD_TITLE_NN NOT NULL,
    body VARCHAR2(4000)
        CONSTRAINT BRD_BODY_NN NOT NULL,
    bmno NUMBER(4)
        CONSTRAINT BRD_MNO_FK REFERENCES member(mno)
        CONSTRAINT BRD_MNO_NN NOT NULL,
    wdate DATE  DEFAULT sysdate
        CONSTRAINT BRD_DATE_NN NOT NULL,
    click NUMBER(6) DEFAULT 0
        CONSTRAINT BRD_CLICK_NN NOT NULL,
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT BRD_SHOW_CK CHECK (isShow IN ('Y', 'N'))
        CONSTRAINT BRD_SHOW_NN NOT NULL
);

----------------------------------------------------------------------------------------
-- day14

/*
    INDEX(인덱스)
    ==> 검색 속도를 빠르게 하기 위해서 B-TREE 구조로
        색인을 만들어서 SELECT 질의명령을 빠른 속도로 처리할 수 있도록 하는 것.
        
        참고 ]
            인덱스를 만들면 안되는 경우
                1. JOIN 등 많이 사용되는 필드가 존재하는 경우
                2. NULL 데이터가 많이 존재하는 경우
                3. WHERE 절에 많이 사용되는 필드가 존재하는 겨우
                
        참고 ]
            자동으로 인덱스를 만드는 경우
                1. 기본키 제약조건이 추가되는 경우
                2. 유일키 제약조건이 추가되는 경우
            
    만드는 형식 ]
        형식 1 ]
            일반 인덱스 만들기(NON UNIQUE INDEX)
            
            CREATE INDEX 인덱스이름
            ON
                테이블이름(인덱스에 사용할 필드이름);
            
            예 ]
                CREATE INDEX name_idx
                ON
                    emp(ename)
                ;
                ==>
                    이름을 이용해서 색인을 만들어 주세요...
                    이름으로 검색할 때 처리속도가 빨라진다.
            
            참고 ]
                일반 인덱스는 데인터가 중복되어도 상관이 없다.
                
        형식 2 ]
            UNIQUE 인덱스 만들기
            ==> 인덱스용 데이터가 반드시 유일(UNIQUE)하다는 보장이 있는 경우에 
                한해서 만드는 방법
                
                CREATE UNIQUE INDEX 인덱스이름
                ON
                    테이블이름(필드이름)
                ;
                
            ALTER TABLE memb01
            DROP CONSTRAINT MEMB01_MAIL_UK;
            
            예 ]
                회원원테이블(memb01)의 입사일을 이용해서 유니크 인덱스를 만드세요.
                
                CREATE UNIQUE INDEX membmail_idx
                ON
                    memb01(mail)
                ;
                
                CREATE UNIQUE INDEX tmp1name_idx
                ON
                    tmp1(ename)
                ;
                
                
            참고 ]
                지정한 필드의 내용은 반드시 유일하다는 보장이 있어야 한다.
                
            장점 ]
                일반 인덱스보다 처리속도가 빠르다.
                왜냐하면
                    이진 검색을 사용하기 때문이다.
                    
        형식 3 ]
            결합 인덱스
            ==> 여러개의 필드를 결합해서 하나의 인덱스를 만드는 방법
                이때 역시 전제 조건이 있는데
                여러개의 필드를 결합한 결과는 반드시 유일해야 한다.
                
                CREATE UNIQUE INDEX 인덱스이름
                ON
                    테이블이름(필드이름1, 필드이름2, ... )
                
                <== 하나의 필드만 가지고는 유니크 인덱스를 만들지 못하는 경우
                    여러개의 필드를 합쳐서 유니크 인덱스를 만들어서 사용하는 방법
                    
        형식 4 ]
            비트 인덱스
            ==> 주로 들어있는 데이턱 몇가지중 하나인 경우에 많이 사용되는 방법
            
            예 ]
                1. gender 필드에는 남성, 여성만 입력할 수 있다.
                
                2. deptno 의 경우 10,20, 30, 40 만입력할 수 있다.
                
            내부적으로 데이터를 이용해서 인덱스를 만들어서 사용하는 방법
            
            CREATE BITMAP INDEX 인덱스이름
            ON
                테이블이름(필드이름)
            ;
*/


-- EMP 테이블을 데이터까지 복사해서 TMP3 테이블을 만드세요.
CREATE TABLE tmp3
AS
    SELECT
        *
    FROM
        emp
;

-- 사원번호와 직급을 이용해서 결합 인덱스를 만드세요.
CREATE UNIQUE INDEX C_IDX
ON
    tmp3(empno, job)
;

CREATE UNIQUE INDEX C_IDX2
ON
    tmp3(ename, hiredate)
;

/*
    복합키 제약조건
    ==> 여러개의 필드를 동시에 결합해서 기본키로 사용하는 방법
*/

-- 사원번호와 이름을 이용해서 복합키 제약조건을 추가해주세요.
ALTER TABLE tmp3
ADD
    CONSTRAINT TMP3_CMPLX_PK PRIMARY KEY(empno, ename)
;

--------------------------------------------------------------------------------
/*
    사용자 관리
    ==> 관리자 모드에서 사용자에게 권하는 설정하는 방법
    
        계정이란?
        ==> 은행의 통장과 같은 개념이다.
            하나의 통장은 한사람이 사용할 수 있듯이
            계정은 한사람이 사용할 수 있는 가장 작은 단위의 데이터베이스이다.
    
        1. 사용자 만들기( 계정 만들기 )    - DDL 소속의 명령
            
            1) 관리자 계정으로 접속한다.
                가) sqlplus 의 경우
                        
                        sqlplus / as sysdba
                        
                나) sqldeveloper 의 경우
                    
                    Oracle 접속에서 system 계정의 접속을 만드고
                    그 계정으로 접속한다.
                    
                    
            2) 계정 만들기
                
                형식 ]
                    CREATE USER 계정이름 IDENTIFIED BY 비밀번호;
    
        ==> 이렇게 계정을 만들면
            계정만 만들 뿐이고 어떤 권한도 부여하지 않는 상태가 된다.
            따라서 사용할 수 있는 권한을 부여해 줘야한다.
            
        2. 권한 부여하기 - DCL 소속 명령
            
            형식 ]
                
                GRANT 권한이름  TO  부여할계정;
                
            참고 ]
                계정을 만들면 아무권한도 없는 상태로 
                계정만 만들게 된다.
                즉, 데이터베이스에 접속할 수 있는 권한 마저도 없는 상태로 
                계정이 만들어진다.
                따라서 접속하려면 접속할 수 있는 권한을 부여해야 한다.
                
                이 권한이 
                    CREATE SESSION
                이라는 권한이다.
                
            참고 ]
                session 이란?
                ==> 오라클에 접속해서 
                    오라클이 제공하는 것을 사용할 수 있는 권리를 이야기하며
                    오라클 에디션마다 가격이 달라지는 이유는
                    바로 이 세션의 개수에 따라 에디션이 구분이 되어있고
                    
                    이때 접속을 하게 되면
                    메모리에 작업할 공간을 할당을 받고
                    이 공간에서 dml 작업을 수행하게 된다.
                    
            권한 종류 ]
                SELECT, UPDATE, DELETE, ...
                CREATE TABLE    - 테이블을 만들 수 있는 권한
                CREATE SESSION  - 세션을 만들 수 있는 권한
                
                
                    
    
*/

-- test01이라는 이름의 계정을 비밀번호는 increpas 로 생성하세요.
CREATE USER testuser IDENTIFIED BY increpas;

-- 접속 할 수 있는 권한 부여
GRANT CREATE SESSION TO testuser;
-- ==> testuser 계정에게 SESSION 을 만들 수 있는 권한을 부여하세요.

-- 관리자 계정으로 전환후
-- TESTUSER 계정에게 CREATE TABLE 권한을 부여하자.
/*
    1. sqlplus 에서 system 계정으로 접속한다.
        1) cmd 창에서 접속하는 방법
            sqlplus system/increpas
            또는
            sqlplus / as sysdba
            
        2) 이미 다른 계정으로 접속되어 있는 경우는
            system 계정으로 접속을 전환해주면 된다.
            
            conn 또는  connect    system/increpas
            
    2. test01 유저에게 CREATE TABLE 권한을 부여한다.
        
        GRANT RESOURCE, CONNECT, CREATE TABLE TO test01;
        
    3. 어떤 테이블이던지 조회할 수 있는 권한을 
        test01 유저에게 부여한다.
        
        GRANT SELECT ANY TABLE TO test01;
        
    ==> 2 + 3
        
        GRANT RESOURCE, CONNECT, CREATE TABLE, SELECT ANY TABLE TO test01;
        
    4. test01 계정으로 접속 전환
        
        conn test01/increpas
        
    5. emp 테이블을 스캇계정이 가지고 있는 emp 테이블을 복사해서 만든다.
    
        CREATE TABLE emp
        AS
            SELECT
                *
            FROM
                scott.emp
        ;
        
    주의 ]
        계정을 만들거나 권한을 부여할 수 잇는 계정은 관리자계정이므로
        반드시 관리자 계정으로 접속되어있는지 확인해야 한다.
        
        역시 마찬가지로 테이블을 생성할 때도 
        해당 계정으로 접속이 되어있는지 확인후
        테이블을 만들어야 한다.
*/

-- scott 계정이 사용하는 테이블 스페이스 확인하기
SELECT
    *
FROM
    user_users
;

-- 테이블 스페이스 변경하기
ALTER USER 계정이름 DEFAULT TABLESPACE  테이블스페이스이름;

ALTER USER SCOTT DEFAULT TABLESPACE  USERS;
--------------------------------------------------------------------------------------------------------------------------
/*
    계정의 종류
        
        1. 관리자 계정
            SYSTEM, SYS, sysdba
            
            - 오라클 시스템을 관리 계정
            - 사용자를 생성, 수정, 권한 부여, 데이터베이스 생성, ...
            
            
        2. 일반 계정
            SCOTT, HR, TEST01, ...
            
            - 부여된 권한 내에서 작업을 한다.
                테이블 생성, 조회, 데이터삭제, 수정, 트랜젝션 작업,...
                
                
*/

--------------------------------------------------------------------------
/*
    권한을 줄때 사용되는 옵션
        
        WITH ADMIN OPTION
        ==> 관리자 권한을 위임 받도록 하는 옵션
*/

/*
    1. sqlplus 에서 system 계정으로 접속해서
    2. test02 계정을 만들고 (비번 : increpas)
    3. 테이블을 만들수 있는 권한을 부여하는데
        관리자 권한 까지 부여해보자.


*/


/*
    
    hello/increpas 계정을 만드세요.
    
    우리가 계정 만들어서 사용하는 방법
        1. 관리자 계정으로 접속한다.
        2. 계정을 만든다.
        3. 권한을 부여한다.
            
            GRANT RESOURCE, CONNECT, SELECT ANY TABLE TO 계정이름;
            
        4. 만든 계정으로 접속한다.
        
        5. SCOTT.emp 테이블을  복사해서 emp 테이블을 만든다.
            (bonus, dept, salgrade 테이블도 동일한 방법으로 복사한다.)
            
        -- SCOTT 계정의 emp, dept, salgrade, bonus 테이블의 제약조건을 확인하고
            복사한 테이블에 부여하세요.
*/

-- 1. system 계정에서 작업
-- 2.
-- drop user hello cascade;
CREATE USER hello IDENTIFIED BY increpas ACCOUNT UNLOCK;

-- 3.
GRANT RESOURCE, CONNECT, SELECT ANY TABLE TO hello;

-- 4.
CREATE TABLE emp
AS
    SELECT
        *
    FROM
        scott.emp
;

CREATE TABLE dept
AS
    SELECT
        *
    FROM
        scott.dept
;


CREATE TABLE salgrade
AS
    SELECT
        *
    FROM
        scott.salgrade
;

CREATE TABLE bonus
AS
    SELECT
        *
    FROM
        scott.bonus
;

ALTER TABLE emp
ADD
    CONSTRAINT HELLO_EMP_NO_PK PRIMARY KEY(empno)
;

ALTER TABLE dept
ADD
    CONSTRAINT HELLO_DEPT_NO_PK PRIMARY KEY(deptno)
;

ALTER TABLE emp
ADD
    CONSTRAINT HELLO_EMP_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno)
;

ALTER TABLE emp
MODIFY
    ename CONSTRAINT HELLO_EMP_NAME_NN NOT NULL
;

ALTER TABLE emp
MODIFY
    job CONSTRAINT HELLO_EMP_JOB_NN NOT NULL
;