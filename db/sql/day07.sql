-- day07

/*
    그룹함수
    ==> 여러 행의 데이터를 하나로 만들어서 뭔가를 계산하는 함수
    
    ***
    참고 ]
        그룹 함수는 결과가 오직 한개만 나오게 된다.
        (==> 여러행의 계산결과가 오직 한 행으로 처리된다.)
        따라서 그룹 함수는 결과가 여러행 나오는 경우와
        혼용해서 사용할 수 없다.
        
    예 ]
        SELECT ename FROM emp;  ==> 의 결과는 14 행이 조회된다.
        SELECT SUM(sal) FROM emp; ==> 의 결과는 오직 1 행만 조회가 된다.
        따라서
        SELECT ename, SUM(sal) FROM emp;
        는 조회 할 수 없다.
        
        SELECT 
            ename 사원이름,
            sal 사원급여,
            (
                SELECT
                    SUM(sal)
                FROM
                    emp
            ) 급여합계
        FROM
            emp
        ; ==> 이렇게 사용해야 한다.
        
        예 ]
            SELECT
                ename, SUM(sal)
            FROM
                emp
            WHERE
                ename = 'KING'
            ;
            
    종류 ]
        
        1. SUM
            ==> 데이터의 합계를 구하는 함수
            
            형식 ]
                SUM(필드이름)
                
            예 ]
                우리회사 사원들의 급여의 합계를 조회하세요.
                
                ==>
                SELECT
                    SUM(sal)
                FROM
                    emp
                ;
                
                -- 사원들의 커미션의 합계를 구하세요.
                ==>
                SELECT
                    SUM(nvl(comm, 0)), SUM(comm)
                FROM
                    emp
                ;
                
        2. AVG
            ==> 데이터의 평균을 구해주는 함수
            
            형식 ]
                AVG(필드이름)
                
            참고 ]
                NULL 데이터는 평균을 계산하는 부분에서 완전히 제외 된다.
                
            예 ]
                사원들의 평균 커미션을 조회하세요.
                
                사원수는 14명이고
                평균은 14명의 커미션의 합을 14로 나눈 값이다.
                
                SELECT
                    AVG(comm)
                FROM
                    emp
                ;
                
                SELECT
                    SUM(comm) 전체커미션, FLOOR(SUM(comm) / 14) 전체나누기, (SUM(comm) / 4) 네명나누기
                FROM
                    emp
                WHERE
                    comm IS NOT NULL
                ;
                
            ***
            참고 ]
                그룹함수 끼리는 결과가 한행씩 발생하므로 같이 사용할 수 있다.
                
                예 ]
                    사원들의 급여합계와 급여평균을 조회하세요.
                    
                    SELECT
                        SUM(sal) 급여합계, ROUND(AVG(sal), 2)  급여평균
                    FROM
                        emp
                    ;
                
        3. COUNT
            ==> 지정한 필드 중에서 데이터가 존재하는 필드의 갯수를 알려주는 함수
                ==> NULL 데이터는 연산에서 제외
                
            예 ]
                사원중 커미션이 있는 사원들의 수를 조회하세요.
                
                SELECT
                    COUNT(comm)
                FROM
                    emp
                ;
                
            참고 ]
                필드의 이름을 * 로 대신하면
                각각의 필드의 카운트를 따로 구한 후
                그 결과 중에서 가장 큰 값을 알려주게 된다.
                
                SELECT
                    COUNT(*)
                FROM
                    emp
                ; ==> 의미는 사원정보테이블의 사원수(데이터 갯수)를 조회하세요.
            
        4. MAX / MIN
            ==> 지정한 필드의 데이터 중에서 가장 큰값( 또는 작은값)을 반환해준다.
            
            형식 ]
                MAX(필드이름) / MIN(필드이름)
                
            예 ]
                사원들중 최고 급여와 최저 급여를 조회하세요.
                
                SELECT
                    MAX(sal) 최대급여, MIN(sal) 최소급여
                FROM
                    emp
                ;
        5. STDDEV
        ==> 표준편차를 반환해주는 함수
        
        
        6. VAIANCE
        ==> 분산을 반환해주는 함수
        
*/

-- 문제 ] 사원들의 직책의 갯수를 조회하세요.
SELECT
    COUNT(DISTINCT job)
FROM
    emp
;

------------------------------------------------------------------------
/*
    SELECT 질의 명령의 형식
    
        SELECT
        
        FROM
        
        [WHERE
            조건식...
        ORDER BY
            필드이름 ]
        ;
        
        SELECT
            필드이름들...
        FROM
            테이블이름
        [WHERE
            조건식 ]
        GROUP BY
            필드이름
        ;
        
    GROUP BY 절
    ==> 그룹함수에 적용되는 그룹을 지정하는 절
    
    *****
    참고 ]
        GROUP BY 를 사용하는 경우에는
        GROUP BY에 적용된 필드는 같이 출력이 가능하다.
        
        
*/

-- 30 번이 아닌 부서원들의 급여의 합계를 구하세요.
SELECT
    SUM(sal)
FROM
    emp
WHERE
    deptno <> 30
;

SELECT
    deptno, job, SUM(sal), COUNT(job)
FROM
    emp
GROUP BY
    deptno, job
;


SELECT
    COUNT(DISTINCT job)
FROM
    emp
WHERE
    deptno = 20
;

---------------------------------------------------------------------------------
/*
    예제 1]
        같은 부서끼리 묶어서 각 부서의 평균 급여를 조회하세요.
*/
SELECT
    deptno,  ROUND(AVG(sal), 2), SUM(sal), COUNT(*), ROUND(SUM(sal) / COUNT(*), 2) 평균급여
FROM
    emp
GROUP BY
    deptno
ORDER BY
    deptno
;
/*
    예제 2 ]
        각 직급마다 모두 몇사람이 있는지 조회하세요
        ==> 직책끼리 묶어서 카운트 한다.
*/
SELECT
    job 직급, COUNT(*) 사원수
FROM
    emp
GROUP BY
    job
;

-------------------------------------------------------------------------
/*
    문제 1 ]
        각 부서별로 가장 적은 급여는 얼마인지 조회하세요.
*/

SELECT
    deptno 부서번호, MIN(sal) 최소급여
FROM
    emp
GROUP BY
    deptno
ORDER BY
    deptno
;

/*
    문제 2 ]
        각 직책 별로 급여의 총액과 평균 급여를 조회하세요.
*/
SELECT
    job 직급, SUM(sal) 급여합계, ROUND(AVG(sal), 2) 평균급여
FROM
    emp
GROUP BY
    job
;
/*
    문제 3 ]
        입사 년도별로 평균 급여와 급여의 합계를 조회하세요.
*/
SELECT
    TO_CHAR(hiredate, 'YYYY') 입사년도, SUM(sal) 급여합계, ROUND(AVG(sal), 2) 평균급여
FROM
    emp
GROUP BY
    TO_CHAR(hiredate, 'YYYY')
;
/*
    문제 4 ]
        각 년도마다 입사한 사람의 수를 조회하세요.
*/
-- 입사년도를 기준으로 그룹화
SELECT
    TO_CHAR(hiredate, 'YYYY') 입사년도, COUNT(*) 사원수
FROM
    emp
GROUP BY
    TO_CHAR(hiredate, 'YYYY')
;
/*
    문제 5 ] 그냥 풀 것...
        사원 이름의 글자수가 4, 5 개인 각 사원의 수를 조회하세요.
        단, GROUP BY 절로 처리하세요.
*/
SELECT
    LENGTH(ename) 이름글자수, COUNT(*) 사원수
FROM
    emp
WHERE
    LENGTH(ename) IN (4, 5)
GROUP BY
    LENGTH(ename)
;

/*
    문제 6 ]
        81년도에 입사한 사원의 수를 직책별로 조회하세요.
*/
SELECT
    job 직급, COUNT(*) 사원수
FROM
    emp
WHERE
    TO_CHAR(hiredate, 'yy') = '81'
GROUP BY
    job
;

-- github url : https://github.com/increpas-cls2/11gxe

-----------------------------------------------------------------------------------------------------------
/*
    HAVING
    ==> 그룹화한 경우 조회된 결과 중에서 출력에 적용될 그룹을 지정하는 조건식
    
    **
    참고 ]
        WHERE   - 그룹화 하기 전 필터링 부분
        HAVING  - 그룹화 후 조건 제시
        
    
*/
SELECT
    deptno, count(*)
FROM
    emp
--WHERE
--    deptno IN (10, 20)
GROUP BY
    deptno
HAVING
    deptno IN (10, 20)
;

/*
    예제 ]
        직급별로 사원수를 계산하세요.
        단, 사원수가 1명인 직급은 조회에서 제외하세요.
*/
SELECT
    job 직급, COUNT(*) 사원수
FROM
    emp
GROUP BY
    job
HAVING
    COUNT(*) > 1
;

-- 예제 ] 부서별 평균급여를 조회하세요. 단, 평균급여가 2000 이상인 부서만 조회하세요.
/*
    1. 평균 급여 계산은 그룹 함수를 사용해서 처리해야 한다.                 ==> 그룹함수를 사용
    2. 부서별로 그룹화가 되서 평균이 처리되어야 한다.                       ==> GROUP BY 절 사용
    3. 그룹화 해서 처리된 결과중에서 원하는 데이터만 골라서 조회해야 한다.   ==> HAVING 절 사용
*/
SELECT
    deptno, ROUND(AVG(sal), 2) 부서평균급여
FROM
    emp
GROUP BY
    deptno
HAVING
    AVG(sal) >= 2000
;

----------------------------------------------------------------------------------------------
/*
    문제 7 ]
        사원이름 길이가 4, 5글자인 사람의 수를 부서별로 조회하세요.
        단, 사원수가 한사람 이하인 부서는 출력에서 제외하세요.
*/
SELECT
    deptno 부서번호, COUNT(*) 사원수
FROM
    emp
WHERE
    LENGTH(ename) IN (4, 5)
GROUP BY
    deptno
HAVING
    COUNT(*) > 1
;
/*
    문제 8 ]
        81년도 입사한 사람의 급여합계를 직책별로 조회하세요.
        단, 직책별 평균 급여가 1000 미만인 직책은 출력에서 제외하세요.
*/
SELECT
    job 직책, SUM(sal) 급여합계
FROM
    emp
WHERE
    TO_CHAR(hiredate, 'yy') = '81'
GROUP BY
    job
HAVING
    AVG(sal) >= 1000
;
/*
    문제 9 ]
        81년도 입사한 사람의 급여 합계를 사원의 이름 길이 별로 그룹화 하세요.
        단, 총 급여가 2000 미만인 경우는 출력에서 제외하고
        총 급여가 높은 순서에서 낮은 순서로 출력하세요.
*/
SELECT
    LENGTH(ename) 이름길이, SUM(sal) 급여합계
FROM
    emp
WHERE
    TO_CHAR(hiredate, 'yy') = '81'
GROUP BY
    LENGTH(ename)
HAVING
    SUM(sal) >= 2000
ORDER BY
    SUM(sal) DESC
;
/*
    문제 10 ]
        사원의 이름길이가 4, 5 글자인 사원의 부서별 사원수를 계산하세요. == WHERE, GROUP BY deptno
        단, 사원수가 0인 경우는 출력에서 제외하고    ==> HAVING
        부서번호 순서대로 출력하세요.    ==> ORDER BY
*/
SELECT
    deptno 부서번호, COUNT(*) 사원수
FROM
    emp
WHERE
    LENGTH(ename) BETWEEN 4 AND 5
GROUP BY
    deptno
HAVING
    COUNT(*) <> 0
ORDER BY
    deptno ASC
;

---------------------------------------------------------------------------------------------------------------------------
/*
    조건 처리함수와 그룹함수의 조합
    
    문제 ]
        부서별로 급여를 계산 하는데
        10번 부서는 평균을 계산하고
        20번 부서는 급여합계를 계산하고
        30번 부서는 최고급여를 계산해서 출력하세요.
        
*/

SELECT
    deptno 부서번호, 
    DECODE(deptno, 10, ROUND(AVG(sal), 2),
                    20, SUM(sal),
                    30, MAX(sal)
    ) 급여정보
FROM
    emp
GROUP BY
    deptno
;

SELECT
    deptno 부서번호,
    CASE deptno WHEN 10 THEN ROUND(AVG(sal), 2)
                WHEN 20 THEN SUM(sal)
                WHEN 30 THEN MAX(sal)
    END 부서급여정보
FROM
    emp
GROUP BY
    deptno
;

-------------------------------------------------------------------------------
/*
    서브질의
    ==> 질의 명령 안에 다시 질의 명령을 서브질의(서브쿼리)라고 한다.
*/

/*
    예제 ]
        이름이 'SMITH'인 사원의 부서의 
        부서번호, 평균급여, 최대급여, 최소급여, 급여합계를 조회하세요.
        
        ==> 먼저 'SMITH' 사원의 부서번호를 조회하고
            그 이후 GROUP BY 절로 그룹화 하고
            그룹함수를 사용해서 필드들을 꺼내면 된다.
*/

SELECT
    deptno, SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM
    emp
WHERE
    deptno = (
                SELECT
                    deptno
                FROM
                    EMP
                WHERE
                    ename = 'SMITH'
              )
GROUP BY
    deptno
;

SELECT
    deptno, SUM(sal), MAX(sal), MIN(sal), AVG(sal)
FROM
    emp
GROUP BY
    deptno
HAVING
    deptno = (
                SELECT
                    deptno
                FROM
                    emp
                WHERE
                    ename = 'SMITH'
            )
;

SELECT
    e.ename, 
    (
        SELECT
            SUM(sal)
        FROM
            emp
        GROUP BY
            deptno
        HAVING
            deptno = e.deptno
    ) 부서급여합계
FROM
    EMP e
;

/*
    *****
    서브질의를 SELECT 절에 사용할 경우
    해당 서브질의의 결과값은 반드시 한행, 한 필드만 조회되어야 한다.
*/

SELECT
    ename, deptno
FROM
    emp
WHERE
    deptno = 10
;

/*
    예제 ]
        'SMITH' 사원과 같은 직급의 사원들의
        사원번호, 사원이름, 급여, 직급을 조회하세요. 
*/

-- 'SMITH' 사원의 직급을 알아내는 질의 명령
SELECT
    job
FROM
    emp
WHERE
    ename = 'SMITH'
;


SELECT
    empno, ename, sal, job
FROM
    emp
WHERE
    job = 'CLERK'
;

SELECT
    empno, ename, sal, job
FROM
    emp
WHERE
    job = (
            SELECT
                job
            FROM
                emp
            WHERE
                ename = 'SMITH'
            )
;

/*
    FROM 절 내에도 서블질의를 기술 할 수 있다.
    이 경우는 조회되는 데이터가 단일필드, 단일행이 아니어도 상관없다.
    
    이 경우 FROM 절의 안의 서브질의를 부르는 단어가 별도로 있는데
    그것을 인라인 뷰(INLINE VIEW)라 부른다.
    
    이 서브질의는 테이블 처럼 사용할 수 있다.
*/

SELECT
    dno 부서번호, max 최대급여, min 최소급여, ROUND(avg, 2) 급여평균, total 급여합계, cnt 사원수
FROM
    (
        SELECT
            deptno dno, MAX(sal) max, MIN(sal) min, AVG(sal) avg,
            SUM(sal) total, COUNT(*) cnt
        FROM
            emp
        GROUP BY
            deptno
    )
WHERE
    dno = 10
;

-- 'SCOTT' 사원과 같은 부서 소속의 사원들의 
-- 부서번호, 최대급여, 최소급여, 급여평균, 급여합계, 사원수를 조회하세요.

SELECT
    dno 부서번호, max 최대급여, min 최소급여, ROUND(avg, 2) 급여평균, total 급여합계, cnt 사원수
FROM
    (
        SELECT
            deptno dno, MAX(sal) max, MIN(sal) min, AVG(sal) avg,
            SUM(sal) total, COUNT(*) cnt
        FROM
            emp
        GROUP BY
            deptno
    )
WHERE
    dno = (
                SELECT
                    deptno
                FROM
                    emp
                WHERE
                    ename = 'SCOTT'
            )
;

-- 'SCOTT' 사원의 사원번호, 사원이름, 급여, 부서최대급여를 조회하세요.

SELECT
    empno 사원번호, ename 사원이름, sal 급여, 
    (
        SELECT 
            MAX(sal) 
        FROM 
            emp 
        WHERE 
            deptno = e.deptno
    ) 부서최대급여
FROM
    emp e
WHERE
    ename = 'SCOTT'
;

------------------------------------------------------------------------
/*
    서블질의의 결과에 따른 사용법
        
        *****
        1. 결과물이 오직 단일 필드 단일행으로 조회되는 경우
        ==> 하나의 데이터로 간주하고 어느곳 에서든 사용할 수 있다.
            
            1) select 절에서 사용할 수 있다.
            
            2) select 명령 where 절에서 (조건절에서) 사용할 수 있다.
            
            3) update 조건식에 사용할 수 있다.
            
            4) update 데이터로 사용할 수 있다.
            
            5) INSERT 명령의 VALUES 절에도 사용가능하다.
            
            6) DELETE 명령의 조건식에도 사용가능
            
        2. 질의 결과가 단일필드 그리고 다중행으로 조회되는 경우
            ==> 이 경우는 조건절(WHERE, HAVING 절)에서만  사용가능하다.
                
                이 경우 사용가능한 연산자는
                    IN, ALL, ANY, EXIST
                가 있다.
                
                # 비교대상이 있는 경우
                    -- 비교 연산자 필요없는 경우
                    IN      ==> 여러개의 데이터중 하나만 맞으면 되는 경우
                            ==> 오직 동등비교(같다) 로 처리한다.
                    
                    -- 비교 연산자가 필요한 경우
                    ANY     ==> 여러개의 데이터 중 하나만 맞으면 되는 경우
                    
                    ALL     ==> 여러개의 데이터가 모두 맞으면 되는 경우
                
                # 비교대상이 없는 경우
                    EXIST   ==> 여러개의 데이터 중 하나만 맞으면 되는 경우
                            ==> 이후 오는 서브 질의의 결과가 있는지 여부를 묻는 연산자
                                따라서 비교대상이 존재하지 않는다.
                                
    ----------------------------------------------------------------------------------
        2. 서브질의의 결과가 여러필드 그리고 단일행으로 조회되는 경우
            1) INSERT 명령의 데이터
            2) UPDATE 명령의 SET 절에 사용가능
            
        3. 서브질의 결과가 여러필드 그리고 여러행으로 조회되는 경우
            1) SELECT 명령의 FROM 절 안에 사용
                ==> 이때 사용되는 서브질의를 특별히 "인라인 뷰"라 부른다.
                
            2) INSERT 명령의 데이터로 사용가능하다.
            
            3) CREATE 명령에서 테이블, 뷰를 만드는 용도로도 사용가능
*/

SELECT
    DISTINCT DEPTNO
FROM
    EMP
;

-- 예제 ] 직급이 'MANAGER'인 사원과 같은 부서에 속한 사원의 정보를 조회하세요.

-- 직급이 'MANAGER'인 사원들의 부서번호
SELECT
    DISTINCT deptno
FROM
    emp
WHERE
    job = 'MANAGER'
;

SELECT
    empno, deptno, ename, job
FROM
    emp
WHERE
    deptno IN (
                SELECT
                    DISTINCT deptno
                FROM
                    emp
                WHERE
                    job = 'MANAGER'
            )
;

-- any
-- 예제 ] 각부서의 평균 급여보다 하나라도 많이 받는 사원들의 사원이름, 급여를 조회하세요.

SELECT
    ename 사원이름, deptno 부서번호, sal 급여
FROM
    emp e
WHERE
    sal >  any (
                SELECT
                    AVG(sal)
                FROM
                    emp
                GROUP BY
                    deptno
            )
;

-- 모든 부서의 평균급여보다 높은 급여를 받는 사원의 사원이름, 부서번호, 급여를 조회하세요.
SELECT
    ename, deptno, sal
FROM
    emp
WHERE
    sal > ALL (
                    SELECT
                        AVG(sal)
                    FROM
                        emp
                    GROUP BY
                        deptno
                )
;

-- 예제 ] 40번 부서 소속사원이 존재하면 사원들의 정보를 조회하세요.
SELECT
    ename, deptno
FROM
    emp
WHERE
    EXISTS (
                SELECT
                    empno
                FROM
                    emp
                WHERE
                    deptno = 40
            )
;


-------------------------------------------------------------------------
/*
    문제 1 ]
        이름이 SMITH 인 사원과 동일한 직급을 가진 사원의
        사원이름, 직급, 부서번호를 조회하세요.
*/

-- SMITH 사원의 직급 조회 명령
SELECT
    job
FROM
    emp
WHERE
    ename = 'SMITH'
;

SELECT
    ename, job, deptno
FROM
    emp
WHERE
    job =   (
                SELECT
                    job
                FROM
                    emp
                WHERE
                    ename = 'SMITH'
            )
;
/*
    문제 2]
        회사 평균 급여보다 급여를 적게 받는 사원들의
        사원이름, 직급, 급여를 조회하세요.
*/
-- 회사 평균 급여
SELECT
    AVG(sal)
FROM
    emp
;


SELECT
    ename, job, sal
FROM
    emp
WHERE
    sal <   (
                SELECT
                    AVG(sal)
                FROM
                    emp
            )
;
/*
    문제 3 ]
        회사 최고 급여자의 사원번호, 사원이름, 급여를 조회하세요.
*/
SELECT
    empno, ename, sal
FROM
    emp
WHERE
    sal =   (
                SELECT
                    MAX(sal)
                FROM
                    emp
            )
;
/*
    문제 4 ]
        KING 사원보다 이후 입사한 사원의
        사원번호, 사원이름, 입사일을 조회하세요.
*/

-- KING 회장의 입사일
SELECT
    hiredate
FROM
    emp
WHERE
    ename = 'KING'
;

SELECT
    empno, ename, hiredate
FROM
    emp
WHERE
    hiredate > ( -- KING 의 입사일
                    SELECT
                        hiredate
                    FROM
                        emp
                    WHERE
                        ename = 'KING'
                )
;
/*
    문제 5 ]
        각 사원의 사원이름, 급여, 급여와 회사 평균 급여(AVG())와의 차를 조회하세요.
        단, 차는 절대값으로 표시(ABS())되게 하세요.
*/
-- 회사 평균 급여
SELECT
    AVG(sal)
FROM
    emp
;

SELECT
    ename 사원이름, sal 급여,
    TRUNC(ABS(
        sal - (
                    SELECT
                        AVG(sal)
                    FROM
                        emp
                )
    ), 2) "평균급여와의 차"
FROM
    emp
;
/*
    문제 6 ]
        급여의 합이 제일 높은 부서 소속의 사원들의
        사원번호, 사원이름, 급여 를 조회하세요.
*/
-- 부서별 급여의 합이 제일 큰 부서번호
SELECT
    deptno, SUM(sal)
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


SELECT
    empno, ename, sal, deptno
FROM
    emp
WHERE
    deptno =    (
                    SELECT
                        deptno
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
                )
;


/*
    문제 7 ]
        커미션을 받는 직원이 한사람이라도 있는 부서와 같은 부서에 속한 사원들의
        사원번호, 사원이름, 부서번호, 커미션을 조회하세요.
*/
-- 커미션을 받는 사원의 사원번호, 부서번호 조회
SELECT
    DISTINCT deptno
FROM
    emp
WHERE
    comm IS NOT NULL
;

SELECT
    deptno
FROM
    emp
GROUP BY
    deptno
HAVING
    COUNT(comm) > 0
;

-- 위의 결과의 부서에 속한 사원들의 정보 조회
SELECT
    empno 사원번호, ename 사원이름, deptno 부서번호, comm 커미션
FROM
    emp
WHERE
    deptno IN  (
                    SELECT
                        deptno
                    FROM
                        emp
                    GROUP BY
                        deptno
                    HAVING
                        COUNT(comm) > 0
                )
;


SELECT
    empno 사원번호, ename 사원이름, deptno 부서번호, comm 커미션
FROM
    emp
WHERE
    deptno IN  (
                    SELECT
                        DISTINCT deptno
                    FROM
                        emp
                    WHERE
                        comm IS NOT NULL
                )
;

/*
    문제 8 ]
        회사 평균급여보다 높고 이름의 글자수가 4 또는 5글자인 사원들의
        사원이름, 이름글자수, 직급, 부서번호를 조회하세요.
*/
-- 회사 평균 급여
SELECT
    AVG(sal)
FROM
    emp
;

SELECT
    ename 사원이름, LENGTH(ename) 이름글자수, job 직급, deptno 부서번호
FROM
    emp
WHERE
    LENGTH(ename) IN (4, 5)
    AND sal > (
                    SELECT
                        AVG(sal)
                    FROM
                        emp
                )
;

/*
    IN
    ==> 연산자 자체가 비교를 하는 연산자
        비교대상만 필요
        
        예 ]
            deptno IN (10, 30)
    ANY, ALL
    ==> 비교기능은 없고 데이터만 선택하는 연산자
        따라서 비교연산자, 비교대상이 필요하다.
            
            sal = ANY (1000, 500)
            
    EXISTS
    ==> 연산자 자체의 결과값이 참또는 거짓으로 반환해준다.
        따라서 대상없이 사용하는 연산자
        
        EXISTS (select * from emp)
*/


/*
    문제 9 ]
        사원이름이 4글자인 사원과 같은 직급을 가진 사원들의 
        사원이름, 직급 을 조회하세요.
*/
-- 이름이 네글자인 사원의 직급
SELECT
    DISTINCT job
FROM
    emp
WHERE
    LENGTH(ename) = 4
;


SELECT
    ename 사원이름, job 직급
FROM
    emp
WHERE
    job = ANY (
                    SELECT
                        DISTINCT job
                    FROM
                        emp
                    WHERE
                        LENGTH(ename) = 4
                ) 
;
/*
    문제 10 ]
        입사년도가 81년이 아닌 사원과 같은 부서에 소속된 사원들의
        사원이름, 부서번호, 입사일을 조회하세요.
*/

-- 입사년도가 81년이 아닌 사원들의 부서 조회
SELECT
    DISTINCT deptno
FROM
    emp
WHERE
    NOT TO_CHAR(hiredate, 'yy') = '81'
;

SELECT
    ename 사원이름, deptno 부서번호, hiredate 입사일
FROM
    emp
WHERE
    deptno = ANY    (
                        SELECT
                            DISTINCT deptno
                        FROM
                            emp
                        WHERE
                            NOT TO_CHAR(hiredate, 'yy') = '81'
                    )
;

/*
    문제 11 ]
        직책별 평균급여보다 하나라도 많이 받는 사원들의
        사원이름, 급여, 직급을 조회하세요.
        ==> ANY 연산자로 처리
*/
-- 직책별 평균급여
SELECT
    AVG(sal)
FROM
    emp
GROUP BY
    job
;

SELECT
    ename 사원이름, sal 급여, job 직급
FROM
    emp
WHERE
    sal > ANY   (
                    SELECT
                        AVG(sal)
                    FROM
                        emp
                    GROUP BY
                        job
                )
;
/*
    문제 12 ]
        모든 년도별 입사자의 평균 급여보다 많이 받는 사원들의
        사원이름, 급여, 입사년도 를 조회하세요.(ALL 연산자 사용)
*/
-- 년도별 평균급여
SELECT
    TO_CHAR(hiredate, 'yyyy') 입사년도, AVG(sal)
FROM
    emp
GROUP BY
    TO_CHAR(hiredate, 'yyyy')
;

SELECT
    ename 사원이름, sal 급여, hiredate 입사년도
FROM
    emp
WHERE
    sal > ALL (
                    SELECT
                        AVG(sal)
                    FROM
                        emp
                    GROUP BY
                        TO_CHAR(hiredate, 'yyyy')
                )
;
/*
    문제 13 ]
        회사 최고 급여자의 이름 글자수와 같은 글자수의 사원이 존재하면
        모든 사원들의 사원이름, 직급, 급여를 조회하고
        그렇지 않으면 조회하지 마세요.(EXISTS 사용)
*/

-- 최고 연봉자의 이름
SELECT
    ename
FROM
    emp
WHERE
    sal = (
                SELECT
                    MAX(sal)
                FROM
                    emp
            )
;

-- 최급급여자와 이름길이가 같은 사원
SELECT
    empno
FROM
    emp
WHERE
    LENGTH(ename) = (-- 최고급여자의 이름길이 
                        SELECT
                            LENGTH(ename)
                        FROM
                            emp
                        WHERE
                            sal = (
                                        SELECT
                                            MAX(sal)
                                        FROM
                                            emp
                                    )
                    )
;

--
SELECT
    ename 사원이름, job 직급, sal 급여
FROM
    emp
WHERE
    EXISTS ( --최고급여자와 같은 이름길이의 사원 
                SELECT
                    empno
                FROM
                    emp
                WHERE
                    LENGTH(ename) = (-- 최고급여자의 이름길이 
                                        SELECT
                                            LENGTH(ename)
                                        FROM
                                            emp
                                        WHERE
                                            sal = (
                                                        SELECT
                                                            MAX(sal)
                                                        FROM
                                                            emp
                                                    )
                                    )
            )
;






SELECT
    ename 사원이름, job 직급, sal 급여
FROM
    emp
WHERE
    EXISTS (
                SELECT
                    empno
                FROM
                    emp
                WHERE
                    LENGTH(ename) = (
                                        SELECT
                                            LENGTH(ename)
                                        FROM
                                            emp
                                        WHERE
                                            sal = (
                                                        SELECT
                                                            MAX(sal)
                                                        FROM
                                                            emp
                                                    )
                                    )
            )
;

-----------------------------------------------------------------------

SELECT
    EMPNO, ENAME, DEPTNO
FROM
    EMP
WHERE
    1 = 1
ORDER BY
    EMPNO
;

