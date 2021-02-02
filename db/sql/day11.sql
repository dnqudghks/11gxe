CREATE TABLE ECOLOR(
    ecno NUMBER(4),
    ecname VARCHAR2(20 CHAR),
    rgb_code CHAR(11)
);

INSERT INTO
    ecolor
VALUES(
    (
        SELECT 
            NVL(
                MAX(ecno) + 1,
                1001
            )
        FROM
            ecolor
    ),
    'red', '255,000,000'
);

INSERT INTO
    ecolor
VALUES(
    (
        SELECT 
            NVL(
                MAX(ecno) + 1,
                1001
            )
        FROM
            ecolor
    ),
    'blue', '000,000,255'
);

INSERT INTO
    ecolor
VALUES(
    (
        SELECT 
            NVL(
                MAX(ecno) + 1,
                1001
            )
        FROM
            ecolor
    ),
    'green', '000,255,000'
);

------------------------------------------------------------------
/*
    day11
        
        Join
        ==> 두개 이상의 테이블에 있는 내용을 동시에 검색하는 방법
        
        참고 ]
            오라클은 ER 형태의 데이터베이스라고도 한다.
            ER 형태란?
                엔티티끼리의 릴레이션 쉽 관계를 이용해서 데이터를 관리한다.
                
            예 ]
                쇼핑몰에서 판매 관리를 하고자 한다면
                
                ==> 
                    누가       - 이름, 주소, 전화번호, ...        - 회원
                    무엇을     - 상품이름, 가격, 제조사, ...      - 상품
                    몇개       - 
                    언제       - 
                    
                전은석, 서울시 관악구 신림동.., 010-3175-9042, 얼그레이, 20000, 슈퍼, 
                전은석, 서울시 관악구 신림동..., 010-3175-9042, 모카마타리, 50000, 예멘
                전은석, 서울시 관악구 신림동..., 010-3175-9042, 유자차, 10000, 제주도
                
                허수경, 서울시 관악구 신림동..., 010-1111-1111, 유자차, 10000, 제주도
                최태현, 서울시 관악구 신림동..., 010-2222-2222, 유자차, 10000, 제주도
                
                
                원래는 이렇게 저장해 놓아야 하는데..
                정규화 과정에서
                중복 데이터는 분리되었기 때문에
                
                구매테이블 
                
                    구매자테이블
                
                    상품테이블
                    
        참고 ]
            오라클은 처음부터 여러개의 테이블을 동시에 검색하는 기능은 이미 가지고 있다.
            ==> 이처럼 두개 이상의 테이블을 동시에 검색하면
                Cartisian Product 가 만들어진다.
                
        조인이란???
            Cartisian Product 에서 원하는 결과물만 뽑아내는 기법(기술) 또는 명령
            
        1. Inner Join   ==> Cartisian Product 내에서 원하는 데이터를 추출하는 명령
            1) EQUI JOIN
                ==> 원하는 데이터를 추출할 때 
                    조건을 주고 추출하는데 
                    이때 조건 연산자가 동등비교 연산자(equal 연산자) 를 사용해서 추출하는 경우
                    
                형식 ]
                    SELECT
                        필드이름, 필드이름,...
                    FROM
                        테이블1, 테이블2, ...
                    WHERE
                        조건식(동등비교연산자 사용)   
                    ;
                    
                참고 ]
                    테이블1과 테이블2등 각 테이블에 동일한 이름의 필드가 존재하면
                    필드이름을 구분해서 지정해 줘야 한다.
                    구분하는 방법
                        1. 테이블이름.필드이름
                        2. 테이블이름에 별칭을 부여한 후
                            별칭.필드이름
                            
                참고 ]
                    조인으로 걸러내는 조건식을 "조인조건"이라 하고
                    결과중 특정 데이터만 선택하는 조건을 "일반조건" 이라고 한다.
                    
            2) NON EQUI JOIN
                ==> 원하는 데이터를 추출할 때 
                    동등비교가 아닌 대소비교로 추출하는 경우
                        >, <, BETWEEN A AND B
            
            참고 ]
                여러개의 조인 을 동시에 적용실 수도 있다.
            
            3) SELF
            
        2. Outer Join   ==> Cartisian Product 내에 원하는 데이터가 없을 때 데이터를 뽑아내는 명령
        
*/


-- 1. INNER JOIN
SELECT
    *
FROM
    kcolor, ecolor
;

SELECT
    *
FROM
    kcolor k, ecolor e
WHERE
    k.rgb_code = e.rgb_code
;

-- 예 ]  사원들의 사원이름, 부서번호, 부서이름 을 조회하세요.
SELECT
    *
FROM
    emp, dept   -- emp 테이블에는 14명의데이터가 있고 dept 테이블에는 4개부서의 데이터가 있으므로
    -- 총 56개의 결과 데이터가 만들어진다.
    -- 따라서 조인은 이 56개의 데이터 중에서 정확한 데이터 14개만 골라내는 작업이다.
;

-- ==>
SELECT
    ename, e.deptno, dname
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno
;

-- 예제 ] 81년 입사한 사원들의 이름, 직급, 입사일, 부서번호, 부서이름, 부서위치 를 조회하세요.
SELECT
    ename, job, hiredate, e.deptno, dname, loc
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno -- 조인조건
    AND TO_CHAR(hiredate, 'yy') = '81'  -- 일반조건 * 조인조건과 일반조건은 같이 사용해도 무방하다.
;


-- NON EQUI JOIN
-- 예제 ] 사원들의 이름, 직급, 급여, 급여등급 을 조회하세요.
SELECT
    ename, job, sal, grade, losal, hisal
FROM
    emp, salgrade
WHERE
--    sal >= losal AND sal <= hisal   -- 조인조건
    sal BETWEEN losal AND hisal
;

-- 예제 ] 사원들의 이름, 직급, 급여, 부서이름, 급여등급을 조회하세요.
SELECT
    ename, job, sal, dname, grade
FROM
    emp, dept, salgrade
WHERE
    emp.deptno = dept.deptno
    AND sal BETWEEN losal AND hisal
;
    
--------------------------------------------------------------------------------------
/*
    문제 1 ]
        직급이 'MANAGER'인 사원들의 
            이름, 직급, 입사일, 급여, 부서이름
        을 조회하세요.
*/
SELECT
    ename 사원이름, job 직급, hiredate 입사일, sal 급여, dname 부서이름
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno
    AND job = 'MANAGER'
;
/*
    문제 2 ]
        급여가 가장 적은 사원의
            이름, 직급, 입사일, 급여, 부서이름, 부서위치를 
        조회하세요.
        
        두가지 방법 ]
            1. 서브질의로 해결하는 방법
            2. 서브질의의 결과를 테이블처럼 사용하는 방법
*/
-- 1.
SELECT
    ename, job, hiredate, sal, dname, loc
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno -- 조인조건
    AND sal = (
                    SELECT
                        MIN(sal)
                    FROM
                        emp
                )
;

-- 2.   ==> 서브질의의 결과를 테이블처럼 사용하는 방법
SELECT
ename, job, hiredate, sal, dname, loc
FROM
    emp e, dept d,
    (
        SELECT
            MAX(sal) max, MIN(sal) min, AVG(sal) avg, SUM(sal) total, COUNT(*) CNT
        FROM
            emp
    ) 
WHERE
    e.deptno = d.deptno
    AND sal = min
;

/*
    문제 3 ]
        사원이름이 5글자인 사원들의
            이름, 직급, 입사일, 급여, 급여등급
        을 조회하세요.
*/
SELECT
    ename, job, hiredate, sal, grade
FROM
    emp, salgrade
WHERE
    sal BETWEEN losal AND hisal -- non equi join 조건
--    AND LENGTH(ename) = 5
    AND ename LIKE '_____'
;
/*
    문제 4 ]
        입사일이 81년이고 직급이 'MANAGER'인 사원들의
            사원이름, 직급, 입사일, 급여, 급여등급, 부서이름, 부서위치를 
        조회하세요.
*/
SELECT
    ename, job, hiredate, sal, grade, dname, loc
FROM
    emp e, dept d, salgrade
WHERE
    e.deptno = d.deptno -- 조인조건
    AND sal BETWEEN losal AND hisal -- 조인조건
    AND TO_CHAR(hiredate, 'yy') = '81'  -- 일반조건
    AND job = 'MANAGER'                 -- 일반조건
;
--------------------------------------------------------------------------------------
/*
    SELF JOIN
        조인을 할 때 같은 테이블 조인해서 결과를 얻어내는 조인
*/

-- 예제 ] 사원들의 사원이름, 직급, 상사이름 을 조회하세요.
SELECT
    e.ename, e.job, e.mgr, se.empno, se.ename 
FROM
    emp e, emp se
WHERE
    e.mgr = se.empno
;
    
/*
    OUTER JOIN
    ==> INNER JOIN은 Cartisian Product 내에서 원하는 데이터를 조회하는 조인이다.
        그런데 조건에 사용되는 컬럼의 데이터가 null 인 경우는 
        해당 행은 Cartisian Product 에서 누락이 된다.
        
        이때 Cartisian Product 내에 없는 데이터를 조회하는 조인이 
        Outer Join 이다.
        
    형식 ]
        SELECT
            필드이름, 필드이름, ...
        FROM
            테이블1, 테이블2
        WHERE
            데이터1 = 데이터2(+)
        ;
        
        주의 ]
            (+) 는 NULL 로 표현되어야 할 테이블쪽의 컬럼에 붙여준다.
*/

-- 예제 ] 사원들의 사원이름, 직급, 상사번호, 상사이름을 조회하세요.
--          단, 상사가 없는 사원도 표시되게 하세요.
SELECT
    e.ename, e.job, e.mgr, se.ename
FROM
    emp e, -- 사원테이블
    emp se -- 상사테이블
WHERE
    e.mgr = se.empno(+)
;

/*
    문제 ]
        사원들의 
            사원이름, 급여, 상사이름, 상사급여, 상사급여와급여의차액
        을 조회하세요.
        단, 상사가 없는 사원도 조회되게 하세요.
*/
SELECT
    e.ename 사원이름, e.sal 사원급여, se.ename 상사이름, se.sal 상사급여, (se.sal - e.sal) "급여 차액"
FROM
    emp e, emp se
WHERE
    e.mgr = se.empno(+)
;
/*
    문제 ]
        사원들의 
            이름, 직급, 급여, 부서번호, 부서이름, 부서위치
        를 조회하세요.
        단, 사원이 없는 부서도 조회되게 하세요.
*/

SELECT
    ename, job, sal, d.deptno, dname, loc
FROM
    emp e, dept d
WHERE
    e.deptno(+) = d.deptno
;

SELECT
    ename, job, sal, d.deptno, dname, loc
FROM
    emp e, dept d
WHERE
    e.deptno = d.deptno
;

/*
    *****
    여기까지가 
    오라클에서만 사용가능한 JOIN 명령이다.
    따라서 다른 DBMS에서는 이 방법으로는 결과를 얻어낼 수 없다.
*/

--------------------------------------------------------------------------------------------
/*
    ANSI JOIN
    ==> 질의명령은 데이터베이스(DBMS)에 따라서 약간씩 문법이 달라진다.
        
        ANSI 형이란??
        ISO 협회(ANSI 협회)에서 통통의 질의 명령을 만들고자 해서 
        통일된 방식으로 명령을 만들어 놓은 것.
        
    1. CROSS JOIN
        ==> Cartisian Product 를 만들어내는 조인을 이야기 한다.
        
        실제 사용하기에는 부적합한 의미없는 조인
        
        형식 ]
            오라클의 경우
                SELECT
                    필드이름들...
                FROM
                    테이블, 테이블
                ;
                
            ANSI JOIN의 경우
                
                SELECT
                    필드들...
                FROM
                    테이블1 CROSS JOIN 테이블2
                ;
                
    2. INNER JOIN
        ==> EQUI, NON-EQUI JOIN, SELF JOIN 이 들어있다.
        
        형식 ]
            SELECT
                필드이름들....
            FROM
                테이블1 INNER JOIN 테이블2
            ON -- 조인 조건절
                조인조건식
            [
            WHERE
                일반조건식
            ]
            ;
            
        참고 ]
            일반 조건을 추가하고자 하면
            WHERE절을 이용해서 조건식을 추가할 수 있다.
            ***
            즉, ON 절은 오직 조인조건식에만 사용하는 절이다.
        참고 ]
            INNER JOIN 의 경우
            INNER JOIN 이라는 키워드 대시 JOIN 이라고만 기술해도 무방하다.
            
        형식 2 ]
            세개 이상의 테이블을 조인하는 경우
            SELECT
                필드이름들...
            FROM
                테이블1이름 [INNER ]JOIN 테이블2이름
            ON
                테이블1과 테이블2를 연결하는 조인조건식
            JOIN 테이블3
            ON
                위의 결과와 테이블3와 연결하는 조인조건식
            [ WHERE
                일반조건절 ]
            ;
            
    3. OUTER JOIN
        ==> ORACLE OUTER JOIN 과 같은 기능
        
        형식 ]
            SELECT
                필드들...
            FROM
                테이블1    LEFT 또는 RIGHT 또는 FULL 중 하나 OUTER JOIN   테이블2
            ON
                조인조건식
            [WHERE
                일반조건절 ]
            ;
            
            LEFT, RIGHT, FULL : 데이터가 있는 출력될 테이블쪽을 가리킨다.
            
*/

-- oracle CROSS JOIN
SELECT
    *
FROM
    emp, dept
;

SELECT
    *
FROM
    emp CROSS JOIN dept
;

SELECT
    *
FROM
    dept
;


-- ANSI JOIN
-- 사원들의 이름, 직급, 부서이름을 조회하세요.
SELECT
    ename, job, dname
FROM
    emp e INNER JOIN dept d
ON
    e.deptno = d.deptno
;

SELECT
    ename, job, dname
FROM
    emp e JOIN dept d
ON
    e.deptno = d.deptno
;

-- 예제 ] 81년 입사한 사원들의 이름, 직급, 입사일, 부서이름, 부서위치를 조회하세요.
SELECT
    ename, job, hiredate, dname, loc
FROM
    emp e JOIN dept d
ON
    -- JOIN 조건절
    e.deptno = d.deptno
WHERE
    -- 일반조건절
    TO_CHAR(hiredate, 'yy') = '81'
;

-- 예제 ] 사원들의 사원이름, 급여, 부서위치, 급여등급을 조회하세요.
SELECT
    e.ename, e.sal, d.loc, s.grade
FROM
    emp e JOIN dept d
ON
    -- ANSI EQUI JOIN
    e.deptno = d.deptno
JOIN salgrade s
ON
    -- ANSI NON-EQUI JOIN
    e.sal BETWEEN s.losal AND s.hisal
;

-- 예제 ] 사원들의 사원이름, 직급, 상사번호, 상사이름을 조회하세요.
SELECT
    e.ename, e.job, e.mgr, se.ename
FROM
    emp se RIGHT OUTER JOIN emp e
ON
    e.mgr = se.empno
;


-- 상사가 아닌 사원들도 표시..
SELECT
    e.ename, e.job, e.mgr, se.ename
FROM
    emp se FULL OUTER JOIN emp e
ON
    e.mgr = se.empno
;

/*
    *****
    오라클의 경우 FULL OUTER JOIN이 존재하지 않는다.
*/

----------------------------------------------------------------------------
/*
    NATURAL JOIN
    ==> 자동 조인으로 번역하며
        반드시 조인 조건식에 사용하는 필드의 이름이 동일하고
        반드시 동일한 필드가 한개인 사용할 수 있는 조인
        
        
        형식 ]
            SELECT
                필드들....
            FROM
                테이블1 NATURAL JOIN 테이블2
            ;
            
        참고 ]
            ON 절이 없는 이유
            <== 위의 전제조건때문에...
                이름이 같은 한개의 필드를 조인 조건으로 사용하게 된다.
                
    USING JOIN
        ==> 반드시 조인 조건식에 사용하는 필드의 이름이 동일한 경우
            같은 이름의 필드가 여러개 존재해도 무방하다.
            
        형식 ]
            SELECT
                필드들....
            FROM
                테이블1  JOIN   테이블2
            USING
                (조인조건에 사용할 필드이름)   
            ;
*/

-- 사원들의 사원이름, 직급, 부서이름을 조회하세요.
SELECT
    ename, job, dname
FROM
    emp NATURAL JOIN dept
;

SELECT
    ename, job, dname
FROM
    emp JOIN dept
USING
    (deptno)
;

------------------------------------------------------------------------------------------------------------------------
/*
    JOIN 의 활용
    ==> 서브질의를 활요하게되면 질의명령이 훨씬 간단하게 만들어진다.
*/

-- 각 부서별 급여 평균보다 적게 받는 사원들의 사원이름, 급여, 부서평균급여를 조회하세요.
SELECT
    ename, sal,
    (
        SELECT
            AVG(sal)
        FROM
            emp
        WHERE
            deptno = e.deptno
    ) 부서평균급여
FROM
    emp e
WHERE
    sal < (
                SELECT
                    AVG(sal)
                FROM
                    emp
                WHERE
                    deptno = e.deptno
            )
;

SELECT
    ename, sal,
    avg 부서평균급여
FROM
    emp e, 
    (
        SELECT
            deptno, AVG(sal) avg
        FROM
            emp
        GROUP BY
            deptno
    ) a
WHERE
    e.deptno = a.deptno
    AND sal < avg
;


-- 1. 각 부서의 최대 급여자의 정보를 조회하세요.
--          사원이름, 급여, 부서최대급여, 부서번호
-- oracle join, ansi join 두가지로 각각 처리하세요.

SELECT
    ename, sal, max, deptno
FROM
    emp JOIN    (
                    -- 조인할 가상의 테이블을 만들어서 쓰자...
                    SELECT
                        deptno dno, MAX(sal) max
                    FROM
                        emp
                    GROUP BY
                        deptno
                )
ON
    deptno = dno
WHERE
    sal = max
ORDER BY
    deptno, ename
;


------------------------------------------------------------------------------------------------

-- extra ]   급여의 합계가 가장 높은 부서의 사원중 부서 평균 급여보다 많이 받는 사원들의
--           사원이름, 급여, 부서번호, 부서이름, 부서평균급여, 부서급여합계 를 조회하세요.
SELECT
    deptno, SUM(sal), AVG(sal)
FROM
    emp
GROUP BY
    deptno
HAVING
    SUM(sal) = (
                    SELECT
                        MAX(SUM(sal))
                    FROM
                        emp
                    GROUP BY
                        deptno
                )
;

-- extra 2 ] 부서원수가 가장 많은 부서의 사원중 부서평균급여보다 많이 급여를 받는 사원의
--              사원이름, 부서번호, 급여, 부서평균급여, 부서급여합계, 부서원수 를 조회하세요.

------------------------------------------------------------------------------------------------