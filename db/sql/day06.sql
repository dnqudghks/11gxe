-- day06

/*
    NULL 처리함수
        1. NVL(필드이름 또는 연산식, 널일경우 대신할 데이터)
        
        2. NVL2(필드이름, 처리내용, 널일경우 대신할 데이터)
        
        3. NULLIF
            
            형식 ]
                NULLIF(데이터1, 데이터2)
                
            의미 ]
                두데이터가 같으면 NULL 로 처리하고
                두데이터가 다르면 데이터1으로 처리하세요.
            
            예 ]
                SELECT NULLIF('a', 'a') FROM dual;
                SELECT NULLIF('a', 'A') FROM dual;
                
        4. COALESCE
            형식 ]
                COALESCE(데이터1, 데이터2, .... )
                
            의미 ]
                여러개의 데이터중 가장 첫번째 나오는 NULL 이 아닌 데이터를 출력해주세요.
                
            예 ]
                
                SELECT
                    ename 사원이름,
                    COALESCE(
                        comm, mgr, sal
                    ) 
                FROM
                    emp
                ;
                
*/

-- 예제 ] 커미션에 50%를 추가해서 지급하고자 한다.
--          만약 커미션이 존재하지 않으면 급여를 이용해서 10%를 지급하고자 한다.
--          COALESCE 함수를 사용해서 처리하세요.
SELECT
    ename, comm, sal,
    COALESCE(comm * 1.5, sal * 0.1) 지급공돈
FROM
    emp
;


--------------------------------------------------------------------------------------------
/*
    조건 처리 함수
        ==> 함수라기 보다는 마치 명령어에 가까운 것...
            자바의 switch, if을 대신하기 위해서 만들어 놓은 것.
            
    1. DECODE(필드이름 또는 연산식, 값1, 처리내용1,
                                        값2, 처리내용2,
                                        값3, 처리내용3,
                                        .....
                                        [처리내용N])
                            
            의미 ]
                필드의 내용이 값1이면 처리내용1을 실행하고
                                값2면 처리내용2를 실행하고
                                ....
                                그 이외의 값이면 처리내용N을 실행해주세요.
            
            주의 1 ]
                데이터1, 데이터2, .... 는 단일값 데이터만 기술해야 한다.
                
            주의 2 ]
                처리내용 들의 결과 타입은 모두 같아야 한다.
                
    2. CASE(if 명령에 해당하는 명령)
    
        형식 1 ]
            CASE    WHEN    조건식1    THEN    내용1
                    WHEN    조건식2    THEN    내용2
                    .....
                    ELSE    내용n
            END
                    
            의미 ]
                조건식1이 참이면 내용1을 실행
                조건식2가 참이면 내용2를 실행하고
                .....
                그 이외의 경우에는 내용n을 실행하세요.
                
                
        형식 2 ]
            
            CASE    필드이름    WHEN    값1      THEN    실행1
                                WHEN    값2      THEN    실행2
                                WHEN    값3      THEN    실행3
                                .....
                                ELSE    실행n
            END
            
            의미 ]
                DECODE() 함수와 동일한 의미
*/

/*
    문제 ] 
        사원정보테이블에서 사원의 이름, 직급, 부서번호, 부서이름 을 조회하세요.
        단, 부서번호가 10 인 경우는 영업부
                        20 인 경우는 총무부
                        30 인 경우는 개발부
                        40 인 경우는 인사부
        로 처리하세요.
        
*/

SELECT
    ename 사원이름, job 직급, deptno 부서번호,
    DECODE(deptno, 10, '영업부',
                    20, '총무부',
                    30, '개발부',
                    40, '인사부') 부서이름
FROM
    emp
;

/*
    각 부서별로 이번달 보너스가 달라진다.
        10번 부서는 급여의 10%
        20번 부서는 급여의 15%
        30번 부서는 급여의 20%
        그 이외의 부서는 급여의 30% 를 지급하기로 했다.
        
        사원들의 사원이름, 부서번호, 원급여, 지급급여를 조회하세요. 
*/

SELECT
    ename 사원이름, deptno 부서번호, sal 원급여,
    DECODE(deptno, 10, sal * 1.1,
                    20, sal * 1.15,
                    30, sal * 1.2,
                    sal * 1.3
    ) 지급급여
FROM
    emp
;

SELECT
    DISTINCT job
FROM
    emp
;


/*
    문제 ] 각 사원들의 직책을 한국어로 번역해서 조회하세요.
            CLERK       - 점원
            SALESMAN    - 영업사원
            PRESIDENT   - 대빵
            MANAGER     - 작은대빵
            ANALYST     - 분석가
*/
SELECT
    ename 사원이름, job 직급,
    DECODE(job, 'CLERK', '점원',
            'SALESMAN', '영업사원',
            'PRESIDENT', '대빵',
            'MANAGER', '작은대빵',
            'ANALYST', '분석가'
    ) 한글직급
FROM
    emp
;
/*
    입사년도를 기준으로 하여
    80년에 입사한 사원은 'A'
    81년에 입사한 사원은 'B'
    82                   'C'
    그 나머지는          'D'
    등급으로 구분하려 한다.
    사원들의 사원이름, 입사일, 입사등급을 조회하세요.
*/

SELECT
    ename 사원이름, hiredate 입사일,
    DECODE(TO_CHAR(hiredate, 'yy'), '80', 'A',
                                    '81', 'B',
                                    '82', 'C',
                                    'D'
    ) 입사등급
FROM
    emp
ORDER BY
    hiredate
;

/*
    급여가 $1000 미만이면 급여를 20% 인상하고
            $1000 ~ 3000 이면 15% 인상하고
            3001 이상이면 10% 이상한 급여를 지급하려 한다.
    사원들의 사원이름, 원급여, 지급급여를 조회하세요.
*/
SELECT
    ename 사원이름, sal 급여,
    DECODE(FLOOR(sal / 1000), 0, sal * 1.2,
                              1, sal * 1.15,
                              2, sal * 1.15,
                              3, DECODE(MOD(sal, 1000), 0, sal * 1.15, sal * 1.1),
                              sal * 1.1
    ) 지급급여
FROM
    emp
;

SELECT
    ename 사원이름, sal 급여,
    CASE    WHEN sal < 1000 THEN sal * 1.2
            WHEN sal <= 3000 THEN sal * 1.15
--            WHEN sal BETWEEN 1000 AND 3000 THEN sal * 1.15
            ELSE sal * 1.1
    END 지급급여
FROM
    emp
;
-- decode()와 case when then 두가지로 처리하세요.
/*
    문제 1 ]
        사원이름이 4글자이면 'Mr.'를 이름앞에 붙이고
        4글자가 아니면 '사원'을 이름뒤에 붙여서 조회하세요.
*/
SELECT
    ename 사원이름, LENGTH(ename) 이름글자수,
    DECODE(LENGTH(ename), 4, CONCAT('Mr.', ename),
                            CONCAT(ename, '사원')
    ) 표시이름1,
    CASE LENGTH(ename) WHEN 4 THEN CONCAT('Mr.', ename)
                        ELSE CONCAT(ename, '사원')
    END 표시이름2,
    CASE WHEN LENGTH(ename) = 4 THEN CONCAT('Mr.', ename)
            ELSE CONCAT(ename, '사원')
    END 표시이름3
FROM
    emp
;
/*
    문제 2 ]
        부서번호가 10번 혹은 20번이면 급여 + 커미션의 결과를 출력하고
        (커미션이 없으면 0으로 대신 연산하고)
        그 이외의 부서는 급여만 출력하세요.
*/
SELECT 
    ename, deptno, sal, comm,
    CASE WHEN deptno IN (10, 20) THEN sal + NVL(comm, 0)
         ELSE sal
    END 지급급여1,
    DECODE(deptno, 10, sal + NVL(comm, 0),
                    20, sal + NVL(comm, 0),
                    sal
    ) 지급급여2,
    DECODE(FLOOR(deptno / 30), 0, sal + NVL(comm, 0),
                                sal
    ) 지급급여3
FROM
    emp
;
/*
    문제 3 ]
        입사요일이 토요일, 일요일인 사원은 급여를 20% 증가해서 지급하고
        그 이외에 입사한 사람은 급여의 10%를 더해서 지급하세요.
*/
SELECT
    ename, TO_CHAR(hiredate, 'day') 입사요일,
    CASE    WHEN TO_CHAR(hiredate, 'day') IN ('토요일', '일요일') THEN sal * 1.2
            ELSE sal * 1.1
    END 지급급여1,
    DECODE(TO_CHAR(hiredate, 'day'),    '토요일', sal * 1.2,
                                        '일요일', sal * 1.2,
                                        sal * 1.1
    ) 지급급여2
FROM
    emp
;

SELECT
    TO_CHAR(sysdate, 'day') 오늘요일
FROM
    dual
;

/*
    문제 4 ]
        근무월수가 450개월 이상이면 커미션을 500 달러를 추가해서 지급하고(널인경우는 0으로 연산)
        근무월수가 450개월 미만이면 커미션을 현재 커미션만 지급하도록 하세요.
        
        사원이름, 근무개월수, 급여, 커미션, 지급커미션 를 조회하세요.
*/

SELECT
    ename 사원이름, FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)) 근무개월수, sal 급여, comm 커미션,
    DECODE(FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate) / 450), 0, comm,
                                                            NVL(comm, 0) + 500
    ) 지급커미션1,
    CASE FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate) / 450) WHEN 0 THEN comm
        ELSE NVL(comm, 0) + 500
    END 지급커미션2,
    CASE WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)) < 450 THEN comm
        ELSE NVL(comm, 0) + 500
    END 지급커미션3
FROM
    emp
;


/*
    문제 5 ]
        이름의 글자수가 5글자 이상인 사람은 앞 세글자는 표현하고 나머지는 *을 붙여서 출력하고
        이름의 글자수가 4글자 이하인 사람은 모두 보여지도록 조회하세요.
        
        사원이름, 이름글자수, 표시이름   의 형태로 조회하세요.
        
        힌트 ]
            이름 글자수가 5글자 미만인 사람과 그 외의 사람...
            
            FLOOR(LENGTH(ename) / 5)    ==> 5글자 미만인 경우 0
                                            그 이외의 경우    1~
*/

SELECT
    ename 사원이름, LENGTH(ename) 이름글자수, 
    DECODE(
        FLOOR(LENGTH(ename) / 5), 0, ename,
                                    RPAD(SUBSTR(ename, 1, 3), LENGTH(ename), '*')
    ) 표시이름1,
    CASE FLOOR(LENGTH(ename) / 5) WHEN 0 THEN ename
        ELSE RPAD(SUBSTR(ename, 1, 3), LENGTH(ename), '*')
    END 표시이름2,
    CASE WHEN LENGTH(ename) < 5 THEN ename
        ELSE RPAD(SUBSTR(ename, 1, 3), LENGTH(ename), '*')
    END 표시이름3
FROM
    emp
;








