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

/*
    문제 2 ]
        각 직책 별로 급여의 총액과 평균 급여를 조회하세요.
*/

/*
    문제 3 ]
        입사 년도별로 평균 급여와 급여의 합계를 조회하세요.
*/

/*
    문제 4 ]
        각 년도마다 입사한 사람의 수를 조회하세요.
*/

/*
    문제 5 ]
        사원 이름의 글자수가 4, 5 개인 사원의 수를 조회하세요.
        단, GROUP BY 절로 처리하세요.
*/

/*
    문제 6 ]
        81년도에 입사한 사원의 수를 직책별로 조회하세요.
*/
