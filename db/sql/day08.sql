-- # day08

/*
    데이터베이스의 필수 연산 네가지
                                    DML             DDL             의미
        C   - CREATE            -   INSERT      -   CREATE      - 새로운 데이터(개체)를 만드는 명령
        R   - READ, RECORD      -   SELECT      -   X           - 데이터(개체)를 조회하는 명령
        U   - UPDATE            -   UPDATE      -   ALTER       - 데이터(개체)를 수정하는 명령
        D   - DELETE            -   DELETE      -   DROP        - 데이터(개체)를 삭제하는 명령
        
        
    지금까지는 R에 해당하는 SELECT 질의명령을 공부했다.
    
    DML(DATA MANIPULATION LANGUAGE) 명령
    ==> 데이터를 처리(조작)하는 명령
        이 명령 안에는 CRUD 명령이 모두 포함이 된다.
        
        이제까지 우리는 R에 해당하는 SELECT 질의명령을 공부했다.
        
    1. INSERT ( C - CREATE )
        ==> 새로운 데이터를 입력하는 명령
        
        형식 ]
            INSERT INTO 
                테이블이름[(
                    필드이름1, 필드이름2, 필드이름3,...
                )]
            VALUES(
                데이터1, 데이터2, 데이터3, ....
            );
            
        의미 ]
            지정한 테이블의 지정한 필드에 데이터를 입력하세요.
            
        주의사항 ]
            필드이름의 갯수와 데이터의 갯수는 반드시 일치해야 하고, 순서도 일치해야 한다.
            필드의 형태와 데이터의 형태도 반드시 일치해야 한다.

*/

/*
    실습준비 ]
        사원정보 테이블을 복사해서 COMP 테이블을 만든다.
*/

DROP TABLE COMP;

CREATE TABLE COMP
AS
    SELECT
        *
    FROM
        emp
;


ALTER TABLE comp
ADD 
    CONSTRAINT COMP_PK PRIMARY KEY (empno);
    
ALTER TABLE comp
ADD
    CONSTRAINT COMP_DNO_FK FOREIGN KEY (deptno) REFERENCES dept(deptno);

------------------------------------------------------------------------------
-- 회사 테이블에 dooly 사원의 정보를 입력하세요.

INSERT INTO
    comp(
        empno, ename, hiredate
    )
VALUES(
    (SELECT NVL(MAX(empno) + 1, 1001) FROM comp),
    'DOOLY', sysdate
);
 
-- 고길동 사원의 직급은 'CLERK' 이고 부서는 30번 부서로 현재시간 회사 사원이 되었습니다.
-- 데이터베이스에 사원을 추가하는 질의명령을 작성하세요.

INSERT INTO
    comp(empno, ename, job, hiredate, deptno)
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
    '고길동', 'CLERK', sysdate, 30
);

/*
    **********
    DML 명령중 INSERT, UPDATE, DELETE 명령은
    데이터베이스에 적용을 원하는 경우
    반드시 COMMIT 명령을 실행해줘야 한다.
*/

COMMIT;
select * from comp;

INSERT INTO
    comp(empno, ename, job, hiredate, deptno)
VALUES(
    (SELECT NVL(MAX(empno) + 1, 1001) FROM comp),
    '도우너', 'MANAGER', '2021/01/27', 10
);

/*
    날짜 데이터는 날짜 연번을 사용해서 데이터 베이스에서 기억하므로
    사용자가 날짜연번을 만드는 작업은 어렵다.
    따라서 날짜데이터를 입력할 경우는 
    문자데이터를 사용해서 날짜데이터를 만들어서 대부분 입력하게 된다.
    
    따라서 날짜데이터를 입력할 경우에는 만드시 문자데이터를 사용해야 되므로
    오라클에서는 문자데이터를 날짜데이터로 입력할 경우
    형변환 함수를 자동 호출하도록 하고 있다.
    
    따라서 날짜 형식의 문자데이터를 입력해도 무방하다.
    
    주의사항 ]
        아무 문자나 입력할 수 있는 것은 아니고
        지정된 형식만 날짜 데이터로 변환후 입력하게 된다.
        
        지정된 형식
            1. 2021/01/27
            2. 2021-01-27
            3. 2021.01.27
            
        이 이외의 형식은 날짜데이터로 변환하지 못한다.
        
    참고 ]
        데이터가 준비되지 않은 경우는 
            1. NULL 로 해당 필드의 데이터를 채운다.
            2. 필드 이름을 나열할 때 해당 필드이름을 기술하지 않으면 된다.
*/

-- 또치 사원의 데이터를 입력하세요. 입사일은 오늘 0시로 하세요.
/*
    ==> 이 경우 준비된 데이터는 이름과 입사일이고
        사원번호는 서브질의로 만들어 사용하면 된다.
        하지만 그 이외의 필드에 입력할 데이터는 준비가 안되어있는 상태이다.
*/

INSERT INTO
    comp
    /*
        이처럼 필드이름 나열을 생략하는 경우는
        테이블에 정의된 필드에 입력될 데이터를 순서대로 모두 나열해야 한다.
    */
VALUES(
    (SELECT NVL(MAX(empno) + 1, 1001) FROM comp),
    '또치', NULL, NULL, '2021/01/27', NULL, NULL, NULL
);

commit;

---------------------------------------------------------------------------------
/*
    UPDATE  - 데이터를 수정하는 명령
    
    주의 사항 ]
        조건을 제시하지 않으면 
        테이블에 입력된 모든 ROW의 데이터를 수정하게 된다.
        
    형식 ]
        
        UPDATE
            테이블이름
        SET
            필드이름 = 데이터,
            필드이름 = 데이터,
            .....
        WHERE
            조건식
        ;
        
    참고 ]
        변경될 데이터는 수식을 이용해서 처리할 수도 있다.
*/

commit;

UPDATE
    comp
SET
    mgr = 7934
;

rollback;

-- 또치의 상사를 'MILLER'로 수정하고 급여는 1200으로 수정 하세요.
UPDATE
    comp
SET
    mgr = (
                SELECT
                    empno
                FROM
                    comp
                WHERE
                    ename = 'MILLER'
            ),
    sal = 1200
WHERE
    ename = '또치'
;

commit;


/*
    사원들의 급여를 일율적으로 기존급여의 10%를 인상해서 수정하세요.
    참고 ]
        데이터에 기존 필드데이를 사용해서 연산해도 무방하다.
            comm = comm * 1.5
*/
UPDATE 
    comp
SET
    sal = sal * 1.1
;
/*
    직책이 SALESMAN인 사원들의 직책을 '영업부'로 변경하세요.
*/
UPDATE
    comp
SET
    job = '영업부'
WHERE
    job = 'SALESMAN'
;
/*
    2021/01/26 이후 입사한 사원들의 부서는 'KING' 과 같은 부서로 변경하고
    급여가 없으면 1500을 있으면 기존 급여를 받도록 수정하세요.
*/

UPDATE
    comp
SET
    sal = NVL(sal, 1500),
    deptno = (SELECT deptno FROM comp WHERE ename = 'KING')
WHERE
    hiredate > '2021/01/26'
;

-----------------------------------------------------------------------------
/*
    DELETE 명령
    ==> 테이블에 저장된 데이터를 삭제하는 명령
        되도록이면 안쓰는 것이 좋다.
        
        반드시 데이터를 삭제해야 할 경우에는
        벡업 테이블을 별도로 만들고
        삭제전 벡업테이블에 데이터를 저장하고
        그 후 데이터를 삭제해야 한다.
        
        형식 ]
            DELETE FROM 테이블이름
            [WHERE
                조건식
            ]
            ;
            
        참고 ]
            조건식을 제시하지 않으면 모든 데이터가 다 삭제된다.
*/

SELECT * FROM comp;

DELETE FROM comp;

SELECT * FROM comp;

rollback;

SELECT * FROM comp;

-- 예 ] 2021/01/27 0시 이후 입사한 사원들을 퇴사처리하세요.
DELETE FROM
    comp
WHERE
    HIREDATE >= '2021/01/27'
;

ROLLBACK;

/*
    실제 현업에서는 삭제 명령 대신
    지울 데이터를 지운데이터인지 아닌지 구분할 필드를 만들어두고
    그 필드의 데이터를 수정하는 것으로 처리한다.
    
    흔히 많이 사용하는 필드가
        
        isShow = 'N'    - 삭제한 데이터
        isShow = 'Y'
*/

ALTER TABLE
    comp
ADD (
    isShow CHAR(1) DEFAULT 'Y'
        CONSTRAINT COMP_SHOW_CH CHECK (isshow IN ('Y', 'N'))
        CONSTRAINT COMP_SHOW_NN NOT NULL
);

-- 이 경우 데이터를 삭제 하는 방법은
UPDATE
    comp
SET
    isshow = 'N'
WHERE
    hiredate >= '2021/01/27'
;

/*
    이렇게 isshow 가 정의되어있는 테이블에서는
    질의명령을 작성할 때
    반드시 isshow의 값을 비교해서 추출하는 것이 좋다.
*/

-- 10번 부서의 사원을 조회하세요.
SELECT
    empno, ename, hiredate
FROM
    comp
WHERE
    isShow = 'Y'
    AND deptno = 10
;

commit;

-----------------------------------------------------------------------------------------------------------
ALTER TABLE comp
MODIFY ename VARCHAR2(15 CHAR)
;

/*
    문제 1 ]
        comp 테이블에 다음 데이터를 입력하세요.
        이름 : 소원
        직책 : 매니저
        급여 : 2500
        입사일 : 2021/01/18
*/

/*
    문제 2 ]
        comp 테이블에 다음 데이터를 입력하세요.
        이름 : 예린
        직책 : 영업부
        입사일 : 2021/01/19
*/

/*
    문제 3 ]
        comp 테이블에 다음 데이터를 입력하세요.
        이름 : 신비
        직책 : 수습
        급여 : 아직 못정함
        입사일 : 2021/01/25
*/

/*
    문제 4 ]
        comp 테이블에 다음 데이터를 수정하세요.
        1.  사원이름 뒤에 ' 사원' 을 붙여서 수정하세요.
        2.  'KING'의 이름 뒤에는 ' 사장' 을 붙여서 수정하세요.
*/
UPDATE
    comp
SET
    ename = DECODE(ename, 'KING', CONCAT(ename, ' 사장'),
                            CONCAT(ename, ' 사원')
            )
;

/*
    문제 5 ]
        comp 테이블에 다음 데이터를 수정하세요.
        급여를 25% 인상하되 10 단위는 잘라서 수정하세요.
        단, 입사년도가 81년인 사원만 수정하세요.
*/

/*
    문제 6 ]
        
        아래 질의명령은 실행한 후 진행하세요.
        
        질의명령 ]
            CAREATE TABLE comp1
            AS
                SELECT
                    *
                FROM
                    comp
            ;
    
        comp1 테이블에 다음 데이터를 삭제하세요
        직급이 'MANAGER'이고 부서번호가 10인 사원을 삭제하세요.
*/

/*
    문제 7 ]
        comp1 테이블에 다음 데이터를 삭제하세요.
        이름의 마지막 글자(공백문자 이전문자)가 'S' 인 사원을 삭제하세요.
*/


