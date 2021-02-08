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
        
*/



DBMS_OUTPUT.PUT_LINE('부서번호 : ' || 00 || ' 번');
DBMS_OUTPUT.PUT_LINE('사원이름 : ' || xxxx);
DBMS_OUTPUT.PUT_LINE('사원직급 : ' || xxxxxxxxxx);
DBMS_OUTPUT.PUT_LINE('사원급여 : ' || 0000000);
DBMS_OUTPUT.PUT_LINE('부서최저급여 : ' || 0000000);




