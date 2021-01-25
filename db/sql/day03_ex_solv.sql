/*
숙제1
		emp 테이블에 있는 사원이름과 부서번호(deptno)를 출력하라.
*/
SELECT
    ename 사원이름, deptno 부서번호
FROM
    emp
;
/*
결과 ]
SQL> SELECT
  2      ename 사원이름, deptno 부서번호
  3  FROM
  4      emp
  5  ;

사원이름     부서번호
---------- ----------
SMITH		   20
ALLEN		   30
WARD		   30
JONES		   20
MARTIN		   30
BLAKE		   30
CLARK		   10
SCOTT		   20
KING		   10
TURNER		   30
ADAMS		   20
JAMES		   30
FORD		   20
MILLER		   10

14 행이 선택되었습니다.

SQL> 
*/



/*
숙제2
		emp 테이블에 있는 부서번호를 출력하라. 
		단, 중복된 부서번호는 하나만 출력하라.
*/
SELECT
    DISTINCT deptno 부서번호
FROM
    emp
;


/*
숙제3
		emp 테이블에 있는 사원의 이름과 연봉(sal * 12)를 출력하라.
*/
SELECT
    ename "사원의 이름", (sal * 12) 연봉
FROM
    emp
;

/*
숙제4
		emp 테이블에 있는 사원의 이름과 직책 그리고 
		총 급여액(연봉 + comm)을 출력하라.
*/
SELECT
    ename "사원의 이름", job "사원의 직책", ( (sal * 12) + NVL(comm, 0) ) "총 급여액"
FROM
    emp
;
/*
숙제5
		emp 테이블에 있는 사원의 이름과 직책, 입사일(hiredate)을
		출력하라
		단, 필드이름은 한글로 변환해서 출력하라.
*/
SELECT
    ename "사원의 이름", job "사원의 직책", hiredate 입사일
FROM
    emp
;

/*
숙제6
		emp 테이블에 있는 사원의 이름과 직책, 급여를 출력하라.
		단, 급여는 현재 급여의 10% 인상된 금액으로 출력하라.
*/
SELECT
    ename 사원이름, job 사원직책, sal * 1.1 인상급여
FROM
    emp
;
/*
숙제7
		emp 테이블에 있는 사원의 이름 앞에 "Mr."를 붙여서 출력하라.
*/
-- 문자열 결합연산사 - ||

SELECT
    ('Mr.' || ename) "사원의 이름"
FROM
    emp
;

/*
숙제8
		emp 테이블에 있는 모든 정보를 출력하라.
*/
SELECT * FROM emp;
/*
숙제9
		emp 테이블에 있는 직책과 부서 번호를 출력하라.
		단, 같은 직책과 부서 번호는 한번씩만 출력하라.
*/
SELECT
    DISTINCT job 직책, deptno "부서 번호"
FROM
    emp
;
/*
숙제10
		emp 테이블에 있는 사원이름, 직책, 입사일과
		커미션을 출력하라.
		단, 커미션은 현재 커미션에 200을 더한 결과를 출력하고
		커미션이 없는 사람은 300을 가지고 갈 수 있도록 출력하라.
*/

SELECT
    ename 사원이름, job 직책, hiredate 입사일, NVL(comm + 200, 300) 커미션
FROM
    emp
;

/*		
숙제11	부서 번호(deptno)가 10인 사원의 이름, 직책, 입사일, 부서번호를
		출력하세요.
*/
SELECT
    ename 이름, job 직책, hiredate 입사일, deptno 부서번호
FROM
    emp
WHERE
    deptno = 10
;
/*
숙제12	직책이 'SALESMAN'인 사원의 이름, 직책, 급여를 출력하세요
		단, 필드 이름은 한글로 출력하세요.
*/
SELECT
    ename 이름, job 직책, sal 급여
FROM
    emp
WHERE
    job = 'SALESMAN'
;


/*
숙제13	급여가 1000달러보다 적게받는 사원의 이름, 직책, 급여를
		출력하세요.
*/
SELECT
    ename 이름, job 직책, sal 급여
FROM
    emp
WHERE
    sal < 1000
;
/*
숙제14	사원의 이름이 'M' 이전의 문자로 시작하는 사람의
		이름, 직책, 급여를 출력하세요.
*/
SELECT
    ename 이름, job 직책, sal 급여
FROM
    emp
WHERE
    ename < 'Ma'
;
/*
    'M' < 'MA'
    'M' < 'MZ'
    'MZadsaopfdsafds' < 'Ma'
*/


/*
숙제15	입사일이 1981년 9월 8일 입사한 사람의 
		이름, 직책, 입사일을 출력하세요.
*/
SELECT
    ename 이름, job 직책, hiredate 입사일
FROM
    emp
WHERE
    hiredate = TO_DATE('1981/09/08', 'yyyy/MM/dd')
;
/*
숙제16	사원의 이름이 'M' 이후의 문자로 시작하는 사람중에서
		급여가 1000이상인 사람의
		이름, 직책, 급여를 출력하세요.
*/
SELECT
    ename 이름, job 직책, sal 급여
FROM
    emp
WHERE
    ename >= 'M'
    AND sal >= 1000
;
