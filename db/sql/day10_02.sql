-- day10_02

/*
    NOT NULL 제약 조건은
    컬럼레벨에서 정의하는 것은 가능하지만
    테이블 레벨에서 정의하는 것은 불가능하다.
    <=== 이미 컬럼이 만들어져 있으면
         그 컬럼은 NULL 데이터를 허용하는 속성으로(기본값) 정의가 되어있기 때문에...
*/

CREATE TABLE tmp5(
    mno NUMBER(4),
    name VARCHAR2(15 CHAR),
    age NUMBER(3),
    mail VARCHAR2(30 CHAR)
);

INSERT INTO 
    tmp5(name)
VALUES(
    '홍길동'
);

DROP TABLE TMP5;

/*
     2. 이미 만들어진 테이블에 제약조건을 추가하는 방법
        1) 명시적 제약 조건을 추가하는 방법
            형식 ]
                ALTER  TABLE 테이블이름
                ADD 
                    CONSTRAINT 제약조건이름   제약조건정의;
                
                ***  
                참고 ]
                    NOT NULL 제약조건의 경우
                    
                    ALTER TABLE 테이블이름
                    MODIFY 컬럼이름
                        CONSTRAINT 제약조건이름 제약조건정의;
                    
        2) 무명 제약 조건 등록하는 방법
            
            형식 ]
                ALTER TABLE 테이블이름
                ADD 제약조건(컬럼이름);
                
    참고 ]
        제약조건 이름 변경하기
        
            형식 ]
                ALTER TABLE 테이블이름
                RENAME CONSTRAINT 기존이름 TO 변경될이름;
    
    ***
    이미 만들어진 테이블에 NOT NULL 제약 조건 추가하는 방법
        형식 1 ]        
            ALTER TABLE 테이블이름
            MODIFY 컬럼이름 NOT NULL;
        
        형식 2 ]
            ALTER TABLE 테이블이름
            MODIFY 컬럼이름
                CONSTRAINT 제약조건이름  NOT NULL;
*/

CREATE TABLE tmp5(
    mno NUMBER(4),
    name VARCHAR2(15 CHAR),
    age NUMBER(3),
    mail VARCHAR2(30 CHAR)
);

-- MNO에 기본기 제약 조건 추가(무명)
ALTER TABLE tmp5
ADD PRIMARY KEY(mno);

-- 이름을 TMP5_NO_PK로 위의 제약조건의 이름 변경
ALTER TABLE tmp5
RENAME CONSTRAINT SYS_C0011500 TO TMP5_NO_PK;

-- NAME 에 NOT NULL 제약조건 추가

ALTER TABLE tmp5
MODIFY name NOT NULL;

ALTER TABLE tmp5
RENAME CONSTRAINT SYS_C0011501 TO TMP5_NAME_NN;

ALTER TABLE tmp5
MODIFY age
    CONSTRAINT TMP5_AGE_NN NOT NULL;


-- TMP6

CREATE TABLE tmp6(
    mno NUMBER(4),
    name VARCHAR2(15 CHAR),
    age NUMBER(3),
    mail VARCHAR2(30 CHAR)
);


-- TMP6.MNO 에 TMP6_NO_PK라는 이름으로 기본키 제약조건 추가
-- 이미 만들어진 테이블에 명시적으로 제약조건을 추가하는 방법
ALTER TABLE tmp6
ADD
    CONSTRAINT TMP6_NO_PK PRIMARY KEY(mno)
;

-- tmp6 테이블의 name, age 컬럼에 not null 제약조건을 명식적 방법으로 추가하세요.
-- 제약 조건 이름은 
--          TMP6_NAME_NN, TMP6_AGE_NN
ALTER TABLE tmp6
MODIFY name 
    CONSTRAINT TMP6_NAME_NN NOT NULL
;

ALTER TABLE tmp6
MODIFY age 
    CONSTRAINT TMP6_AGE_NN NOT NULL
;

-- 부서 번호 컬럼 추가
ALTER TABLE tmp6
ADD (
    dno NUMBER(2)
);

/*
    TMP6 테이블의 DNO 컬럼에
    TMP6_DNO_NN 이라는 이름으로 NOT NULL 제약조건을
    TMP6_DNO_FK 라는 이름으로 참조키 제약조건을 부여하세요.
    단, 참조 테이블과 컬럼은 DEPT테이블의 DEPTNO 컬럼을 참조합니다.
*/

ALTER TABLE tmp6
ADD 
    CONSTRAINT TMP6_DNO_FK FOREIGN KEY(dno) REFERENCES dept(deptno)
;

ALTER TABLE tmp6
MODIFY dno
    CONSTRAINT TMP6_DNO_NN NOT NULL;
    
-------------------------------------------------------------------
/*
    등록된 제약조건 확인하는 방법
    ==> 등록된 제약 조건은 오라클이 테이블을 이용해서 관리하고 있다.
        이 테이블이름이
            USER_CONSTRAINTS
        이다.
        
        따라서 이 테이블의 내용을 확인하면 등록된 제약조건을 확인할 수 있다.
        
        형식 ]
            
            SELECT
                *
            FROM
                user_constraints
            ;
        
         참고 ]
            USER_CONSTRAINTS 테이블의 컬럼
                
                OWNER               - 제약조건 소유자(계정)
                CONSTRAINT_NAME     - 제약조건 이름
                TABLE_NAME          - 테이블이름
                CONSTRAINT_TYPE 
                    무결성 제약조건 형태를 나타내는 부분
                        
                        P   - PRIMARY KEY
                        R   - FOREIGN KEY
                        U   - UNIQUE
                        C   - CHECK 또는 NOT NULL
                     
        주의 ]
            제약 조건을 조회할 때
            테이블이름은 무조건 대문자로 기억이 되기 때문에
            문자형태의 대문자로 조건을 검색해야 한다. 
                
*/
    
-- TMP6테이블에 추가된 제약조건 조회
SELECT
    constraint_name 제약조건이름, table_name 테이블이름
FROM
    user_constraints
WHERE
    table_name = 'TMP6'
;

/*
    제약 조건 삭제하기
        
        형식 ]
            ALTER TABLE 테이블이름
            DROP CONSTRIANT 제약조건이름;
            
        참고 ]
            기본기제약조건(PRIMARY KEY)의 경우 이름을 몰라도 삭제할 수 있다.
            이유는
                기본키 제약조건은 테이블에 한개만 추가할 수 있기 때문이다.
                
            삭제형식 ]
                ALTER TABLE 테이블이름
                DROP PRIMARY KEY;
*/


-----------------------------------------------------------------------------------------------------------
--TMP6의 TMP6_DNO_FK 제약조건을 삭제하세요.
ALTER TABLE tmp6
DROP CONSTRAINT TMP6_DNO_FK;

-- DEPT 테이블을 복사해서 BUSEO 테이블을 만들자
CREATE TABLE buseo
AS
    SELECT
        *
    FROM
        dept
;

-- tmp6 테이블의 dno 컬럼이 buseo 테이블의  deptno 컬럼을 참조하는 
-- 참조키 제약조건을 추가하자.
ALTER TABLE tmp6
ADD
    CONSTRAINT TMP6_DNO_FK FOREIGN KEY(DNO) REFERENCES buseo(deptno);
    
-- <== 제약조건을 추가할 수 없는 이유는 참조할 컬럼은 기본키거나 유일키 여야하기 때문에....

-- buseo 테이블의 deptno 컬럼에 유일키 제약조건을 추가해보자.
ALTER TABLE buseo
ADD
    CONSTRAINT BUSEO_NO_UK UNIQUE(deptno);

-- TMP6.DNO 에 참조키 제약조건 추가
ALTER TABLE tmp6
ADD
    CONSTRAINT TMP6_DNO_FK FOREIGN KEY(DNO) REFERENCES buseo(deptno);


------------------------------------------------------------------------------------------------
/*
    문제 ]
        거래처 사람들의 데이터를 관리할 목적으로 테이블을 만들 예정이다.
        거래처 사람들의 정보는
            이름, 회사, 부서, 직급, 전화번호, 생일, 주소
        를 저장할 예정이다.
        
        1. 테이블을 설계를 하고 (ER Model, ER Digram, 테이블명세서)
        2. DDL 명령을 만들어서 테이블을 구현하고
        3. 제약조건도 부여하세요.
        (
            테이블을 만들면서 추가하는 방법, 
            테이블을 만든후 추가하는 방법
        )
        
        extra ] 그리고 데이터도 추가해주세요.
        
    제출 ]
        메일 주소 : euns_jun@naver.com
        제출 파일 : ER Model, ER Diagram, ===> JPG
                    테이블명세서,         ==> EXCEL
                    sql 질의명령(DDL + INSERT DML)  ==> SQL
                    
        파일 4개를 하나의 ZIP 파일로 압축해서 제출하세요.
        
*/

-------------------------------------------------------------------------------------------

CREATE TABLE cpu_co(
    ccno NUMBER(2)
        CONSTRAINT CPUCO_NO_PK PRIMARY KEY,
    cname VARCHAR2(20 CHAR)
        CONSTRAINT CPUCO_NAME_UK UNIQUE
        CONSTRAINT CPUCO_NAME_NN NOT NULL
);

-- 컴퓨터 테이블 만들기
CREATE TABLE com(
    cno NUMBER(2),
    cpu VARCHAR2(30 CHAR),
    cpu_co NUMBER(2),
    cpu_speed VARCHAR2(20 CHAR),
    ram VARCHAR2(20 CHAR),
    gpu VARCHAR2(50 CHAR),
    qt NUMBER(2),
    bdate CHAR(7),
    isShow CHAR(1) DEFAULT 'Y'
);

-- 제약조건 추가
-- NOT NULL 제약조건 추가
ALTER TABLE com
MODIFY 
    cpu CONSTRAINT COM_CPU_NN NOT NULL
;

ALTER TABLE com
MODIFY 
    cpu_co CONSTRAINT COM_CPUC0_NN NOT NULL
;

ALTER TABLE com
MODIFY 
    cpu_speed CONSTRAINT COM_CPUSPD_NN NOT NULL
;
ALTER TABLE com
MODIFY 
    ram CONSTRAINT COM_RAM_NN NOT NULL
;
ALTER TABLE com
MODIFY 
    qt CONSTRAINT COM_QT_NN NOT NULL
;
ALTER TABLE com
MODIFY 
    isShow CONSTRAINT COM_SHOW_NN NOT NULL
;

-- 기본키 제약조건 추가
ALTER TABLE com
ADD
    CONSTRAINT COM_NO_PK PRIMARY KEY(cno)
;
-- 참조키 제약조건 추가
ALTER TABLE com
ADD 
    CONSTRAINT COM_CPUCO_FK FOREIGN KEY(cpu_co) REFERENCES cpu_co(ccno)
;
-- 체크 제약조건 추가
ALTER TABLE com
ADD
    CONSTRAINT COM_SHOW_CK CHECK (isShow IN ('Y', 'N'))
;

---------------------------------------------------------------------------------------------------
/*
    데이터 입력의 경우도 
    참조할 테이블의 데이터부터 입력해줘야 한다.
    따라서 CPU 제조회사 데이터부터 입력해줘야 한다.
*/
INSERT INTO 
    cpu_co
VALUES(
    (
        SELECT 
            NVL(
                MAX(ccno) + 1,
                11
            )
        FROM
            cpu_co
    ),
    'INTEL'
);

INSERT INTO 
    cpu_co
VALUES(
    (
        SELECT 
            NVL(
                MAX(ccno) + 1,
                11
            )
        FROM
            cpu_co
    ),
    'AMD'
);
INSERT INTO 
    cpu_co
VALUES(
    (
        SELECT 
            NVL(
                MAX(ccno) + 1,
                11
            )
        FROM
            cpu_co
    ),
    'ARM'
);

-- 컴퓨터 테이블 데이터 입력
INSERT INTO 
    com(
        cno, cpu, cpu_co, cpu_speed, ram, qt
    )
VALUES(
    (
        SELECT
            NVL(
                MAX(cno) + 1,
                1
            )
        FROM
            com
    ),
    'pentium pro',
    11, '180MHz', '8MByte', 1
);

INSERT INTO 
    com(
        cno, cpu, cpu_co, cpu_speed, ram, qt, bdate
    )
VALUES(
    (
        SELECT
            NVL(
                MAX(cno) + 1,
                1
            )
        FROM
            com
    ),
    'i7', 11, '2.9GHz', '16GByte', 1, '2018.03'
);

