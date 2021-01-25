/*
숫제1.	1년은 365일이라고 가정하고
		우리 회사 직원 근무일수를 년으로만 표시하고
		대신 소수이하는 버린다.
*/
SELECT
    ename 사원이름, FLOOR((sysdate - hiredate) / 365) 근무년수
FROM
    emp
;

/*
숙제2.	사원의 근무년수를 년, 월로 표시하라?
		
		힌트		총 개월수를 12로 나눈 몫은 년수가 되고
					총 개월수를 12로 나눈 나머지가 월수가 된다.
					
					25개월 근무했으면	2년 1개월
                    
                    ==> MONTHS_BETWEEN(DATA1, DATA2)
*/
SELECT
    ename, MONTHS_BETWEEN(SYSDATE, hiredate) 근무총개월수,
    FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)/12) 근무년수, 
    MOD(FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)), 12) 잔여개월수,
    CONCAT(CONCAT(FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)/12), '년 '), CONCAT( MOD(FLOOR(MONTHS_BETWEEN(SYSDATE, hiredate)), 12), '개월')) 근무기간
FROM
    emp
;

/*
숙제3	사원이 첫급여를 받을때 까지 근무일수를 출력하라.

		힌트	날짜 - 날짜는 두 날짜 사이의 날수가 나온다.
*/
SELECT
    ename 사원이름, HIREDATE 입사일, (LAST_DAY(hiredate) - hiredate) "첫봉급 근무일수"
FROM
    emp
;

/*
숙제4.	사원이 회사에 들어와서 처음 맞이한 주말(토요일)이 몇일인지를 출력하라.
*/
SELECT
    ename 사원이름, hiredate 입사일, 
    TO_CHAR(hiredate, 'DAY') 입사요일, 
    NEXT_DAY(hiredate, '토') 첫번째토요일
FROM
    emp
;

/*
숙제5	사원의 근무년수는 입사한 달의 1일을 기준으로 산출해야한다.
		사원의 근무년수 기준일을 출력하도록 하라.
		단, 15일 이전 입사자는 그달로 근무기준일로 잡고
			16일 이후 입사자는 다음달로 근무 기준일을 잡는다.
*/
SELECT
    ename 사원이름, hiredate 입사일, ROUND(hiredate, 'MONTH') 근무기준일
FROM
    emp
;
/*
숙제6
	사원의 급여를 출력하는데
	모두 10자리로 출력하고 앞에 빈 공간은 *로 채워서 출력하라.
*/
SELECT
    ename 사원이름, sal 숫자급여,
    LPAD(
            TO_CHAR(sal), 
            10, 
            '*'
    ) 급여
FROM
    emp
;
/*
숙제7
	사원중에서 월요일에 입사한 사람의 정보를 출력하라.
*/
SELECT
    ename 사원이름, hiredate 입사일, TO_CHAR(hiredate, 'day') 입사요일
FROM
    emp
WHERE
    TO_CHAR(hiredate, 'day') IN ('월', '월요일')
;
/*
숙제8
	사원 급여 중에서 백단위가 0인 사람의 정보를 출력하라.
	힌트	문자로 변환한 후 끝에서 3번째 글자가 0인 사람이 해당된다.
*/
SELECT
    ename 사원이름, sal 급여
FROM
    emp
WHERE
    SUBSTR(TO_CHAR(sal), -3, 1) = '0'
;
/*
숙제9
	==>	여러분의 생년월일을 이용하여
		지금까지 몇년 몇개월을 살고 있는지 알아보자.

		힌트	MONTHS_BETWEEN 함수를 적용해보자.
*/

/*
숙제10	사원의 정보를 출력하는데....
		커미션이 없는 사람은 'None'을 출력하도록 하자.

		힌트	comm을 'None'으로 바꾸지 못한다.
				이유는 형태가 다르기 때문이다.
				형태를 문자로 맞춰주면 바뀌지 않을까?
*/

SELECT
    ename 사원이름, comm commition, NVL(TO_CHAR(comm), 'None') 커미션
FROM
    emp
;


-----------------------------------------------------------------------------------------------------------------------------
/*                
        weekend bonus ]
                'increpas@increpas.com' 이라는 문자데이터를
                *n******@********.com 으로 출력되게 문자 처리함수를 사용해서 질의명령을 작성하세요.
                
                *** 반드시 문자 처리함수로만 처리하세요...
*/

SELECT
    'increpas@increpas.com' 이메일,
    SUBSTR('increpas@increpas.com', 2, 1) 꺼낸문자, -- 1 두번째 문자꺼내기
    LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*') 문자두개,     --2 *n
    RPAD(
        LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*'),
        INSTR('increpas@increpas.com', '@') - 1, --아이디 길이 구하기
        '*'
    ) 아이디, --3 아이디
    CONCAT(
        RPAD(
            LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*'),
            INSTR('increpas@increpas.com', '@') - 1, --아이디 길이 구하기
            '*'
        ),
        '@'
    ) 골뱅이까지1,
    RPAD(
        RPAD(
            LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*'),
            INSTR('increpas@increpas.com', '@') - 1, --아이디 길이 구하기
            '*'
        ),
        INSTR('increpas@increpas.com', '@'),
        '@'
    ) 골뱅이까지2, --- 4
    RPAD(
        RPAD(
            RPAD(
                LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*'),
                INSTR('increpas@increpas.com', '@') - 1, --아이디 길이 구하기
                '*'
            ),
            INSTR('increpas@increpas.com', '@'),
            '@'
        ),
        INSTR('increpas@increpas.com', '.') - 1,
        '*'
    ) 확장자전까지, -- 5
    CONCAT(
        RPAD(
            RPAD(
                RPAD(
                    LPAD(SUBSTR('increpas@increpas.com', 2, 1), 2, '*'),
                    INSTR('increpas@increpas.com', '@') - 1, --아이디 길이 구하기
                    '*'
                ),
                INSTR('increpas@increpas.com', '@'),
                '@'
            ),
            INSTR('increpas@increpas.com', '.') - 1,
            '*'
        ),
        SUBSTR('increpas@increpas.com', INSTR('increpas@increpas.com', '.'))
    ) 최종결과 -- 6
FROM
    dual
;

-- 문제 ] 사원의 이름, 직급을 조회하는데
--          이름의 세번째 글자와 마지막 글자는 보여주고 나머지는 * 로 표시해서 조회하세요.
--  SMITH   ==> **I ==> **I*    ==> **I*H
SELECT
    CONCAT(
        RPAD(LPAD(SUBSTR(ename, 3, 1), 3, '*'), LENGTH(ename) - 1, '*'),
        SUBSTR(ename, -1)
    ) 이름
FROM
    emp
;

--  문제 2 ] 사원의 정보를 조회하는데
--          S**** 사원 - CLARK - 급여 : *0*
--          형식으로 출력되게 하세요. 
--          급여의 표현은 두번째 숫자만 표시하고 
--          나머지는 * 로 표시하세요.
SELECT
    RPAD(SUBSTR(ename, 1, 1), LENGTH(ename), '*') ||
    ' 사원 - ' || job || ' - 급여 : ' ||
    RPAD(LPAD(SUBSTR(TO_CHAR(sal), 2, 1), 2, '*'), LENGTH(TO_CHAR(sal)), '*') 사원정보
FROM
    emp
;























