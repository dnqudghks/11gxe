/*
숙제1	직책이 'MANAGER'이면서 급여는 1000보다 크면서
		부서 번호가 10번 부서에 근무하는 사원의
		이름, 직책, 급여, 부서번호를 출력하세요.
*/
SELECT
    ename, job, sal, deptno
FROM
    emp
WHERE
    job = 'MANAGER'
    AND sal > 1000
    AND deptno = 10
;
/*
숙제2	직책이 'MAMAGER'를 제외한 모든 사원의
		이름, 직책, 입사일을 출력하세요.	NOT 연산자를 이용할것
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    NOT job = 'MANAGER'
;
/*
숙제3	사원의 이름이 'C'로 시작하는것 보다 크고
						'M'으로 시작하는 것 보다 작은 사원만
		이름, 직책, 급여를 출력하세요.
		단	BETWEEN을 사용해서 출력하라.
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename >= 'D'
    AND ename < 'M'
;

SELECT
    ename, job, sal
FROM
    emp
WHERE
    ename BETWEEN 'D' AND 'LZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
;

/*
숙제4	급여가 800, 950이 아닌 사원의
		이름, 직책, 급여를 출력하세요
		단 IN을 사용해서 출력하라.
*/
SELECT
    ename, job, sal
FROM
    emp
WHERE
    NOT sal IN (800, 950)
;
/*
숙제5		사원의 이름이 S으로 시작하고 글자수가 5글자인 사원의
			이름, 직책을 출력하라.
*/
SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE 'S____'
;

SELECT
    ename, job
FROM
    emp
WHERE
    SUBSTR(ename, 1, 1) = 'S'
    AND LENGTH(ename) = 5
;
/*
숙제6		입사일이 3일인 사원의
			이름, 직책, 입사일을 출력하라.
*/
SELECT
    ename, job, hiredate
FROM
    emp
WHERE
    hiredate LIKE '____/__/01'
--    TO_CHAR(hiredate, 'yyyy/MM/dd') LIKE '____/__/01'
;

/*
숙제7		사원의 이름이 4글자 이거나 5글자인 사원의
			이름, 직책을 출력하라.
*/
SELECT
    ename, job
FROM
    emp
WHERE
    LENGTH(ename) IN (4, 5)
;

SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE '____'
    OR ename LIKE '_____'
;


/*
숙제8		입사년도가 81년도이거나 82년도인 사원의
			이름과 급여를 출력하라.
			단 급여는 현재 급여에 10%를 인상해서 출력하도록 한다.
*/
SELECT
    ename, sal * 1.1
FROM
    emp
WHERE
    hiredate BETWEEN '1981/01/01' AND '1983/01/01'
;

SELECT
    ename 이름, sal * 1.1 급여
FROM
    emp
WHERE
    TO_CHAR(hiredate, 'yy') IN ('81', '82')
;

SELECT
    ename 이름, sal * 1.1 급여
FROM
    emp
WHERE
    hiredate LIKE '1981%'
    OR hiredate LIKE '1982%'
;
/*
숙제9		사원의 이름이 'S'로 끝나는 사원의 
			이름과 급여, 커미션을 출력하라.
			단, 커미션은 현재 커미션의 100을 증가해서 출력하고
			커미션이 없는 사람도 100을 주도록 한다.
*/
SELECT
    ename, sal, NVL(comm + 100, 100) comm
FROM
    emp
WHERE
    ename LIKE '%S'
;

----------------------------------------------------------------
/*
    조회된 결과 정렬해서 출력하기
    
    형식 ]
        
        SELECT
        
        FROM
        
        WHERE
        
        ORDER BY
            필드이름 ASC[ 또는 DESC], 필드이름 ASC [또는 DESC]
        ;
        
        ASC     -   오름 차순 정렬(기본값)
        DESC    -   내림 차순 정렬
        
*/

-- 9번 문제의 결과를 급여를 기준으로 오름차순 정렬해서 출력하세요.
SELECT
    ename, sal, NVL(comm + 100, 100) comm
FROM
    emp
WHERE
    ename LIKE '%S'
ORDER BY
    sal ASC
;

-- 사원들의 사원번호, 사원이름, 급여, 부서번호를 조회하는데
-- 부서번호가 큰부서부터 조회되게 하고
-- 같은 부서는 급여가 작은 사원부터 조회되게 하세요.

SELECT
    empno, ename, sal, deptno
FROM
    emp
ORDER BY
    deptno DESC, sal ASC
;

