-- day10

/*
    2. 개체 수정하기
        형식 ]
            ALTER 개체타입 개체이름
            명령...
            ;
        
        
        1) 테이블 이름 변경하기
            형식 ]
                ALTER TABLE 테이블
                RENAME TO 변경할이름;
                
        2) 테이블의 컬럼 추가하기
            
            형식 ]
                ALTER TABLE 테이블이름
                ADD (
                    컬럼이름 데이터타입(최대길이)
                        CONSTRAINT 제약조건추가
                );
                
        3) 테이블의 컬럼의 최대길이를 변경하기
            
            형식 ]
                ALTER TABLE 테이블이름
                MODIFY
                    필드이름    데이터타입(변경할최대크기);
                    
            참고 ]
                최대길이를 변경하는 경우
                현재 길이보다 크게 늘리는 경우는 가능하지만
                현재 길이보다 작게 줄이는 경우는 불가능하다.
                <=== 현재 데이터가 줄어들 길이보다 클 수 있기 때문에...
                
                
        4) 컬럼 삭제하기
            
            형식 ]
                ALTER TABLE 테이블이름
                DROP COLUMN 컬럼이름;
    
*/

-- COMP 테이블의 이름을 COMPANY 로 변경하자.
ALTER TABLE
    comp
RENAME TO company;

-- company 테이블의 이름을 comp 로 변경하세요.

ALTER TABLE
    company
RENAME TO comp;

/*
    테이블의 구조를 바꾸거나 새로운 테이블을 만들거나 삭제할 경우에는
    개체에 관련된 작업이므로 
    DDL 명령으로 처리해야 한다.
*/

-- comp 테이블의 isshow 컬럼명을 show로 변경하세요.
/*
    컬럼의 이름을 병경하는 명령
        형식 ]
            ALTER TABLE
                테이블이름
            RENAME COLUMN 컬럼이름 TO 변경될이름;
*/
ALTER TABLE
    comp
RENAME COLUMN isshow TO show;

ALTER TABLE
    comp
RENAME COLUMN show TO isshow;

/*
    3. 개체 삭제하기
        ==> 개체를 데이터베이스에서 완전히(?) 삭제하는 명령
        
        형식 ]
            DROP 개체타입 개체이름;
            
        1) 테이블 삭제하기
            
            참고 ]
                테이블을 삭제하면 테이블 내의 데이터도 동시에 모두 삭제된다.
                
            형식 1 ]
                DROP TABLE 테이블이름;
                
            형식 2 ]
                DROP TABLE 테이블이름 PURGE;
                ==> 휴지통에 넣지 말고 완전히 즉시 삭제하세요.
                
                
            참고 ]
                DML 명령은 복구가 가능하지만
                DDL 명령은 복구가 원칙적으로 불가능하다.
                
            참고 ]
                오라클의 경우 10g 버젼 부터 휴지통 개념을 도입해서
                삭제된 테이블을 휴지통에 보관하도록 하고 있다.
                
            휴지통 관리 ]
                1. 휴지통에 있는 모든 테이블 완전히 지우기
                    
                    PURGE RECYCLEBIN;
                    
                2. 휴지통에 있는 특정  테이블만 완전히 삭제하기
                    
                    PURGE TABLE 테이블이름;
                    
                3. 휴지통 확인하기
                    
                    SHOW RECYCLEBIN;
                    
                4. 휴지통에 버린 테이블 복구하기
                    
                    FLASHBACK TABLE  테이블이름 TO BEFORE DROP;
                    
-----------------------------------------------------------------------------------------------------------
    참고 ]
        TRUNCATE
        ==> DML 명령중 데이터 삭제하는 명령 DELETE 명령과 비슷한 명령이다.
        
        형식 ]
            TRUNCATE TABLE 테이블이름;
            
        참고 ]
            DELETE  명령은 DML 소속의 명령이고
            TRUNCATE 명령은 DDL 소속의 명령이다.,
            
            따라서
            DELETE 명령은 복구가 가능하지만
            TRUNCATE 명령은 복구가 불가능하다.
*/

-- COMP 테이블을 복사해서 TMP 테이블을 만들자.
CREATE TABLE tmp
AS
    SELECT * FROM comp;
-- >>>> AS 절의 결과를 가지고 TMP 테이블을 만들어 주세요...

-- tmp 테이블의 데이터를 잘라내보자.
TRUNCATE TABLE tmp;


-------------------------------------------------------------------------------------------------------------
/*
    무결성 체크
    ==> 데이터베이스는 프로그램등 전산에서 작업할 때 
        필요한 데이터를 제공해주는 보조 프로그램이다.
        따라서 데이터베이스가 가지고 있는 데이터는 완벽한 데이터여야만 한다.
        하지만 데이터를 입력하는 것은 사람의 몫이고
        그러므로 완변한 데이터를 보장할 수 없게 된다.
        
        각각의 테이블에 들어가서는 안될 데이터나 빠지면 안되는 데이터등을
        미리 결정해 놓음 으로써
        데이터를 입력하는 사람이 잘못 입력하면
        그 데이터는 입력받지 못하도록 방지하는 역학을 하는 기능
        
        따라서 이 기능은 반드시 필요한 기능은 아니다.
        (==> 입력하는 사람이 정신차리고 정확하게 입력하면 필요없는 기능이다.)
        실수를 미연에 방지할 수 있도록 하는 기능이다.
        
        ***
        결론적으로 데이터베이스의 이상현상을 방지하는 기능이다.
        데이터가 결함이 없는 상태를 유지하도록 하는 기능
        
    이때 정의해놓는 것이 제약조건이다.
    
    종류 ]
        
        NOT NULL        - NN
        ==>  해당 컬럼은 반드시 데이터가 존재해야 되는 컬럼임을 밝히는 것
             이 무결성 체크가 있는 컬럼에 데이터가 입력되지 않으면
             해당 행은 입력을 못하도록 막는 제약조건
             
        DEFAULT
        ==> 만약 입력하는 사람이 입력하지 않으면
            기본값으로 입력되도록 강제하는 기능
            
        UNIQUE          - UK
        ==> 해당 컬럼의 데이터는 반드시 다른 행의 데이터와 구부될 수 있어야 한다는 조건
            즉, 같은 데이터가 다시 입력되면 입력을 못하도록 막는 기능
            대신 NULL 은 허락한다.
            
        PRIMARY KEY     - PK
        ==> 기본키
            UNIQUE + NOT NULL
            테이블마다 반드시 한개가 있어야 좋다.
        
        FOREIGN KEY     - FK
        ==> 외래키, 참조키
            다른 테이블에 있는 데이터를 참조하는 것.
            참조하는 테이블의 컬럼에 없는 데이터를 입력하게 되면 그 행이 입력이 안된다.
        
        CHECK           - CK
        ==> 데이터가 지정한 조건에 맞는 데이터만 입력하도록 하는 것
            지정한 조건에 맞지 않는 데이터가 입력되면
            그행은 입력이 아니된다.
            
            예 ]
                comp.isShow 컬럼의 경우 'Y', 또는 'N' 문자만 입력해야만 한다.
                따라서 입력되는 해당 컬럼의 데이터가 
                'Y' 또는 'N' 이 입력이 되는지 검사하는 제약조건이다.
                
-----------------------------------------------------------------------------------------------
제약 조건(무결성 체크)을 지정하는 방법
    1. 테이블 만들때 지정하는 방법
        
        1) 무명 제약조건으로 등록하는 방법
            
            형식 ]
                CREATE TABLE 테이블이름(
                    컬럼이름    데이터타입(최대길이) UNIQUE NOT NULL,
                    컬럼이름    데이터타입(최대길이) UNIQUE,
                    컬럼이름    데이터타입(최대길이) PRIMARY KEY,
                    컬럼이름    데이터타입(최대길이) CHECK (조건식),
                    컬럼이름    데이터타입(최대길이) REFERENCES 테이블이름(컬럼이름)
                );
                
                ==> 이 경우는 
                    이름이 아예 없는 것이 아니고
                    제약조건은 오라클이 관리하는 개체이므로
                    오라클이 이름을 자동으로 만들어서 관리하게 된다.
            
        2) 명시적 제약조건으로 등록하는 방법 
            
            형식 1 ]  - 컬럼레벨에서 정의 하는 방법 (선호방법)
                
                CREATE TABLE 테이블이름(
                    컬럼이름    데이터타입(최대길이)
                        CONSTRAINT 제약조건이름   PRIMARY KEY,
                    컬럼이름    데이터타입(최대길이) [   DEFAULT 데이터     ]
                        CONSTRAINT 제약조건이름   NOT NULL
                        CONSTRAINT 제약조건이름   UNIQUE
                        CONSTRAINT 제약조건이름   CHECK (컬럼이름 IN(데이터1, 데이터2, ...))
                        CONSTRAINT 제약조건이름  REFERENCES  참조테이블이름(참조컬럼이름),
                    ....
                );
                
            형식 2 ]  - 테이블레벨 정의 하는 방법
                
                CREATE TABLE 테이블이름(
                    컬럼이름1    데이터타입(최대길이),
                    컬럼이름2    데이터타입(최대길이),
                    ....,
                    -- 여기서부터 제약조건 명시
                    CONSTRAINT  제약조건이름  PRIMARY KEY(컬럼이름1),
                    CONSTRAINT  제약조건이름  FOREIGN KEY(컬럼이름) REFERENCES 참조테이블이름(참조컬럼이름),
                    CONSTRAINT  제약조건이름  UNIQUE(컬럼이름1),
                    CONSTRAINT  제약조건이름  CHECK(조건식),
                );
                
                ==> 이경우 NOT NULL 제약 조건의 경우는 허용하지 않는다.
                    이미 널을 허용하는 속성으로 컬럼이 정의되어있기 때문에
                    컬럼을 정의할 때 NOT NULL 제약 조건을 부여하던지
                    아니면 NULL 을 허용하는 상태로 컬럼을 만들고
                    테이블이 만들이진 이후
                    컬럼의 NULL 처리에 대한 속성을 변경해줘야 한다.
                    
    2. 이미 만들어진 테이블에 제약조건을 추가하는 방법
    

*/

INSERT INTO
    COMP(ename)
VALUES(
    '희동이'
);

DROP TABLE TMP;

/*
    참고 ]
        테이블의 구조만 복사해서 테이블을 만드는 방법
            
            형식 ]
                
                CREATE TABLE 테이블이름
                AS
                    SELECT
                        *
                    FROM
                        테이블이름
                    WHERE
                        거짓이 반환되는 조건식
                ;
*/

CREATE TABLE tmp
AS
    SELECT
        *
    FROM
        emp
    WHERE
        'a' = 'A'
;

INSERT INTO
    tmp(ename)
VALUES(
    '희동이'
);


INSERT INTO
    tmp(ename, job)
VALUES(
    '희동이', '사장'
);


-- comp 테이블에 희동이 사원을 50부서에 추가해주세요.
INSERT INTO
    comp(empno, ename, deptno)
VALUES(
    (
        SELECT
            NVL(
                MAX(empno) + 1,
                1001
            )
        FROM
            comp
    ),
    '희동이', 50
);

-----------------------------------------------------------------------------
-- tmp1 테이블 :  회원번호와 회원이름을 저장할 테이블
CREATE TABLE  tmp1(
    no NUMBER(4) PRIMARY KEY,
    name VARCHAR2(15 CHAR) NOT NULL
);

-- 명시적 방법
CREATE TABLE tmp2(
    no NUMBER(4)
        CONSTRAINT TMP2_NO_PK PRIMARY KEY,
    name VARCHAR2(15 CHAR)
        CONSTRAINT TMP2_NAME_NN NOT NULL
);

-- TMP3 : TMP2 + deptno + isshow
CREATE TABLE tmp3(
    no NUMBER(4),
    name VARCHAR2(15 CHAR),
    dno NUMBER(2),
    isshow CHAR(1) DEFAULT 'Y',
    -- 제약조건 추가
    -- 참고 ] CONSTRAINT 는 제약조건의 이름을 가리키는 예약어
    CONSTRAINT TMP3_NO_PK PRIMARY KEY(no),
    CONSTRAINT TMP3_DNO_FK FOREIGN KEY(dno) REFERENCES dept(deptno),
    CONSTRAINT TMP3_SHOW_CK CHECK (isshow IN ('Y', 'N'))
);

-----------------------------------------------------------------------------
TRUNCATE TABLE tmp;

-- tmp의 사원번호에 무명 기본키 제약조건 추가

ALTER TABLE
    tmp
MODIFY 
    empno PRIMARY KEY;


-----------------------------------------------------
-- TMP 테이블의 ENAME 컬럼에 NOT NULL 제약조건을 추가
ALTER TABLE
    tmp
MODIFY
    ename CONSTRAINT TMP_NAME_NN NOT NULL
;

ALTER TABLE
    tmp
ADD
    CONSTRAINT TMP_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno)
;




