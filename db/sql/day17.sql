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
        을 조회해서 출력해주는 프로시저(ex02_proc01)을 만들고 실행하세요.
*/

--------------------------------------------------------------------------------------------------------------------------
/*
    3. 레코드 타입의 배열
        ==> 위의 두가지 오라클 PL/SQL 타입을 혼용해서 사용한 것.
        
        1. 레코드 타입을 선언(멤버 변수를 가진 변수)
        
        2. 이것을 이용해서 다시 테이블 타입을 만들어서 사용한다.( == > 배열 변수)
*/

/*
    예제 ]
        직급을 입력받아서 재당 직급의 사원들의
            이름, 급여, 입사일 ( ==> EMP 테이블의 필드들... )
        을 조회해서 출력해주는 프로시저를 만들고 실행하세요.
*/

CREATE OR REPLACE PROCEDURE job_info(
    jikgp   emp.job%TYPE
)
IS
    -- 이미 emp 테이블의 묵시적인 레코드 타입 변수가 
    -- ROWTYPE으로 만들어진 상태이므로
    -- 테이블 타입만 선언하자.
    
    TYPE emp_tab IS TABLE OF emp%ROWTYPE
    INDEX BY BINARY_INTEGER; -- 하나의 타입을 만들었다.
    
    jemp    emp_tab;
    
    -- 위치값 변수
    i BINARY_INTEGER  := 0;
BEGIN
    
    -- jemp 데이터 채우기
    DBMS_OUTPUT.PUT_LINE('####### tmp 내용 #######');
    FOR tmp IN (SELECT ename, sal, hiredate FROM emp WHERE job = jikgp) LOOP
        
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || tmp.ename);
        DBMS_OUTPUT.PUT_LINE('사원급여 : ' || tmp.sal);
        DBMS_OUTPUT.PUT_LINE('입 사 일 : ' || tmp.hiredate);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
        
        -- 위치값 변수 셋팅
        i := i + 1;
        
        jemp(i).ename := tmp.ename;
        jemp(i).sal := tmp.sal;
        jemp(i).hiredate := tmp.hiredate;
        
    END LOOP;
    
    -- jemp 내용 출력
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('####### jemp 내용 #######');
    FOR cnt IN 1 .. i LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || jemp(cnt).ename);
        DBMS_OUTPUT.PUT_LINE('사원급여 : ' || jemp(cnt).sal);
        DBMS_OUTPUT.PUT_LINE('입 사 일 : ' || jemp(cnt).hiredate);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    
END;
/

exec job_info('CLERK');

/*
    문제 3 ]
        입사년도를 입력받아
        해당 년도에 입사한 사원들의
            이름, 직책, 부서, 급여, 급여등급
        을 조회해서 출력하는 프로시저(ex03_proc01)을 작성해서
        실행하세요.
*/


CREATE OR REPLACE PROCEDURE ex03_proc01(
    hdate VARCHAR2
)
IS
    TYPE emp_grade IS RECORD( -- row 에 대한 타입 만들고
        name emp.ename%TYPE,
        job emp.job%TYPE,
        dno emp.deptno%TYPE,
        sal emp.sal%TYPE,
        grade salgrade.grade%TYPE
    );
    
    TYPE grade_tab IS TABLE OF emp_grade    -- row를 여러개 기억할 타입
    INDEX BY BINARY_INTEGER;
    
    egrade grade_tab;
    
    i BINARY_INTEGER := 0;
BEGIN
    
    -- 이름, 직책, 부서, 급여, 급여등급
    FOR tmp IN (
                    SELECT 
                        ename, job, deptno, sal, grade 
                    FROM
                        emp, salgrade
                    WHERE
                        sal BETWEEN losal AND hisal
                        AND TO_CHAR(hiredate, 'yy') = hdate
                )
    LOOP
        i := i + 1;
        egrade(i).name := tmp.ename;
        egrade(i).job := tmp.job;
        egrade(i).dno := tmp.deptno;
        egrade(i).sal := tmp.sal;
        egrade(i).grade := tmp.grade;
    END LOOP;
    
    FOR cnt IN 1 .. i LOOP
        DBMS_OUTPUT.PUT_LINE('사원이름 : ' || egrade(cnt).name);
        DBMS_OUTPUT.PUT_LINE('사원직급 : ' || egrade(cnt).job);
        DBMS_OUTPUT.PUT_LINE('부서번호 : ' || egrade(cnt).dno);
        DBMS_OUTPUT.PUT_LINE('사원급여 : ' || egrade(cnt).sal);
        DBMS_OUTPUT.PUT_LINE('급여등급 : ' || egrade(cnt).grade);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    
END;
/

exec ex03_proc01('87');

--------------------------------------------------------------------------------
/*
    반복문
        
        0. LOOP 명령
            
            LOOP
                처리내용;
                ...
                IF 조건식 THEN
                    exit;
                END IF;
            END LOOP;
    
        1. FOR 명령
            형식 1 ]
                
                FOR 변수이름 IN (질의명령) LOOP
                    처리내용;
                    ...
                END LOOP;
                
             형식 2 ]
                
                FOR    변수이름     IN  숫자1 .. 숫자2 LOOP
                    처리내용;
                    ...
                END LOOP;
                
        2.  WHILE 명령
            
            형식 1 ]
                
                WHILE   조건식   LOOP
                     처리내용;
                     ...
                END LOOP;
                
                ==> 조건식이 참이니 경우 반복해서 실행하세요.
            
            형식 2 ]
                
                WHILE   조건식1    LOOP
                    처리내용;
                    
                    EXIT WHEN 조건식2;
                END LOOP;
                
                ==> 조건식1이 참이면 반복하지만
                    조건식2가 참이면 반복을 종료하세요.
                    
                    EXIT WHEN 조건식;  ===> 반복문 종료조건
                    
        3. DO ~ WHILE 명령
            
            형식 ]
                
                LOOP
                    처리내용;
                    ...
                    
                    EXIT WHEN 조건식;
                END LOOP;
                
------------------------------------------------------------------------
    
    조건문
        
        IF 명령
            
            형식 1 ] -- 조건이 참인 경우만 처리한다. 거짓인 경우의 처리내용은 없다.
                
                IF 조건식 THEN
                    처리내용;
                    ...
                END IF;
                
            형식 2 ]  -- 조건이 참, 거짓인 경우 두가지 모두 처리한다.
                
                IF 조건식 THEN
                    참인경우 실행내용;
                ELSE
                    거짓인 경우 실행내용;
                END IF;
                
            형식 3 ]
                
                IF 조건식1 THEN
                    처리내용1
                ELSIF   조건식2    THEN
                    처리내용2
                ELSIF   조건식3    THEN
                    처리내용3
                ...
                ELSE
                    처리내용N
                END IF;
*/


-- FOR 명령을 사용해서 구구당 5단을 출력하세요.

DECLARE
    dan NUMBER;
BEGIN
    dan := 5;
    
    FOR gop IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(dan || ' x ' || gop || ' = ' || (dan * gop));
    END LOOP;
    
END;
/

DECLARE
    i NUMBER := 0;
    dan number := 5;
BEGIN
    LOOP
        i := i + 1;
        EXIT WHEN i > 9 ;   -- ==> 종료조건식...
        
        DBMS_OUTPUT.PUT_LINE(dan || ' x ' || i || ' = ' || (dan * i));
    END LOOP;
END;
/

/*
    FOR 반복문을 이용해서 
    구구단 2 ~ 9 단까지 출력하세요.
    무명 프로시저로 작성하세요.
*/


/*
    사원들의
        이름, 급여, 급여등급
    을 조회해서 출력해주는 프로시저를 작성해서 실행하세요.
    
    단, 급여등급은 조인을 사용하지 않고
    조건문을 사용해서 처리하세요.
*/

CREATE OR REPLACE PROCEDURE salgrade_proc02
IS
    -- 한줄 레코드 타입을 만든다.
    TYPE esal IS RECORD(
        name emp.ename%TYPE,
        sal emp.sal%TYPE,
        grade NUMBER(2)
    );
    -- 레코드타입을 기억할 배열 타입(테이블타입)을 만든다.
    TYPE esal_tab IS TABLE OF esal
    INDEX BY BINARY_INTEGER;
    -- 배열타입의 변수를 만든다.
    egrade esal_tab;
    -- 위치값 기억할 변수 만든다.
    i BINARY_INTEGER := 0;
    
    -- 등급 내부 변수
    tgrade NUMBER(2);
BEGIN
    FOR tmp IN (
                    SELECT
                        ename, sal
                    FROM
                        emp
                )
    LOOP
        i := i + 1;
        
        egrade(i).name := tmp.ename;
        egrade(i).sal := tmp.sal;
        
        IF tmp.sal < 700 THEN
            tgrade := 0;
        ELSIF tmp.sal <= 1200 THEN
            tgrade := 1;
        ELSIF tmp.sal <= 1400 THEN
            tgrade := 2;
        ELSIF tmp.sal <= 2000 THEN
            tmp.sal := 3;
        ELSIF tmp.sal <= 3000 THEN
            tgrade := 4;
        ELSIF tmp.sal <= 9999 THEN
            tgrade := 5;
        END IF;
        
        egrade(i).grade := tgrade;
    END LOOP;
    
    
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 34, '='));
    DBMS_OUTPUT.PUT_LINE('| 사원이름 | 사원급여 | 급여등급 |');
    DBMS_OUTPUT.PUT_LINE(RPAD('*', 34, '*'));
    
    FOR cnt IN 1 .. i LOOP
        
        DBMS_OUTPUT.PUT_LINE('| ' || RPAD(egrade(cnt).name, 8, ' ') || ' | ' || 
                            LPAD(egrade(cnt).sal, 8, ' ') || ' | ' || 
                            RPAD(egrade(cnt).grade, 8, ' ') || ' |');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 34, '-'));
    END LOOP;
END;
/

exec salgrade_proc02;

-------------------------------------------------------------------------
/*
    커서(Cursor)
    ==> 실제로 실행되는 질의명령을 기억하는 변수
    
        자주 사용하는 질의명령을 한번만 만든 후
        이것(질의명령 자체)를 변수에 기억해서 마치 
        변수를 사용하듯이 질의를 실행하는 것.
        
        암시적 커서
        ==> 이미 오라클에서 제공하는 커서를 말하며
            우리가 지금까지 사용했듯이 직접 만들어서
            실행된 질의 명령 자체를 의미한다.
            
참고 ]
    커서에는 내부 변수(멤버 변수)가 존재한다.
    
    SQL%ROWCOUNT
    ==> 실행결과 나타난 레코드의 갯수를 기억한 멤버 변수
    
    SQL%FOUND
    ==> 실행결과가 존재함을 나타내는 멤버 변수
    
    SQL%NOTFOUND
    ==> 실행결과가 존재하지 않음을 나타내는 멤버변수
    
    SQL%ISOPEN
    ==> 커서가 만들어졌는지를 알아내는 멤버변수

*/

/*
    예제 ]
        사원번호를 입력하면
        그 사원의 이름을 알려주는 프로시저를 만드세요.
        단, 사원번호가 잘못 되면 사원이 없음을 알리는 메세지를 출력하세요.
*/

CREATE OR REPLACE PROCEDURE getname01(
    eno emp.empno%TYPE
)
IS
    name emp.ename%TYPE;
BEGIN

    SELECT
        ename
    INTO
        name
    FROM
        emp
    WHERE
        empno = eno
    ;
    
    -- 위 질의 명령이 실행되는 순간 암시적 커서가 만들어진다.
/*
    질의명령 실행단계에서 오류가 발생한 경우이므로 
    이 행을 실행 하지 않는다.
    
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('##### 사원이 존재하지 않습니다. #####');
    END IF;
*/    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 23, '-'));
        DBMS_OUTPUT.PUT_LINE('| 사원번호 | 사원이름 |');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 23, '-'));
        DBMS_OUTPUT.PUT_LINE('| ' || LPAD(TO_CHAR(eno), 8, ' ') || ' | ' 
                                    || RPAD(name, 8, ' ') || ' |');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 23, '-'));
    END IF;
    
EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('##### 사원이 존재하지 않습니다. #####');
END;
/

-- 사원이 존재하는 경우
EXEC getname01(7902);

-- 사원번호가 존재하지 않는 경우
exec getname01(7500);


/*
    명시적 커서
    ==> 자주사용하는 질의명령을 미리 만든 후
        필요하면 질의 명령을 변수를 이용해서 실행하도록 하는 것.
    
        명시적 커서의 처리 순서
            
            1. 명시적 커서를 만든다.
                (명시적 커서를 정의)
                
                형식 ]
                    CURSOR 커서이름 IS
                        필요한 질의 명령
                    ;
                
            2. 반드시 커서를 프로시저에서 실행 가능하도록 조치한다.
                (커서를 오픈시킨다.)
                
                형식 ]
                    OPEN    커서이름;
            
            3. 질의 명령을 실행한다.
                (커서를 Fetch 시킨다.)
                
                형식 ]
                    FETCH      커서이름;
            
            4. 사용이 끝난 커서는 회수한다.
                (커서를 CLOSE 시킨다.)
                
                형식 ]
                    CLOSE   커서이름;
*/

/*
    예제 ]
        부서번호를 입력하면 해당 부서의
            부서이름, 평균급여, 부서원수
        를 조회해서 출력해주는 프로시저(dinfo01)를 만들어서 실행하세요.
        단, 질의 명령은 커서를 이용해서 처리하세요.
        
*/
CREATE OR REPLACE PROCEDURE dinfo01(
    dno dept.deptno%TYPE
)
IS
    -- 1. 커서를 정의한다.
    CURSOR  d_info IS
        SELECT
            dname, AVG(sal), COUNT(*)
        FROM
            emp e, dept d
        WHERE
            e.deptno = d.deptno
            AND e.deptno = dno
        GROUP BY 
            dname
    ;
    
    -- 내부 변수를 만든다.
    d_name dept.dname%TYPE;
    avg1 NUMBER;
    cnt NUMBER;
BEGIN
    -- 2. 커서를 오픈한다.
    OPEN d_info;
    
    -- 필요한 시점이 되면 커서를 실행한다.
    FETCH   d_info    INTO    d_name, avg1, cnt;
    
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || dno);
    DBMS_OUTPUT.PUT_LINE('부서이름 : ' || d_name);
    DBMS_OUTPUT.PUT_LINE('부서평균 : ' || ROUND(avg1, 2));
    DBMS_OUTPUT.PUT_LINE('부서원수 : ' || cnt);
    
    -- 사용이 종료된 커서는 닫아준다.
    CLOSE d_info;
END;
/


exec dinfo01(10);