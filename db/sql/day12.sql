-- day12

/*
    트랜젝션 처리
        
        트랜젝션    ]
            교과서적인 의미로 처리(실행)하는 명령 단위
            
        예를 들어 우리가 테이블을 만들경우 
        create 명령을 사용할 것이고
        이때 실행을 시키게 되는데( ==> 테이블이 만들어진다.)
        이때 "트랜젝션이 실행되었다." 라고 표현한다.
        
        오라클에서 대부분의 명령은
        sqlplus 경우는 엔터키를 누르거나
        sqldeveloper의 경우는 ctrl + 엔터 키를 누르는 순간 명령이 실행되고
        그것은 결국 트랜젝셕이 실행된 것이므로
        결국 오라클은 명령 한줄이 곧 하나의 트랜젝션이 된다.
        
        그런데 DML 명령의 경우는 트랜젝션의 단위가 달라진다.
            참고 ]
                DML 명령 ] INSERT, UPDATE, DELETE
        
        ==> DML 명령은 명령을 내리면 바로 실행되는 것이 아니고
            버퍼(임시 기억장소)에 명령을 모아만 놓는다.
            ==> 결국 트랜젝션이 실행되지 않는다.
            
            따라서 DML 명령은 트랜젝션 실행 명령을 따로 내려야 한다.
            이때 트랜젝션은 한번만 일어나게 된다.
            
            <==
                DML 명령은 데이터를 변경하는 명령이다.
                데이터베이스에서 가장 중요한 개념은 무결성 데이터이다.
                이런곳에 DML 명령이 한순간 트랜젝션이 처리되면
                데이터의 무결성이 사라질 수 있다.
                이런 문제점을 해결하기 위한 목적으로 
                트랜젝션 방식을 변경해 놓았다.
                
       -------------------------------------------------------------------------------------- 
        버퍼에 모아놓은 명령을 트랜젝션 처리하는 방법
            
            1. 자동 트랜젝션 처리
                1) sqlplus 를 정상적으로 종료(exit 명령)하는 순간
                2) DDL 명령이나 DCL 명령이 내려지는 순간
                    참고 ]
                        DDL 명령  - CREATE, ALTER, DROP, TRUNCATE
                        DCL 명령  - [ COMMIT, ROLLBACK  ==> TCL 명령  ]
                                    GRANT, REVOKE     ==> 권한과 관련된 명령
                        
            2. 수동 트랜젝션 처리
                1) COMMIT 명령을 실행하는 순간
       --------------------------------------------------------------------------------------         
        버퍼에 모아놓은 명령이 실행되지 않는 경우
            ==> 트랜젝션 처리가 되지 못하고 버려지는 경우
            
            자동 버려지는 경우
                1. 정전 등에 의해서 시스템이 셧다운 되는 순간
                2. sqlplus 를 비정상적으로 종료하는 경우
                
            수동 버려지는 경우
                rollback 명령이 실행되는 순간
                
       --------------------------------------------------------------------------------------
        따라서 DML 명령을 실행한 후 다시 검토해서 완벽한 명령이라고 (데이터의 무결성이 유지된다고) 판단되면
        commit 이라고 명령해서 트랜젝션을 일으키고
        만약 검토시 무결성이 유지되지 않는 경우에는 
        rollback 이라고 명령해서 잘못된 명령을 취소하도록 한다.
        
        참고 ]
            rollback 시점 만들기
            ==> DML 명령을 내릴 때 특정 위치에 책갈피를 만들어 놓을 수 있으며
                
                나중에 이 책갈피를 이용해서 ROLLBACK 할 부분을 지정할 수 있다.
                
            책갈피 만들기
                
                SAVEPOINT   적당한이름;
                
            지정한 위치로 ROLLBACK 하는 방법
                
                ROLLBACK TO 만든지점이름;
                
        예 ]
            
            SAVEPOINT A;
            1) DML
            2) DML
            3) DML
            SAVEPOINT B;
            4) DML
            5) DML
            SAVEPOINT C;
            6) DML
            7) DML
            
            
            
            ==> 6, 7 번 작업이 잘못되었다고 판단 되어서 C 지점으로 되돌릴 경우
                
                ROLLBACK TO C;  ==> 6, 7 만 취소
                
        참고 ]
            트랜젝션이 처리되면 SAVEPOINT 는 자동 파괴된다.
            
            SAVEPOIN A;
            1) DML
            CREATE TABLE SAMPLE();
            
            2) DML
            
            ROLLBACK TO A;  ==> 에러ㅏ
            ROLLBACK;       ==> SAMPLE 테이블 만든시점(2번 바로직전)으로 돌아간다.
        
*/

---------------------------------------------------------------------------------------------
/*
    뷰(View)
    ==> 질의 명령의 결과를 하나의 창문으로 바라볼 수 있는 창문을 의미한다.
        
        물리적으로 만들어져 있지 않은 테이블과 같다.
        
        예 ]
            SELECT ename, sal FROM emp;
            ==> 이렇게 질의명령을 실행하면
                결과가 발생하고 이 결과 중에서 일부분만 볼 수 있는
                창문을 만들어서 사용하는 것.
                
                ==> 물리적으로 테이블을 들어서 사용하게 되면
                    emp 테이블의 데이터가 수정이 되면
                    이 테이블의 데이터도 동시에 수정을 해줘야 무결성이 유지된다.
                    
        ==> 자주 사용되는 복잡한 질의명령을 따로 저장해 놓고
            이 질의 명령의 결과를 손쉽게 처리할 수 있도록 하는 것.

    
-----------------------------------------------------------------------------------------------

    뷰의 종류
        1. 단순뷰
            ==> 하나의 테이블만 이용해서 만들어진 뷰
                DML 명령이 원칙적으로 가능하다.
                
        2. 복합뷰
            ==> 두개 이상의 테이블을 이용해서(조인) 만들어진 뷰
                DML 명령이 불가능하다.
                ==> 그냥 보기만 하세요.
                    ==> SELECT 명령만 사용하세요.
        
        
    뷰를 만드는 형식
        
        형식 1 ]
            CREATE VIEW    뷰이름
            AS
                뷰에서 볼 데이터를 위한 질의명령
            ;
            
    참고 ]
        뷰를 확인하는 방법
            오라클의 경우 뷰 역시 하나의 테이블로 관리한다.
            그 테이블 이름이 "USER_VIEWS" 이다.
            
        형식 2 ]
            ==> DML 명령으로 데이터를 변경할 때
                변경된 데이터는 기본 테이블만 변경이 되므로
                뷰 입장에서 보면 그 데이터를 실제로 사용 할 수 없을 수 있다.
                ==> 이런 문제를 해결하기 위한 문법
                    자신이 사용할 수 없는 데이터는 수정이 불가능하도록 할 수 있다.
                    
            CREATE VIEW 뷰이름
            AS
                질의명령
            WITH CHECK OPTION;
*/

/*
-- system 계정에서 작업한다.
GRANT CREATE ANY VIEW TO SCOTT;
*/


DROP TABLE tmp;

CREATE TABLE tmp
AS
    SELECT
        *
    FROM
        emp
;

DROP VIEW tview;

CREATE VIEW tView
AS
    SELECT
        ename, sal
    FROM
        tmp
;

SELECT  -- 단순뷰(테이블 한개를 이용해서 만든 뷰)
    *
FROM
    tview
;

-- 뷰를 이용해서 'SMITH' 사원의 급여를 850으로 수정하자.
UPDATE
    tview
SET
    sal = 850
WHERE
    ename = 'SMITH'
;

SELECT
    ename, sal
FROM
    tmp
WHERE
    ename = 'SMITH'
;

rollback;

CREATE VIEW tmpCalc
AS
    SELECT
        deptno dno, COUNT(*) cnt, MAX(sal) max,
        MIN(sal) min, AVG(sal) avg, SUM(sal) sum
    FROM
        tmp
    GROUP BY
        deptno
;

-- 부서의 평균급여보다 급여가 적은 사원들의 
-- 사원이름, 급여, 부서평균급여, 부서원수 를 조회하세요.
SELECT
    ename, sal, avg, cnt
FROM
    tmp, tmpCalc
WHERE
    deptno = dno
    AND sal < avg
;

-- 뷰 확인하기

SELECT
    view_name, -- 뷰 이름
    text        -- 뷰에서 사용하는 질의명령
FROM
    user_views
;

/*
    예제 ] 
        부서번호가 20번인 사원의 이름, 직급, 부서번호를 볼 수 있는 뷰를 만드세요.
        단, 내가 볼 수 없는 것은 수정할 수 없게 하세요.
*/

DROP VIEW vd20;

CREATE VIEW vd20
AS
    SELECT
        ename, job, deptno
    FROM
        tmp
    WHERE
        deptno = 20
WITH CHECK OPTION
;

-- 데이터 추가 '홍길동', '영업', 20
INSERT INTO
    vd20
VALUES(
    '홍길동', '영업', 20
);
-- '고길동', '환경', 30
INSERT INTO
    vd20
VALUES(
    '고길동', '환경', 30
);










