-- day13

/*
    시퀀스(SEQUENCE)
    ==> 테이블을 만들면 각각의 행을 구분할 수 있는 기본키(PRIMARY KEY)가
        관계형데이터베이스시스템의 테이블에는 거의 필수적으로 만들어져야 한다.
        
        예를 들자면
        사원을 관리하는 테이블을 만들면
        각각의 사원을 구분할 수 있는 무엇인가가 있어야 한다는 것이고
        따라서 우리가 가지고 있는 emp 테이블에서는
        사원번호(empno)를 이용해서 이것을 처리하고 있다.
        
        몇몇개의 테이블은 이것을 명확하게 구분하여 처리할 수 있지만
        그렇지 못한 테이블도 존재한다.
        
        예를 들자면
        게시글 내용을 관리하는 테이블을 만들면
            제목, 글쓴이, 작성일, 본문, ... 이 있지만
        이것중에 명확하게 원하는 하나의 게시글만 선택할 수 있는
        역할을 하는 필드는 여기는 존재하지 않는다.
        
        이런 경우 대부분 일련번호를 이용해서 이 역할을 하도록 한다.
        
        이때 일련번호는 다른 행들의 일련번호들과 구분되어져야 하고
        따라서 중복되어서는 절대로 안되고
        절대로 생략되어서도 안된다.
        ==> 데이터베이스에 내용을 입력하는 사람이 문제가 발생할 수 있다.
            <== 중복되지 않는 번호를 만드는 작업이 쉽지 않다.
            
        시퀀스는 이런 문제점을 해결하기 위해 만들어진 것.
        자동적으로 일련번호를 발생시켜 주는 도구
        
        방법 ]
            
            1. 시퀀스를 만든다.
            2. 데이터베이스에 일련번호의 입력이 필요하면 
                만들어 놓은 시퀀스에게 일련번호를 만들어 달라고 요청한다.
                ==> 즉, 데이터를 INSERT  시킬때 일련번호 부분은
                    서브질의나 직접 입력하는 것이 아니고
                    시퀀스가 만들어 내는 번호를 사용하게 된다.
                    
                    
    시퀀스 생성 방법 ]
        
        형식 ]
            CREATE SEQUENCE 시퀀스이름
            [    START WIHT      번호
                    ==> 만들어지는 일련번호의 시작값을 지정한다.
                        생략하면 1부터 시작한다.
                        
                INCREMENT BY    숫자
                    ==> 만들어지는 일련번호의 증가값을 지정한다.
                        생략하면 1씩 증가한다.
                        
                MAXVALUE        숫자      또는 NOMAXVALUE
                MINVALUE        숫자      또는 NOMINVALUE
                    ==> 만들어지는 일련번호의 최대값과 최소값을 지정한다.
                        생략하면 NO를 사용
                        
                CYCLE 또는 NOCYCLE
                    ==> 발생한 일련번호가 최대값에 도달하면 다시 처음부터
                        시작할지 여부를 지정한다.
                        생략하면 NOCYCLE 로 지정
                        
                CACHE   갯수  또는 NOCACHE
                    ==> 일련번호를 만들때 임시 메모리를 사용할지 여부를 결정
                        ( ==> 미리 몇개를 만들어서 준비해 놓을지 를 결정... )
                        사용하면 속도는 빨라지지만 메모리가 줄고
                        안하면 속도는 느려지지만 메모리가 줄지 않는다.
                        기본값은 10 개
            ]
            ;
                
*/

/*
    테이블 설계 순서
        1. ER Model
            <==== 정규화
            
        2. ER Diagram
        
        3. 테이블 명세서
        
        4. DDL 명령 ( CREATE )
        
        5. DML 명령으로 데이터 추가 ( INSERT )
        
*/

CREATE TABLE TMP7(
    no NUMBER(2),
    name VARCHAR2(15 CHAR)
);

INSERT INTO
    tmp7
VALUES(
    1, '둘리'
);


INSERT INTO
    tmp7
VALUES(
    1, '둘리'
);

INSERT INTO
    tmp7
VALUES(
    1, '둘리'
);

ROLLBACK;

-------------------------------------

DROP TABLE TMP1;

DROP TABLE TMP2;
DROP TABLE TMP3;
DROP TABLE TMP5;
DROP TABLE TMP6;
DROP TABLE TMP7;

-- EMP 테이블의 구조만 복사해서 TMP1 테이블을 만든다.
CREATE TABLE tmp1
AS
    SELECT
        *
    FROM
        emp
    WHERE
        deptno = 30
;

TRUNCATE TABLE tmp1;

-- tmp1에 기본키 제약조건을 TMP1_NO_PK라는 이름으로 부여하고
-- 참조키 제약조건을 TMP1_DNO_FK 라는 이름으로 
--  deptno 컬럼에 dept 테이블이 deptno를 참조하도록 추가하자.

ALTER TABLE tmp1
ADD
    CONSTRAINT TMP1_NO_PK PRIMARY KEY(empno)
;

ALTER TABLE tmp1
ADD
    CONSTRAINT TMP1_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno)
;

-- 예제 ] 1부터 1씩 증가하는 시퀀스 SEQ01을 만드세요. 단, 최대값은 100 으로 하세요.
--      최대값에 도달하면 다시 1부터 시작되도록 하세요.

CREATE SEQUENCE seq01
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100
    CYCLE
;

/*
    시퀀스 사용방법 ]
        ==> 데이터를 입력할 때 
            자동으로 일련번호를 발생시키기 위해서 만든것이 시퀀스이다.
            
            따라서 주로 INSERT 명령에서 사용하며
            
                시퀀스이름.NEXTVAL
                
            이라는 키워드를 사용하면 자동으로 일련번호가 만들어진다.
            
            참고 ]
                시퀀스가 가지는 키워드
                    NEXTVAL     -   다음번호를 만들어서 변수에 기억
                    CURRVAL     -   가장 최근 만들어진 번호를 기억하는 변수
                                    주의 ]
                                        NEXTVAL 이 한번은 실행되어야 CURRVAL 이 만들어진다.
                                        CURRVAL 은 세션이 다시 열리면 초기화된다.
*/

-- 일련번호를 seq01을 이용해서 만들어 보자.
SELECT
    seq01.CURRVAL seq01첫번째번호
FROM
    DUAL
;

SELECT
    seq01.NEXTVAL seq01첫번째번호
FROM
    DUAL
;

SELECT
    seq01.CURRVAL "seq01기억된첫번째번호"
FROM
    DUAL
;


SELECT
    seq01.NEXTVAL seq01다음번호
FROM
    DUAL
;

SELECT
    seq01.CURRVAL "seq01기억된번호"
FROM
    DUAL
;

SELECT
    seq01.NEXTVAL seq01다음번호
FROM
    DUAL
;

SELECT
    seq01.NEXTVAL seq01다음번호
FROM
    DUAL
;

SELECT
    seq01.NEXTVAL seq01다음번호
FROM
    DUAL
;

SELECT
    seq01.CURRVAL "seq01기억된번호"
FROM
    DUAL
;

SELECT
    seq01.CURRVAL 기억된번호,    seq01.NEXTVAL 만든번호
FROM
    dual
;

/*
    참고 ]
        시퀀스는 오라클이 관리하는 개체이다.
        따라서 만들때도 CREATE 명령으로 만들었고
        만드는 순간 오라클에 저장이 된다.
        따라서 어떤 테이블에서든 사용할 수 있게 된다.
*/

----------------------------------------------------------------------------
/*
    사원의 일련번호로 사용할 시퀀스 E_SEQ01 을 만드는데
        시작값은 1001 부터 시작하고
        최대값은 9999로 하고
        최대값에 도달할 경우 시작값으로 돌아가지 않도록해서
        시퀀스를 만들어주세요.
*/

CREATE SEQUENCE e_seq01
    START WITH 1001
    MAXVALUE 9999
;

/*
    만들어진 시퀀스를 사용해서 사원의 정보를 입력해보세요.
    
    
*/

INSERT INTO 
    tmp1
(
    SELECT
        e_seq01.nextval, ename, job, 
        mgr, hiredate, sal, comm, deptno
    FROM
        emp
    WHERE
        empno = 7369
);

/*
    기존 테이블의 데이터를 복사해서 데이터를 입력하는 형식
    
    INSERT INTO
        테이블이름(컬럼이름들...)
    (
        서브질의
    )
    ;
*/


INSERT INTO
    tmp1
(
    SELECT
        e_seq01.nextval, ename, job, 
        mgr, hiredate, sal, comm, deptno
    FROM
        emp
    WHERE
        ename <> 'SMITH'
);

COMMIT;

/*
    결론 ]
        우리가 데이터를 입력할 때
        일련번호를 입력할 경우
        이제까지는 서브질의를 사용해서 처리를 했지만
        시퀀스를 사용하게 되면 질의 명령이 간단해지고
        처리속도도 향상이 된다.
        
    시퀀스의 문제점 ]
        시퀀스는 테이블에 독립적이다.
        즉, 한번 만든 시퀀스는 여러 테이블에서 동시에 사용할 수 있다.
        이때 어떤 테이블에서 시퀀스를 사용하던지
        항상 다음 일련번호를 발생해서 사용한다.
        
        따라서 결과적으로 일련번호가 건너뛰는 부분이 생길 수 있다.
        
        그리고
        삽입 질의명령이 실행되는 도중 에러가 발생하더라도
        다음 번호는 그때마다 발생시킨다.
        이 경우도 건너뛰는 부분이 발생하게 된다.
        
*/

INSERT INTO
    tmp1
(
SELECT
    seq01.nextval eno, ename, job, mgr, hiredate, sal, comm, deptno
FROM
    emp
WHERE
    NOT deptno = 20
    /*
        NOT deptno = 20
        ==
        
        deptno != 20
        deptno <> 20
        
        NOT TO_CHAR(deptno) LIKE '20'
        
    */
);

-- 위의 서브질의의 결과를 사용해서 tmp2 테이블을 만들어보자.
CREATE TABLE tmp2
AS
    (
        SELECT
            seq01.nextval eno, ename, job, mgr, hiredate, sal, comm, deptno
        FROM
            emp
        WHERE
            NOT deptno = 20
    )
;

/*
    시퀀스 삭제하기
        DROP SEQUENCE 시퀀스이름;
        
    시퀀스 수정하기
        
        형식 ]
            ALTER SEQUENCE 시퀀스이름
                INCREMENT BY 숫자
                MAXVALUE 숫자
                MINVALUE 숫자
                CYCLE 또는 NOCYCLE
                CACHE 숫자 또는 NOCACHE
            ;
            
        주의 ]
            시퀀슬 수정할 경우에는 시작번호는 수정할 수 없다.
            왜냐하면 이미 발생한 번호가 있기 때문에...
            따라서 시작 번호는 기존에 만든 시작번호를 사용하게 된다.
*/


------------------------------------------------------------------------------------------------------
/*
    문제 ]
            회원들의
                아이디, 비밀번호, 이름, 전화번호, 이메일, 성별, 출생일, 가입일 을 관리할 
            테이블(memb01)을 만들고
            제약조건을 부여하고
            회원 정보 입력시 자동으로 1001 부터 9999 까지의 회원번호를 만들 시퀀스 M_SEQ01 을 만들어서
            친구 다섯명을 추가해주세요.
*/

-- 아바타 테이블

CREATE TABLE avatar(
    ano NUMBER(2)
        CONSTRAINT AVT_NO_PK PRIMARY KEY,
    savename VARCHAR2(50 CHAR)
        CONSTRAINT AVT_SNAME_UK UNIQUE
        CONSTRAINT AVT_SNAME_NN NOT NULL,
    dir VARCHAR2(100 CHAR) DEFAULT '/img/avatar'
        CONSTRAINT AVT_DIR_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT AVT_GEN_CK CHECK (gen IN ('F', 'M', 'H'))
        CONSTRAINT AVT_GEN_NN NOT NULL,
    adate DATE DEFAULT sysdate
        CONSTRAINT AVT_DATE_NN NOT NULL
);


-- gen 컬럼 제약조건 수정
ALTER TABLE
    avatar
DROP CONSTRAINT AVT_GEN_CK;

ALTER TABLE
    avatar
ADD 
    CONSTRAINT AVT_GEN_CK CHECK (gen IN ('M', 'F', 'H'))
;

-- 아바타 데이터 입력
INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    10, 'noimage.jpg', 'H'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    11, 'img_avatar1.png', 'M'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    12, 'img_avatar2.png', 'M'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    13, 'img_avatar3.png', 'M'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    14, 'img_avatar4.png', 'F'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    15, 'img_avatar5.png', 'F'
);

INSERT INTO
    avatar(ano, savename, gen)
VALUES(
    16, 'img_avatar6.png', 'F'
);

CREATE TABLE memb01(
    mno NUMBER(4)
        CONSTRAINT MEMB01_NO_PK PRIMARY KEY,
    id VARCHAR2(10 CHAR)
        CONSTRAINT MEMB01_ID_UK UNIQUE
        CONSTRAINT MEMB01_ID_NN NOT NULL,
    pw VARCHAR2(8 CHAR)
        CONSTRAINT MEMB01_PW_NN NOT NULL,
    name VARCHAR2(30 CHAR)
        CONSTRAINT MEMB01_NAME_NN NOT NULL,
    tel VARCHAR2(20 CHAR)
        CONSTRAINT MEMB01_TEL_UK UNIQUE
        CONSTRAINT MEMB01_TEL_NN NOT NULL,
    mail VARCHAR2(50 CHAR)
        CONSTRAINT MEMB01_MAIL_UK UNIQUE
        CONSTRAINT MEMB01_MAIL_NN NOT NULL,
    ano NUMBER(2) DEFAULT 10
        CONSTRAINT MEMB01_ANO_FK REFERENCES avatar(ano)
        CONSTRAINT MEMB01_ANO_NN NOT NULL,
    gen CHAR(1)
        CONSTRAINT MEMB01_GEN_CK CHECK (gen IN ('F', 'M'))
        CONSTRAINT MEMB01_GEN_NN NOT NULL,
    isshow CHAR(1) DEFAULT 'Y'
        CONSTRAINT MEMB01_SHOW_CK CHECK (isshow IN ('Y', 'N'))
        CONSTRAINT MEMB01_SHOW_NN NOT NULL
);

-- 회원번호 자동 생성 시퀀스 생성
CREATE SEQUENCE m_seq01
    START WITH 1001
    MAXVALUE 9999
    NOCACHE
;

-- 회원 정보 입력
INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'euns', '12345', '전은석', '010-3175-9042', 
    'euns@increpas.com', 11, 'M'
);

INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'won', '12345', '곽채원', '010-1111-1111', 
    'won@increpas.com', 15, 'F'
);

INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'woo', '12345', '윤건우', '010-5555-5555', 
    'woo@increpas.com', 12, 'M'
);

INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'taeh', '12345', '최태현', '010-2222-2222', 
    'taeh@increpas.com', 12, 'M'
);

INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'yujin', '12345', '김유진', '010-3333-3333', 
    'yujin@increpas.com', 15, 'F'
);

INSERT INTO
    memb01(mno, id, pw, name, tel, mail, ano, gen)
VALUES(
    m_seq01.NEXTVAL, 'yts', '12345', '윤태성', '010-8888-8888', 
    'yts@increpas.com', 13, 'M'
);

commit;

------------------------------------------------------------------------------------------------------

/*
    회원들의
    회원번호, 아이디, 이름, 메일, 전화번호, 성별, 아바타경로
    을 조회하세요.
    
     성별은 남자 또는 여자로 표현하세요.
*/

SELECT
    mno 회원번호, id 아이디, name 이름, mail 메일, tel 전화번호, 
    DECODE(m.gen, 'M', '남자', 'F', '여자', '인간') 성별,
    CONCAT(CONCAT(dir, '/'), savename) 아바타경로 
FROM
    MEMB01 m, avatar a 
WHERE
    m.ano = a.ano
;




