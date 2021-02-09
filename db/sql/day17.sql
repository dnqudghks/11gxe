-- day17

set serveroutput on;

/*
    1. 테이블 타입의 변수
    ==> PL/SQL에서 배열을 표현하는 방법
    
    1. 형식 ]
        테이블 타입을 정의하는 방법
        
        TYPE    테이블이름   IS TABLE OF 데이터타입1
        INDEX BY    데이터타입2;
        
        참고 ]
            데이터타입1
            ==> 변수에 기억될 데이터의 형태
            
            데이터타입2
            ==> 배열의 위치값을 사용할 데이터의 형태
                ( 99.9% BYNARY_INTEGER  : 0, 1, 2, 3, ...)
                
    2. 형식 ]
        변수이름    테이블이름;
        ==> 정의된 테이블이름의 형태로 변수를 만드세요.
            
        참고 ]
            테이블 타입이란 변수는 존재하지 않는다.
            따라서 먼저 테이블 타입을 정의하고
            정의된 테이블 타입을 이용해서 변수를 선언해야 한다.
            
    참고 ]
        for 명령
            
            형식 1 ]
                
                for 변수이름    IN  (질의명령)  LOOP
                    처리내용;
                    ....
                END LOOP;
                
                의미 ]
                    질의명령의 결과를 변수에 한줄씩 기억한 후
                    원하는 내용을 처리하도록 한다.
            
            형식 2 ]
                
                for 변수이름    IN  시작값 .. 종료값  LOOP
                        처리내용;
                        ...
                END LOOP;
                
                의미 ]
                    시작값에서 종료값까지 1씩 증가시키면서
                    처리내용을 반복시킨다.
            
*/

SELECT
    empno
FROM
    tmp1
;

/*
    예제 ]
        부서번호를 알려주면
        해당 부서의 소속 사원들의
            이름, 직급, 급여
        를 조회해서 출력하도록 프로시저(p2_emp_info01)를 만들어서 실행하세요.
*/

CREATE OR REPLACE PROCEDURE p2_emp_info01(
    dno emp.deptno%TYPE
)
IS
    /*
        결과가 여러줄 조회될 예정이므로 
        이 결과를 한꺼번에 기억하기 위해서는
        배열로 선언해야 한다.
        배열은 3개가 있어야 하고
        따라서 테이블도 3개가 존재해야 한다.
        
        테이블 3개를 정의한다.
    */
    
    TYPE name_table IS TABLE OF emp.ename%TYPE
    INDEX BY BINARY_INTEGER;
    
    TYPE job_table IS TABLE OF emp.job%TYPE
    INDEX BY BINARY_INTEGER;
    
    TYPE sal_table IS TABLE OF emp.sal%TYPE
    INDEX BY BINARY_INTEGER;
    -- 여기까지는 배열 타입만 만든것이고
    /*
        아직 변수가 만들어진것은 아니고
        필요한 배열을 사용할 예정임을 정의한 것 뿐이다.
        
        이 정의된 테이블을 이용해서 실제 변수를 만들어야 한다.
    */
    name name_table;    -- 자동 배열이 된다.
    vjob job_table;
    vsal sal_table;
    
    -- 배열에서 사용할 위치값 변수를 하나 만든다.
    i BINARY_INTEGER    := 0;
    
BEGIN
    DBMS_OUTPUT.ENABLE;
    
    FOR tmp IN (
                    SELECT
                        ename, job, sal
                    FROM
                        tmp1
                    WHERE
                        deptno = dno
                )
    LOOP
    /*
        FOR 명령에서 사용할 변수는 미리 만들지 않아도 된다.
        이 변수는 자동 %ROWTYPE 변수가 된다.
            
            ROWTYPE 변수는 암묵적으로 멤버를 가지는 변수이다.
                
                tmp.ename, tmp.job, tmp.sal
            를 가지는데
            이때 멤버는 IN의 질의 결과에 따라 나온 결과가 멤버로 결정이된다.
            
                tmp.ename = 'WARD'	
                tmp.job = 'SALESMAN'
                tmp.sal = 1250
             의 형태로 기억되어서 처리된다.
    */
        i := i + 1; -- 데이터베이스에서는 배역의 시작이 1부터 시작한다.
        
        -- 이제 결과를 준비된 배열에 기억해 보자.
        name(i) := tmp.ename;
        vjob(i) := tmp.job;
        vsal(i) := tmp.sal;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('i : ' || i);
    
    
    DBMS_OUTPUT.PUT_LINE('===========================');
    -- 이제 배열 변수에 저장된 데이터를 출력해보자.
    FOR cnt IN 1 .. i LOOP -- 30번 부서의 경우 i에는 6이 기억되어있다.
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || name(cnt));
        DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vjob(cnt));
        DBMS_OUTPUT.PUT_LINE('사원급여 : ' || vsal(cnt));
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    END LOOP;
END;
/


execute p2_emp_info01(30);


---------------------------------------------------------------------------------------------------------
/*
    2. 레코드 타입
    ==> 강제로 멤버를 가지는 변수를 만드는 방법
    
        %ROWTYPE은 하나의 테이블을 이용해서 멤버 변수를 자동으로 만드는 방법이다.
        레코드 타입은 사용자가 지정한 멤버 변수를 만들 수 있다는 차이점이 있다.
        
    만드는 방법
        
        1. 레코드 타입을 정의한다.
            
            형식 ]
                TYPE    레코드이름   IS RECORD(
                    멤버변수이름1     데이터타입,
                    멤버변수이름2     데이터타입,
                    ...
                );
                
        2. 정의된 레코드 타입을 이용해서 변수를 선언한다.
            
            형식 ]
                변수이름       레코드이름;
*/

/*
    예제 ]
         이름을 입력하면 해당 사원의
            이름, 직급, 급여, 급여등급
        을 조회해서 출력해주는 프로시저(nameinfo_proc01)를 
        만들어서 실행하세요.
*/
CREATE OR REPLACE PROCEDURE nameinfo_proc01(
    irum    emp.ename%TYPE
)
IS
    -- 1. 레코드타입을 정의한다.
    -- 이 안에는 4가지 정보를 기억할 수 있는 변수를 멤버로 준비한다.
    TYPE emp_record01 IS RECORD(
        name    emp.ename%TYPE,
        ijob    emp.job%TYPE,
        isal    emp.sal%TYPE,
        igrade  salgrade.grade%TYPE
    );
    
    -- 2. 변수를 선언한다.
    vemp    emp_record01;
    /*
        vemp 는 
            vemp.name
            vemp.ijob
            vemp.isal
            vemp.igrade
        를 멤버로 가진다.
    */
BEGIN
    SELECT
        ename, job, sal, grade
    INTO
        vemp.name, vemp.ijob, vemp.isal, vemp.igrade
    FROM
        emp, salgrade
    WHERE
        sal BETWEEN losal AND hisal -- 조인조건
        AND ename = irum            -- 일반조건
    ;
    
    -- 변수에 담긴 내용을 출력
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || vemp.name);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vemp.ijob);
    DBMS_OUTPUT.PUT_LINE('사원급여 : ' || vemp.isal);
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || vemp.igrade);

END;
/

exec nameinfo_proc01('KING');

------------------------------------------------------------------------------------------------------------
/*
    문제 1 ] 테이블 타입 변수
        직급을 입력받아서 해당 직급에 해당하는 사원들의
            이름, 급여, 부서이름
        을 조회해서 출력해주는 프로시저(ex01_proc01)을 만들고 실행하세요.
*/

/*
    문제 2 ] 레코드 타입
        사원번호를 입력받아서 해당 사원의
            이름, 직급, 상사이름
        을 조회해서 출력해주는 프록시저(ex02_proc01)을 만들고 실행하세요.
*/









