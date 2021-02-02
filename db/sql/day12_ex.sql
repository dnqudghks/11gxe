/*
    다음 문제들을 해결할 뷰를 만들어서 처리하세요.
    
    v01 이라는 뷰를 만들어서 처리..
*/
CREATE OR REPLACE VIEW v01
AS
    SELECT
        AVG(sal) avg, MAX(sal) max
    FROM
        emp   
;
/*
    문제 1 ]
        회사 평균 급여보다 급여를 적게 받는 사원들의
            사원이름, 급여, 회사평균급여
        를 조회하세요.
*/

SELECT
    ename 이름, sal 급여,
    (
        SELECT
            AVG(sal)
        FROM
            emp
    ) 평균급여
FROM
    emp
WHERE
    sal < (
                SELECT
                    AVG(sal)
                FROM
                    emp
            )
;

SELECT
    ename, sal, avg
FROM
    emp, v01
WHERE
    /*
        이 경우 v01 의 데이터는 한행만 존재하므로
        조인의 의미가 없어진다.
    */
    sal < avg
;

select
    e.*, 100
from
    emp e
;

/*
    문제 2 ]
        회사 최고 급여자의 
            사원번호, 사원이름, 직급, 부서이름, 급여, 회사최고급여
        를 조회하세요.
*/
SELECT
    empno, ename, job, dname, sal, max
FROM
    emp e, dept d, v01
WHERE
    e.deptno = d.deptno -- JOIN 조건
    AND sal = max
;

 ----------------------------------------------------------------------   
    -- v02 라는 뷰를 만들어서 처리하세요.  
CREATE OR REPLACE VIEW v02
AS
    SELECT
        deptno dno, SUM(sal) sum, AVG(sal) avg, COUNT(*) cnt
    FROM
        emp
    GROUP BY
        deptno
;
/*
    문제 3 ]
        급여를 가장 많이 받는 부서의 부서워들의
            사원이름, 직급, 급여, 부서이름, 부서급여합계
        를 조회하세요.
*/
SELECT
    ename, job, sal, dname, sum
FROM
    emp e, dept d, v02
WHERE
    e.deptno = d.deptno
    AND e.deptno = dno  -- 조인조건
    AND sum = (
                    SELECT
                        MAX(sum)
                    FROM
                        v02   
                )
;
/*
    문제 4 ]
        부서 평균급여보다 급여를 많이 받는 사원들의
            사원이름, 급여, 급여등급, 부서이름, 부서평균급여
        를 조회하세요.
*/
SELECT
    ename, sal, grade, dname, avg
FROM
    emp e, dept d, salgrade, v02 
WHERE
    e.deptno = d.deptno
    AND sal BETWEEN losal AND hisal
    AND e.deptno = dno              -- 조인조건
    AND sal > avg
;
/*
    문제 5 ]
        부서원수가 가장 많은 부서의 사원중 
        부서평균급여보다 급여를 적게 받는 사원들의
            사원이름, 직급, 급여, 부서이름, 부서평균급여, 부서원수
        를 조회하세요.
*/

SELECT
    ename, job, sal, dname, avg, cnt
FROM
    emp e, dept d, v02
WHERE
    e.deptno = d.deptno
    AND e.deptno = dno      -- 조인조건
    AND sal < avg
    AND cnt = (
                    SELECT
                        MAX(cnt)
                    FROM
                        v02
                )
;
