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
    







