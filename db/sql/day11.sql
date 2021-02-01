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

/*
    문제 2 ]
        급여가 가장 적은 사원의
            이름, 직급, 입사일, 급여, 부서이름, 부서위치를 
        조회하세요.
        
        두가지 방법 ]
            1. 서브질의로 해결하는 방법
            2. 서브질의의 결과를 테이블처럼 사용하는 방법
*/

/*
    문제 3 ]
        사원이름이 5글자인 사원들의
            이름, 직급, 입사일, 급여, 급여등급
        을 조회하세요.
*/

/*
    문제 4 ]
        입사일이 81년이고 직급이 'MANAGER'인 사원들의
            사원이름, 직급, 입사일, 급여, 급여등급, 부서이름, 부서위치를 
        조회하세요.
*/

/*

*/

/*

*/
