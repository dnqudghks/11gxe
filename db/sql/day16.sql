-- day16

set serveroutput on -- sqlplus 명령, 따라서 세션이 종료되면 다시 실행해줘야 한다.

/*
    무명 프로시저 만드는 방법
        
        형식 ]
            DECLARE
                선언부 - 변수 선언
            BEGIN
                실행부 - 실제 프로그램의 내용이 실행되는 부분
                
            [EXCEPTION
                예외처리 ]
            END;
            /
*/

/*
    문제 1 ]
        사원들의 이름, 연봉을 출력해주는 
        무명 프로시저를 작성해서 실행하세요.
        
        연봉은 급여 * 12 + 커미션
        커미션이 없는 사원은 0으로 계산하세요.
        
        출력형식 ]
            
            SMITH : $9600
*/

SELECT
    12 * SAL + 0
FROM
    EMP
WHERE
    ename = 'SMITH'
;

SELECT
    MAX(LENGTH(ename)) 이름최대길이
FROM
    emp
;

SELECT
    CONCAT(CONCAT(LPAD(ename, 7, ' '), ' : '), NVL(SAL * 12 + comm, SAL * 12))
FROM
    emp
WHERE
    ENAME = 'SMITH'
;


DECLARE
    str VARCHAR2(50);
BEGIN
    SELECT
        CONCAT(CONCAT(LPAD(ename, 7, ' '), ' : '), NVL(SAL * 12 + comm, SAL * 12))
    INTO
        str
    FROM
        emp
    WHERE
        ENAME = 'SMITH'
    ;
    
    DBMS_OUTPUT.PUT_LINE('------------------------');
    DBMS_OUTPUT.PUT_LINE(str);
END;
/

-- 위 문제를 모든 회원들이 출력되도록 하세요.

/*
    일반 프로시저(이름이 있는) 만드는 방법
    ==> 
        장점 ]
            이름을 가진다는 것은 오라클이 인식할 수 있다는 것이고,
            한번만 만들면 필요할 때 언제든지 그 이름을 이용해서 
            사용할 수 있다.
            
        형식 ]
            CREATE OR REPLACE PROCEDURE 프로시저이름(
                파라미터 변수 선언
            )
            IS
                내부에서 사용할 변수를 만드는 부분 - 내부변수 선언부
            BEGIN
                실행부 - 처리 내용 실행
            [ EXCEPTION
                예외처리부 ]
            END;
            /
            
        참고 ]
            파라미터 변수 선언
            
            형식 ]
                변수이름    IN [ 또는 IN OUT ] 변수 형태;
                
                의미 ]
                    이 프로시저를 실행할 때 전달되는 값이나(IN)
                    이 프로시저의 결과를 알려줄 때 사용할 변수 (OUT) 선언한다.
                    
                예 ]
                    EXEC PROC01(100);
                    ==> 
                        프로시저를 실행 시키는 순간
                        데이터를 전달 할 수 있으며
                        이 데이터를 기억할 변수를 파라미터 변수라고 한다.
                        
        참고 ]
            내부 변수 선언
            ==>
                프로시저를 실행할 때 필요한 변수를 선언하는 부분
                
            형식 ]
                변수이름    변수타입;
                예 ] 
                    age     NUMBER; -- 변수 선언
                    
                변수이름    변수타입 := 값;
                예 ]
                    age     NUMBER := 20 ;  -- 변수 선언과 초기화
                    
                변수이름   CONSTNT  변수타입 := 값 ;
                ==> 상수를 만드는 것으로
                    데이터를 바꿀 수 없는 변수
                    값을 변경할 수 없기 때문에 선언과 동시에 초기화가 이루어져야 한다.
                    ( 변수 만들면서 값을 입력해줘야 한다.)
                    
                변수이름    변수타입    NOT NULL := 값 ;
                ==> 일반 변수는 값을 기억하지 않으면 NULL 값을 가지게 된다.
                    하지만 이 변수는 NULL 을 허용하지 않는 변수로
                    반드시 초기화(만듦과 동시에 값을 입력해주는 작업)를 해야하는 변수임을
                    밝히는 것이다.
                    (
                        초기화를 강제로하면 NOT NULL을 쓰지 않아도 되지만
                        가독성을 위한 것이다.
                    )
                    
        참고 ]
            변수 타입은
            오라클의 변수 타입도 사용할 수 있고
            ANSI 타입도 사용할 수 있다.
            
            예 ]
                BOOLEAN, INTEGER, ....
*/

/*
    예제 1 ]
         사원들의 데이터(tmp1)중에서 급여가 원하는 급여 미만인
         사원들의 급여를 10% 인상 처리하는 프로시저(salup_proc01)를 만들고
         1300 미만인 사원들의 급여를 이 프로시저를 실행해서 
         인상처리하세요.
*/


-- 질의명령
UPDATE
    tmp1
SET
    sal = sal * 1.1
WHERE
    sal < 입력급여  -- 입력급여는 실행될 때 결정이 되어진다. exec salup_proc01(1300);
;

CREATE OR REPLACE PROCEDURE salup_proc01(
    insal IN NUMBER
)
IS
    tmp NUMBER := insal ;
BEGIN
    UPDATE
        tmp1
    SET
        sal = sal * 1.1
    WHERE
        sal < tmp
    ;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('*** [ ', tmp) || ' ] 보다 급여가 적은 사원 10% 급여인상 완료 ***');
END;
/

-- 1300 미만인 사원급여 인상
execute salup_proc01(1300);

/*
    hello 계정에
        SCOTT 계정이 가지고 있는 emp, detp, salgrade, bonus 테이블을 복사해두세요.
*/

/*
    문제 1 ]
    부서번호를 입력하면 
    해당 부서원들의 급여를 5% 인상해주는 프로시저(salup_proc02)를 만들고
    10 부서원들의 급여인상을 처리하세요.
*/


CREATE OR REPLACE PROCEDURE salup_proc02(
    dno IN NUMBER
)
IS
BEGIN
    UPDATE
        tmp1
    SET
        sal = sal * 1.05
    WHERE
        deptno = dno
    ;
    
    commit;
    DBMS_OUTPUT.PUT_LINE('*** ' || dno || ' 번 부서 급여 5% 인상완료 ***');
END;
/
rollback;

exec salup_proc02(10);


update
    tmp1 t
set
    (empno, ename, job, mgr, hiredate, sal, comm, deptno ) =
    (
        SELECT
            *
        FROM
            emp
        WHERE
            empno = t.empno
    )
;

commit;


/*
    문제 2 ]
        사원정보테이블을 이용해서 이름 글자수를 입력하면
        해당 글자수의 이름을 가진 사원들의 급여를 40% 인상하는 
        프로시저(salup_porc03)를 만들고
        실행하세요.
*/

UPDATE
    tmp1
SET
    sal = sal * 1.4
WHERE
    LENGTH(ename) = xx
;

CREATE OR REPLACE PROCEDURE salup_proc03(
    nlen IN NUMBER
)
IS
BEGIN
    UPDATE
        tmp1
    SET
        sal = sal * 1.4
    WHERE
        LENGTH(ename) = nlen
    ;
    
    commit;
    
    DBMS_OUTPUT.PUT_LINE('*** 이름이 ' || nlen || 
                            ' 글자인 사원들의 급여를 40% 인상했습니다.');
END;
/

execute salup_proc03(5);

/*
    문제 3 ]
        
        3-1
        사원들의 사원번호를 모두 출력해주는 프로시저(low_proc01)를 작성하고 
        실행서 번호를 확인 후
        
        3-2
        사원번호를 알려주면
        그 사원의 이름과 직급, 급여를 출력하는 프로시저(get_info01)를 작성하고
        실행하세요.
*/
SELECT
    rno, empno
FROM
    (
        SELECT
            ROWNUM rno, empno
        FROM
            tmp1
    )
WHERE
    rno = 4
;

CREATE OR REPLACE PROCEDURE low_proc01
IS
    trno NUMBER := 1;
    tmax NUMBER ;
    eno NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO 
        tmax
    FROM
        tmp1
    ;
    
    LOOP
        SELECT
            empno
        INTO
            eno
        FROM
            (
                SELECT
                    ROWNUM rno, empno
                FROM
                    tmp1
            )
        WHERE
            rno = trno
        ;
        
        DBMS_OUTPUT.PUT_LINE(eno);
        
        trno := trno + 1;
        
        IF trno > tmax THEN -- trno(회차)가  tmax(전체사원수)  보다 커지면 즉시 종료하세요.. 
            exit;
        END IF;
        
    END LOOP;
    
END;
/

-- get_info01 프로시저
CREATE OR REPLACE PROCEDURE get_info01(
    eno IN NUMBER
)
IS
    name VARCHAR2(50);
    vjob VARCHAR2(50);
    vsal NUMBER;
BEGIN
    SELECT
        ename, job, sal
    INTO 
        name, vjob, vsal
    FROM
        tmp1
    WHERE
        empno = eno
    ;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || name);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vjob);
    DBMS_OUTPUT.PUT_LINE('사원급여 : ' || vsal);
END;
/

exec low_proc01;

exec get_info01(7902);

/*
    문제 4 ]
        부서 번호를 입력하면
        해당 부서의 최저급여자의
            
            부서번호 : 00 번
            사원이름 : xxxx
            사원직급 : xxxxxxxxxx
            사원급여 : 0000000
            부서최저급여 : 0000000
            
        의 형태로 조회해서 보여주는 프로시저를 작성하고
        실행하세요.
        
        ==> 해당 부서번호의 최저급여를 조회.
            ==> 부서번화와 최저급여가 같은 사원을 조회하세요.
        
*/
select
    MIN(sal)
from    
    tmp1
where
    deptno = 10
;

-- 1300 이 조회되는데 급여가 이 금액과 같은 사원을 10부서에서 조회한다.
SELECT
    ename, job, sal, deptno
FROM
    tmp1
WHERE
    deptno = 10
    AND sal = 1300
;
---------------------------------------------------------------------------
SELECT
    deptno, ename, job, sal, min
FROM
    tmp1,
    (
        SELECT
            deptno dno, MIN(sal) min 
        FROM
            tmp1
        GROUP BY
            deptno
    )
WHERE
    deptno = dno -- 조인조건
    AND sal = min
    AND deptno = 30
;

CREATE OR REPLACE PROCEDURE lowsal01(
    dno IN NUMBER
)
IS
    rname VARCHAR2(50);
    rjob VARCHAR2(50);
    rsal NUMBER;
    rmin NUMBER;
BEGIN
    SELECT
        MIN(sal)
    INTO
        rmin
    FROM
        tmp1
    GROUP BY
        deptno
    HAVING
        deptno = dno
    ;
    
    SELECT
        ename, job, sal
    INTO
        rname, rjob, rsal
    FROM
        tmp1
    WHERE
        deptno = dno
        and sal = rmin
    ;
    
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || dno || ' 번');
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || rname);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || rjob);
    DBMS_OUTPUT.PUT_LINE('사원급여 : ' || rsal);
    DBMS_OUTPUT.PUT_LINE('부서최저급여 : ' || rmin);
    
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('### 최저 급여자가 한명이 아닙니다.');
END;
/

exec lowsal01(10);
exec lowsal01(20);
exec lowsal01(30);

DBMS_OUTPUT.PUT_LINE('부서번호 : ' || 00 || ' 번');
DBMS_OUTPUT.PUT_LINE('사원이름 : ' || xxxx);
DBMS_OUTPUT.PUT_LINE('사원직급 : ' || xxxxxxxxxx);
DBMS_OUTPUT.PUT_LINE('사원급여 : ' || 0000000);
DBMS_OUTPUT.PUT_LINE('부서최저급여 : ' || 0000000);

--------------------------------------------------------------------------------
/*
    문제 5 ]
        사원번호를 입력하면
        해당 사원의 이름, 직책, 부서이름, 부서위치가 출력되는 
        프로시저(emp_info02)를 만들어서 실행하세요. 
        
        --> 조인을 사용해서 처래해보세요....(emp_info0201)
*/
-- 사원번호를 입력하면 사원의 정보를 조회하는 질의명령
SELECT
    ename, job, deptno
FROM
    tmp1
WHERE
    empno = 7782
;

-- 사원의 부서번호로 부서정보 조회하는 질의명령
SELECT
    dname, loc
FROM
    dept
WHERE
    deptno = 10
;

-- emp_info02 프로시저 작성
CREATE OR REPLACE PROCEDURE emp_info02(
    eno NUMBER
)
IS
    name VARCHAR2(50);
    vjob VARCHAR2(50);
    bsname VARCHAR2(50);
    bsloc VARCHAR2(50);
    dno NUMBER;
BEGIN
    SELECT
        ename, job, deptno
    INTO
        name, vjob, dno
    FROM
        tmp1
    WHERE
        empno = eno
    ;
    
    SELECT
        dname, loc
    INTO    -- 조회결과를 내부에서 사용할 때 사용하는 절, 
            -- 반드시 위에서 만든 변수이름이 일치해야하고
            -- 조회절의 필드의 데이터를 담을 순서대로 나열해야 한다.
        bsname, bsloc
    FROM
        dept
    WHERE
        deptno = dno
    ;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || name);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vjob);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || bsname);
    DBMS_OUTPUT.PUT_LINE('부서위치 : ' || bsloc);
END;
/

exec emp_info02(7839);

/*

*****
중요 ]

    1. TYPE 변수 선언
    변수를 만들 때 변수의 형태를 지정해줘야 한다.
    문제는 이 변수 중에는 질의의 결과와 연관된 변수가 존재한다.
    이때 크기가 다르면 문제가 발생할 수 있다.
    예를 들면
        사원번호를 기억할 변수를 number(2)으로 두자리로 만들게 되면
        이 변수에 사원번호를 기억시킬 수 없게된다.
    또는 데이터베이스가 변경되어도 문제가 발생할 수 있다.
    이렇게 되면 프로시저를 수정해야 하는 불편함이 생긴다.
    
    이런 경우를 대비해서 만드는 것이 %TYPE에 의한 변수 선언이다.
    이것은 이미 만들어진 타입을 그대로 복사해서 
    같은 타입, 크기의 변수로 만들어 준다.
    
    1. 이미 만들어진 변수와 동일한 타입으로 만드는 방법
        
        예 ]
            d_name VARCHAR2(20);
            d_job d_name%TYPE;
            --> d_name의 변수 형태와 동일한 형태의 변수가 만들어진다.
            
    2. 데이터베이스의 타입과 동일한 타입으로 만드는 방법
        형식 ]
            
            변수이름    테이블이름.필드이름%TYPE;
            
        예]
            d_name dept.dname%TYPE;
            --> dept 테이블의 dname 필드와 동일한 형태, 크기를 가지는
                d_name 변수를 만드세요.
                
    2. ROWTYPE 에 의한 변수 선언
        --> TYPE에 의한 변수 선언의 경우 필드 한개의 데이터 형태, 크기를
            복사해서 사용하는 방법이다.
            
            %ROWTYPE은 테이블 전체(한 행의 전체 타입)의 데이터형태, 크기를
            복사해서 사용하는 방법이다.
            
            형식 ]
                
                변수이름    테이블이름%ROWTYPE;
                
                ==> 이 변수는 마치 내부에 변수를 가지는 것 처럼 사용된다.
                
                사용 ]
                    
                    변수이름.필드이름
                    
                    으로 사용한다.
                
                예 ]
                    
                    vdept dept%ROWTYPE;
                    
                    ==> 이경우 부서이름의 변수를 사용할 경우
                        
                        vdept.dname
        
    
    
*/
CREATE OR REPLACE PROCEDURE emp_info0201(
    eno IN emp.empno%TYPE -- emp 테이블의 empno와 크기와 형태가 같은 변수
)
IS
    name emp.ename%TYPE;
    vjob emp.job%TYPE;
    bsname dept.dname%TYPE;
    bsloc dept.loc%TYPE;
BEGIN
    SELECT
        ename, job, dname, loc
    INTO
        name, vjob, bsname, bsloc
    FROM
        emp e, dept d
    WHERE
        e.deptno = d.deptno
        AND empno = eno
    ;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || name);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vjob);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || bsname);
    DBMS_OUTPUT.PUT_LINE('부서위치 : ' || bsloc);
END;
/

exec emp_info0201(7902);


/*
    문제 6 ]
        사원번호를 알려주면 그 사원의 이름, 직책, 상사이름을 
        출력해주는 프로시저(emp_info03)를 만들고 실행하세요.
        -- 조인 명령을 사용해서 처리하세요.
        -- TYPE 변수를 만들어서 처리하세요.
*/

/*
    문제 7 ]
        사원의 이름을 입력하면
        해당 사원의 
            이름, 직급, 급여, 급여등급
        을 출력하는 프로시저(emp_info04)를 만들어서 실행하세요.
        
        1. TYPE 변수로 처리하세요.(emp_info0401)
        
        2. ROWTYPE 변수를 사용해서 처리하세요.(emp_info0402)
        
*/

/*
    문제 8 ]
        사원의 이름을 입력하면
            이름, 직급, 급여, 입사일
        을 출력해주는 프로시저(emp_info05)를 작성해서 실행하세요.
        
        ROWTYPE 변수로 처리하세요.
*/











