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
    ★물어보기
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
    ename "사원의 이름", sal *12 연봉
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
    ename "사원의 이름", job "사원의 직책", sal * 1.1 인상급여
FROM
    emp
;


/*
숙제7
		emp 테이블에 있는 사원의 이름 앞에 "Mr."를 붙여서 출력하라.
*/

-- 문자열 결합연산자 - ||
SELECT
    ('Mr.' || ename) "사원의 이름"
FROM
    emp
;
/*
숙제8
		emp 테이블에 있는 모든 정보를 출력하라.
*/
SELECT
    *
FROM
    emp
;
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
    ename 사원이름, job 직책, hiredate 입사일, NVL(comm +200, 300) 커미션
FROM
    emp
;
/*
숙제11	부서 번호(deptno)가 10인 사원의 이름, 직책, 입사일, 부서번호를
		출력하세요.
*/
SELECT
    ename "사원의 이름", job 직책, hiredate 입사일, deptno 부서번호
FROM
    emp
WHERE
    deptno = 10 -- 동등비교연산자
;
/*
숙제12	직책이 'SALESMAN'인 사원의 이름, 직책, 급여를 출력하세요
		단, 필드 이름은 한글로 출력하세요.
*/
SELECT
    ename "사원의 이름", job 직책, sal 급여
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
    ename "사원의 이름", job 직책, sal 급여
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
    ename "사원의 이름", job 직책, sal 급여
FROM
    emp
WHERE
    ename < 'Ma'
;
/*
    'M' < 'MA'
    'M' < 'MZ'
    'MZasdfeadf' < 'Ma'
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
    ename 이름, job  직책, sal 급여
FROM
    emp
WHERE
    ename >= 'M' and sal >= 1000
;

-------------------------------------------------
-- NOt 연산자 : 부정 연산자
-- 부서번호가 10번이 아닌 사원의 사원이름, 직책, 부서번호를 조회하세요.

SELECT
    ename 사원이름, job 직책, deptno 부서번호
FROM
    emp
WHERE
    -- deptno <> 10
    not deptno != 10 
;

/*
    ★★★★★ 중요 ★★★★★
    NUll 데이터는 모든 연산에서 제외가 된다.
    따라서 비교연산에서도 연산을 수행하지 않는다.
    연산결과는 NULL로 표현된다.
    
    따라서 NULL데이터의 비교는 연산자를 따로 만들어서 제공해주고 있다.
    
        IS NULL     - NULL이면 true
        IS NOT NULL - NULL이 아니면 true 
*/

-- 커미션이 없는 사원들의 사원이름, 부서번호, 커미션을 조회하세요.
SELECT
    ename 사원이름, deptno 부서번호, comm 커미션
FROM
    emp
WHERE
    comm IS NULL
    -- comm IS not NULL
    -- where 절 내의 연산결과는 반드시 true 또는 false 만 발생되어야 한다.
    -- not 위치 기억
;
/*
    범위 비교 연산자
        BETWEEN A AND B
        
    다중값 비교 연산자
        대상 IN (데이터1, 데이터2, ...)
        ==> 대상이 데이터1이거나 데이터2이거나 ...인 경우는 true
*/

-- 부서번호가 20, 30번인 사원들의 사원이름, 직급, 부서번호를 조회하세요.
SELECT
    ename 사원이름, job 직급, deptno 부서번호
FROM
    emp
WHERE
    deptno IN (20, 30)
    -- deptno NOT IN (20, 30)
    -- NOT deptno IN (20, 30)
;

-- 사원의 직책이 'CLERK' 또는 'SALESMAN'인 사원들의 사원번호, 사원이름, 직책, 급여를 조회하세요.
SELECT
    empno 사원번호, ename 사원이름, job 직책, sal 급여
FROM
    emp
WHERE
    job IN ('CLERK', 'SALESMAN')
;

----------------------------------------------------------

/*
    LIKE 연산자 - 문자열 비교연산자
    
    문자열을 처리하는 경우에만 사용하는 방법으로
    문자열에 일부분을 와일드카드 처리하여
    조건식을 제시하는 방법이다.
    
    형식 ]
        필드이름(또는 데이터) LIKE '와일드카드 포함 문자열'
        
    의미 ]
        필드의 데이터가 지정한 문자열과 동일한지를 판단한다.
        
    참고 ]
        와일드카드 사용법
        
            _ : 한개당 한글자만 와일드카드로 지정하는것
            % : 글자수에 관계없이 모든 문자를 포함하는 와일드카드
            
        예 ]
            'M%'         ==> M으로 시작하는 모든 문자열. 'M'도 포함된다.
                             %는 0개 이상의 문자열을 의미
            
        예 2]
            'M____'      ==> M으로 시작하는 글자수가 6개인 문자열
        
        예 3]
            '%M'         ==> M으로 끝나는 모든 문자열. 'M'도 포함된다.
*/

-- 사원 이름이 5글자인 사람의 이름, 직급을 조회하세요.

SELECT
    ename 이름, job 직급
FROM
    emp
WHERE
    ename LIKE '_____'
;

--> 문자열 처리함수를 사용해서 처리하는 방법
SELECT
    ename 이름, job 직급
FROM
    emp
WHERE
    LENGTH(ename) = 5
;

-- 이름의 두번째 문자가 'A'인 사원의 사원이름, 직급을 조회하세요.
SELECT
    ename, job
FROM
    emp
WHERE
    ename LIKE '_A%'
;

-- 문제 ] 입사월이 1월인 사원의 사원번호, 사원이름, 입사일을 조회하세요.
SELECT
    empno 사원번호, ename 사원이름, hiredate 입사일
FROM
    emp
WHERE
    hiredate LIKE '____/01/__'
    --hiredate LIKE '____/01%'
    --TO_CHAR(hiredate,'yyyy/MM/dd')LIke '____01%'
;

-- 문자열 변환함수로 처리하는 방법
SELECT
    empno 사원번호, ename 사원이름, hiredate 입사일
FROM
    emp
WHERE
    To_CHAR(hiredate, 'MM') = '01'
-----------------------------------------------------------
/* ##
숙제1	직책이 'MANAGER'이면서 급여는 1000보다 크면서
		부서 번호가 10번 부서에 근무하는 사원의
		이름, 직책, 급여, 부서번호를 출력하세요.
*/
SELECT
    ename 이름, job 직책, sal 급여, deptno 부서번호
FROM
    emp
WHERE
    job = 'MANAGER',
    sal > 1000,
    deptno = 10
;
/*
숙제2	직책이 'MANAGER'를 제외한 모든 사원의
		이름, 직책, 입사일을 출력하세요.	NOT 연산자를 이용할것
*/
SELECT
    ename 이름, job 직책, hiredate 입사일
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
    ename 이름, job 직책, sal 급여
FROM
    emp
WHERE
    ename BETWEEN 'C' AND 'D'
    
;
/*
숙제4	급여가 800, 950이 아닌 사원의
		이름, 직책, 급여를 출력하세요
		단 IN을 사용해서 출력하라.
*/
SELECT
    ename 이름, job 직채, sal 급여
FROM
    emp
WHERE
    sal NOT IN (800, 950)
;

/*
숙제5		사원의 이름이 S으로 시작하고 글자수가 5글자인 사원의
			이름, 직책을 출력하라.
*/
SELECT
    ename 이름, job 직책
FROM
    emp
WHERE
    ename LIKE 'S____'
;

/*
숙제6		입사일이 3일인 사원의
			이름, 직책, 입사일을 출력하라.
*/
SELECT
    ename 이름, job 직책, hiredate 입사일
FROM
    emp
WHERE
    hiredate LIKE '____/__/03'
;

/*
숙제7		사원의 이름이 4글자 이거나 5글자인 사원의
			이름, 직책을 출력하라.
*/
SELECT
    ename 이름, job 직책
FROM
    emp
WHERE
    ename LIKE ('____' or '_____')
;
/*
숙제8		입사년도가 81년도이거나 82년도인 사원의
			이름과 급여를 출력하라.
			단 급여는 현재 급여에 10%를 인상해서 출력하도록 한다.
*/
SELECT
    ename 이름, sal * 1.1 급여
FROM
    emp
WHERE
    hiredate LIKE ('1981/__/__')
    OR ('1982/__/__')
;
/*
숙제9		사원의 이름이 'S'로 끝나는 사원의 
			이름과 급여, 커미션을 출력하라.
			단, 커미션은 현재 커미션의 100을 증가해서 출력하고
			커미션이 없는 사람도 100을 주도록 한다.
*/
SELECT
    ename 이름, sal 급여, NVL(comm + 100, 100) 커미션
FROM
    emp
WHERE
    ename LIKE('%S')
;




