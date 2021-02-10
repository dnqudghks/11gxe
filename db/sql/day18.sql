-- day18
set serveroutput on;


/*
    함수
    ==> 사용자 정의 함수
        기능을 가지고있는 프로그램의 가장 작은 단위
        반환값이 있다.
        
        형식 ]
            
            CREATE OR REPLACE FUNCTION 함수이름(
                파라미터변수1선언,
                파라미터변수2선언,
                ...
            )
            RETURN 테이터타입
            IS( 또는 AS)
                내부변수선언;
            BEGIN
                실행부
                ...
                RETURN 반환값;
                
            [EXCEPTION
                예외처리 ]
            END [함수이름];
            /
*/

/*
    예제 ]
        사원의 급여를 입력하면 10% 인상된 급여를 반환해주는 
        함수(sal_func01)를 만들고 
        이 함수를 이용해서 사원들의
            이름, 직급, 급여, 인상급여
        를 조회하세요.
        
    참고 ]
        파라미터변수(매개변수)가 없는 함수를 사용하는 방법
            함수이름()
        의 형식으로 '()' 를 반드시 붙여주고 실행해야 한다.
*/

-- 급여 10% 인상해서 반환해주는 함수
CREATE OR REPLACE FUNCTION sal_func01(
    isal IN emp.sal%TYPE
)
RETURN NUMBER
IS
    osal emp.sal%TYPE;
BEGIN
    -- 10% 인상된급여를 계산
    osal := isal * 1.1;
    
    -- 인상된 급여를 반환
    RETURN osal;
END;
/

SELECT
    ename 사원이름, job 사원직급, sal 사원급여, sal_func01(sal) 인상급여
FROM
    emp
;

/*
    문제 1 ]
        사원의 급여와 커미션을 입력하면 사원의 연봉을 반환해주는 함수(calc_func01)를 만들고
        사원들의
            사원이름, 사원직급, 사원급여, 커미션, 사원연봉
        을 조회하는 질의명령을 위에서 만든 함수를 사용해서
        작성하고 실행하세요...!
*/

-- 연봉 반환해주는 함수
CREATE OR REPLACE FUNCTION calc_func01(
    isal emp.sal%TYPE,
    icomm emp.comm%TYPE
)
RETURN NUMBER
IS
    -- 연봉 변수 선언
    tsal NUMBER;
    tmp NUMBER;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- 입력된 데이터들로 연봉 계산
    tsal := isal * 12 + NVL(icomm, 0);
    
    tmp := sal_func01(100);
    
--    DBMS_OUTPUT.PUT_LINE('100의 10% 인상된 숫자 : ' || sal_func01(100));
    
    RETURN tsal;
END;
/

SELECT
    ename 사원이름, job 사원직급, 
    sal 사원급여, comm 커미션, calc_func01(sal, comm) 사원연봉
FROM
    emp
;

/*
    문제 2 ]
        사원의 부서번호를 입력하면 
        해당 부서의 평균급여를 반환해주는 함수(dno_avg01)를 제작하고
        이 함수를 사용해서
        부서의 평균급여보다 적게 받는 사원들의
            사원이름, 급여, 부서번호, 부서평균급여
        를 조회하세요.
*/

CREATE OR REPLACE FUNCTION dno_avg01(
    dno emp.deptno%TYPE
)
RETURN NUMBER
IS
    -- 평균급여에 사용할 변수
    d_avg emp.sal%TYPE;
BEGIN
    SELECT
        AVG(sal)
    INTO
        d_avg
    FROM
        emp
    GROUP BY
        deptno
    HAVING
        deptno = dno
    ;
    
    RETURN d_avg;
END;
/


-- 사원이름, 급여, 부서번호, 부서평균급여 조회

SELECT
    ename 사원이름, sal 급여, deptno 부서번호, 
    dno_avg01(deptno) 부서평균급여
FROM
    emp
WHERE
    sal < dno_avg01(deptno)
;

----------------------------------------------------------------------------------
/*
    커서
        ==> 질의 명령을 실행하면 그 실행결과(인라인뷰)가 나오는데
            이 질의의 결과가 커서이다.
*/
----------------------------------------------------------------------------------
/*
    예외처리 ]
    ==> PL/SQL을 실행하는 도중 발생하는 런타임 오류(실행오류)를 예외라고 말하며
        필요하면 예외의 이유를 알아볼 수 있다.
        
        하지만 예외가 발생하면 그 이후의 모든 PL/SQL 명령은 실행되지 않는다.
        오직 예외의 정보를 파악하여 실행이 왜 되지 않았는지 정도만 파악할 수 있다.
--------------------------------------------------------------------------------------------------------------------------
*****        
참고 ]
    예외처리의 목적 ]
        프로그램의 정상적인 종료를 위해서 예외처리를 한다.
        
        예 ]
            
            CREATE OR REPLACE PROCEDURE test01
            IS
            BEGIN
                
                FOR tmp IN (SELECT empno from emp) LOOP
                    -- 반복문 실행도중 오류가 발생하면 COMMIT 명령을 실행하지 않는다.
                    -- 따라서 오류가 발생하더라도 COMMIT 명령이 실행되도록 처리를 해줘야한다.
                    UPDATE
                        tmp1
                    SET
                        ...
                    WHERE
                        EMPNO = TMP.EMPNO
                    ;
                END LOOP;
                
                COMMIT;
            EXCEPTION OTHERS THEN
                COMMIT;
            END;
            /
            
---------------------------------------------------------------------------------------------------------------------------
        
        PL/SQL 에서의 예외의 종류
            
            1. 미리 정의된 예외
                ==> PL/SQL에서 자주발생하는 예외들을
                    예외 코드값과 예외의 이름을 연결해서 만들놓은 예외
                    
                    자동적으로 발생하기 때문에 굳이 특별한 조치를 하지 않아도 예외 처리를 할 수 있다.
                    
            2. 미리 정의 되지 않은 예외
                ==> 자주 발생하지 않기 때문에 이름을 연결시켜 놓지는 않았지만
                    PL/SQL 컴파일러가 알고 있는 예외를 말한다.
                    
                    미리 이름과 코드값을 개발자가 연결한 후(예외를 선언한 후)
                    사용해야 하는 예외
                    
            3. 사용자 예외
                ==> PL/SQL 컴파일러가 알지 못하는 에외를 말한다.
                    강제로 예외로 처리해야 하는 경우
                    <== 데이터나 구문에서는 전혀 이상이 없지만
                        사용자 측면에서 사용할 때 예외로 처리해야 되는 경우
                        
                    미리 이름을 강제로 부여하여 하나의 예외를 만들어 놓은 후
                    필요한 시점에서 강제로 예외라고 인정해줘야 한다.
                    
                    
    예외처리 형식 ]
        
        EXCEPTION   
            WHEN    예외이름1    THEN
                처리내용1;
            WHEN    예외이름2   THEN
                처리내용2;
            ...
            WHEN OTHERS THEN
                처리내용N;
                
    참고 ]
        EXCEPTION 절은 PROCEDURE의 가장 마지막에 와야 한다.
        EXCEPTION 처리 후에는 다른 내용이 오면 안된다.
*/

/*
    부서 번호를 알려주면 해당 부서의 직원정보를 조회해서 출력하는 프로시저를 작성하세요.
    단, 문제가 발생하면 예외처리를 이용해서 문제의 원인이 출력되게 하세요.
*/

CREATE OR REPLACE PROCEDURE testproc01(
    dno IN emp.deptno%TYPE
)
IS
    vemp emp%ROWTYPE;
BEGIN
    -- 부서번호로 조회를 하면 두 행 이상의 결과가 발생한다.
    -- 따라서 커서를 이용해서 처리를 해야 하지만
    -- 여기서는 에러를 발생시키기 위해서 한줄만 나오는 방식으로 처리해보자.
    
    SELECT
        *
    INTO
        vemp
    FROM
        tmp1
    WHERE
        deptno = dno
    ;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || vemp.ename);
    DBMS_OUTPUT.PUT_LINE('사원직급 : ' || vemp.job);
    
EXCEPTION 
    WHEN TOO_MANY_ROWS  THEN
        DBMS_OUTPUT.PUT_LINE('### 한 행 이상의 결과가 조회되었습니다. ###');
    WHEN NO_DATA_FOUND  THEN
        DBMS_OUTPUT.PUT_LINE('*** 해당 부서는 부서원이 없습니다. 빨라 뽑아주세요!!! ***');
        -- 이부분에 필요한 처리를 해줘도 된다.
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('### 알수 없는 오류입니다. ###');
END;
/

exec testproc01(10);
exec testproc01(30);
exec testproc01(40);

-----------------------------------------------------------------------------------------

CREATE TABLE tmp2
AS
    SELECT * FROM emp;


ALTER TABLE tmp2
DROP CONSTRAINT SYS_C0011571;
ALTER TABLE tmp2
DROP CONSTRAINT SYS_C0011572;
ALTER TABLE tmp2
DROP CONSTRAINT SYS_C0011573;
ALTER TABLE tmp2
DROP CONSTRAINT SYS_C0011574;
ALTER TABLE tmp2
DROP CONSTRAINT SYS_C0011575;

-- 기본키 제약조건 추가
ALTER TABLE tmp2
ADD
    CONSTRAINT TMP2_NO_PK PRIMARY KEY(empno);
    
-- 참조키 제약조건 추가
ALTER TABLE tmp2
ADD
    CONSTRAINT TMP2_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno);
    
ALTER TABLE tmp2
MODIFY
    ename CONSTRAINT TMP2_NAME_NN NOT NULL;


/*
    tmp2 테이블을 emp테이블을 복사해서 만들고
    
    새로운 사원을 입력하는 프로시저를 작성하세요.
    단, 사원이름과 부서번호만 입력하세요.
    ==> 사원번호가 입력되지 않아서 에러가 발생
        --> 이 예외는 정의 되지 않은 예외이므로 처리를 해줘야한다.
*/

CREATE OR REPLACE PROCEDURE addemp(
    name IN tmp2.ename%TYPE,
    dno IN tmp2.deptno%TYPE
)
IS
    -- 정의 되지 않은 예외를 사용하기 위해서는
    -- 먼저 정의를 한 후 사용해야 한다.
    
    -- 1. 예외에 사용할 이름정한다.
    --      형식 ]    예외이름    EXCEPTION;
    NONULL_PK  EXCEPTION;
    
    -- 2. 이 예외이름과 실제 발생할 코드값을 연결한다.
    --      형식 ]    PRAGMA EXCEPTION_INIT(예외이름, 예외코드값);

/*
INSERT INTO 
    tmp2(ename, deptno)
VALUES(
    '둘리', 40
);

예외코드
    질의를 실행할 때 표시되는 코드값을 이야기한다.
    
    위질의의 실행결과
    오류 보고 -
    ORA-01400: NULL을 ("HELLO"."TMP2"."EMPNO") 안에 삽입할 수 없습니다
    
    우리가 사용할 코드값은
        ORA-01400 중에서 -01400 을 사용하면되는데
    이때 - 기호 다음의 0은 무효숫자이므로 생략해준다.
    결론적으로 사용할 코드값은 
        -1400
    을 사용하면 된다.
*/
    
    PRAGMA EXCEPTION_INIT(NONULL_PK, -1400);
BEGIN
    INSERT INTO 
        tmp2(ename, deptno)
    VALUES(
        name, dno
    );
    
    commit;
EXCEPTION 
    WHEN NONULL_PK THEN
    DBMS_OUTPUT.PUT_LINE('*** 필수 입력데이터가 입력되지 않았습니다. ***');
END;
/

exec addemp('DOOLY', 40);

-----------------------------------------------------------------------------------------------
/*
    사용자 정의 예외
    
    부서번호를 입력하면 해당 부서의 부서원수를 알려주는 프로시저를 작성하세요.
    단, 사원수가 4명 미만이면 사원수가 부족하다는 메세지를 
    예외처리를 이용해서 보여주세요.
*/

CREATE OR REPLACE PROCEDURE get_dcount(
    dno    tmp2.deptno%TYPE
)
IS
    -- 사용할 예외의 이름을 미리 정한다.
    cnt_err EXCEPTION;
    
    -- 내부변수 
    cnt NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO
        cnt
    FROM
        tmp2
    WHERE
        deptno = dno
    ;
    
    IF cnt = 0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF cnt < 4 THEN
        -- 이 경우는 조회된 사원수가 4명 미만이므로 우리는 이경우 예외로 처리하고 싶다.
        -- 이처럼 강제로 예외를 처리할 경우
        --  이말은 강제로 예외를 발생시킨다는 의미이고
        --      형식 ]    RAISE   예외이름;
        RAISE cnt_err;
    END IF;
    
    -- 위의 IF 명령을 실행안한 경우 읽게되는 부분. IF 명령을 실행하면 이부분은 실행이 안된다.
    DBMS_OUTPUT.PUT_LINE('*** [ ' || dno || ' ] 번 부서의 사원수는 ' || cnt || ' 명 입니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('### 부서원이 존재하지 않습니다. ###');
    WHEN cnt_err    THEN
    DBMS_OUTPUT.PUT_LINE('### 사원수가 기준 인원에서 부족합니다. ###');
END;
/

exec get_dcount(10);
exec get_dcount(40);

------------------------------------------------------------------
/*
    트리거(TRIGGER)
    ==> DML 질의명령을 실행하면
        자동적으로 다른 처리를 하고자 할 경우에 
        사용하는 프로시저의 일종
        
    회원탈퇴를 할 경우
    회원테이블에서 데이터를 바로 삭제하기 전에
    기존데이터를 미리 저장해놓는 작업이 선행이 되어지면
    데이터베이스 사용측면이나 삭제작업에서도
    편해질 것이다.
    
    회원가입을 하게되면 회원의 등급을 주는 경우
    이 회원의 등급을 만들어줘야 한다.
    회원정보를 관리하는 테이블과 등급을 관리하는 테이블이 다르면
    두번 입력작업을 해줘야 한다.
    
    이처럼 작업을 하다보면 관련된(서로 연결된) 작업이
    진행되어야 하는 경우가 빈번히 발생한다.
    이때 한가지 작업만 하면 다른 작업이 자동적으로 처리되도록 하고자 할 경우
    사용하는 프로시저를 트리거라고 한다.
    
    트리거 만드는 형식 ]
        
        CREATE OR REPLACE TRIGGER 트리거이름
            BEFORE 또는 AFTER     DML명령(INSERT, UPDATE, DELETE)이름 
            
            설명 ]
                입력 작업의 경우
                
                    BEFORE  - 입력작업이 일어나기 직전에 실행되는 트리거
                    AFTER   - 입력작업이 완료된 후 실행되는 트리거
            
        ON
            테이블이름 
            
        [FOR EACH ROW]
            ==> 생략하면 작업단위를 하나로 처리한다.
                예를들자면
                    DELETE FROM tmp2 WHERE deptno = 10;
                    명령을 실행하면 3개의 데이터가 삭제되는데
                    이때 3개의 삭제작업을 하나로 처리해서
                    3개의 작업이 완료된후 트리거가 실행되도록 한다.
                    
                생략하지 않으면 위의 질의명령의 경우
                각가의 사원들이 삭제될때마다 트리거가 실행된다.
        [WHEN
            조건식]
            ==> 트리거가 발생해야 하는 조건식을 지정할 수 있다.
                
                예 ]
                    WHEN
                        deptno = 10
                    이라고 하면 부서번호가 10번인 내용이 변경되면
                    그때만 트리거를 실행하라는 의미가 된다.
        BEGIN
            -- 트리거가 실행해야할 질의명령을 기술하는 부분.
        END;
        /
    
참고 ]
    
    트리거가 발생하면 자동적으로 변수가 두개 발생한다.
        
        :OLD    - 이전 데이터를 기억하는 변수
        :NEW    - 이후 데이터를 기억하는 변수
        ==> 이것은 ROWTYPE 변수로 해당 테이블의 필드를 멤버변수로 가지는 변수
        
        예 ]
            :OLD.ename
            ==> 실행할 명령 이전의 ename 데이터를 기억
            
            :NEW.ename
            ==>  실행 명령 이후의 ename 데이터를 기억
            
        주의 ]
            
            DELETE 명령의 경우
            :OLD.ename은 존재하지만 :NEW.ename 은 존재하지 않는다.
            
            INSERT 명령의 경우
            :OLD.ename 은 존재하지 않는다.
            :NEW.ename은 존재한다.
            
            update 명령의 경우는 둘 모두 데이터가 존재한다.
    
        참고 ]
             만약 FOR EACH ROW 를 생략하면
             :NEW, :OLD 변수를 사용할 수 없다.
             이유는
                데이터가 몇개 변경될 수 있는지 알 수 없으므로...
                어떤 데이터를 사용할지 알 수 없기 때문에...
*/

-- 벡업테이블 준비
drop table emp_backup;

CREATE TABLE emp_backup
AS
    SELECT
        t.*, sysdate firedate
    FROM
        tmp2 t
    WHERE
        1 = 2
;

ALTER TABLE emp_backup
RENAME CONSTRAINT SYS_C0011581 TO EBACKUP_NAME_NN;

ALTER TABLE emp_backup
ADD
    CONSTRAINT EBACKUP_NO_PK PRIMARY KEY(empno);
    
ALTER TABLE emp_backup
MODIFY
    firedate DEFAULT sysdate;

/*
    tmp2 테이블에서 작업
    사원이 퇴사를 하면 
    벡업테이블에 데이터를 저장하는 트리거(femp01)를 작성하세요.
    
    그리고 부서번호가 10인 사원들을 모두 퇴사처리하세요.
*/

-- DELETE 명령의 경우는 사원 퇴사처리가 되기전에 데이터를 벡업해둬야한다.
-- 그래야 데이터를 벡업할 수 있으니까...
CREATE OR REPLACE TRIGGER femp01
    BEFORE DELETE
ON
    tmp2
FOR EACH ROW
BEGIN
    INSERT INTO
        emp_backup(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    VALUES(
        :old.empno, :old.ename, :old.job, :old.mgr, 
        :old.hiredate, :old.sal, :old.comm, :old.deptno
    );
    
    DBMS_OUTPUT.PUT_LINE(:OLD.ename || ' ]  사원 퇴사 처리가 완료되었습니다.');
END;
/

SELECT
    *
FROM
    tmp2
WHERE
    deptno = &deptno
;

select 'abcd', &age from dual;

DELETE FROM
    tmp2
WHERE
    deptno = 10
;

commit;

DELETE FROM
    tmp2
WHERE
    deptno = 20
;

ROLLBACK;

/*
    문제 ]
        사원이 입사하면
        해당 사원의 사원번호와 사원이름을 입사 확인 메세지를 출력해주는
        트리거(addemp01)를 작성하고 실행하세요.
        
        출력형식 ]
            
            0000 ] 번 [ XXXXXX ] 사원이 입사했습니다.
*/

CREATE OR REPLACE TRIGGER addemp01
    AFTER INSERT
ON
    tmp2
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(   :NEW.empno ||' ] 번 [ ' || 
                            :NEW.ename || ' ] 사원이 입사했습니다.');
END;
/


INSERT INTO
    tmp2(empno, ename)
VALUES(
    9000, 'DOOLY'
);

--------------------------------------------------------------------------------
/*
    스케줄러
    ==> 특정 시간이 되면 원하는 질의가 자동 실행되도록 하는 기능을 이야기한다.
        즉, 오라클에게 스케줄을 알려주어서 
        그 스케줄대로 작업을 실행하라고 해서
        스케줄러가로 한다.
        
        
    작업 순서 ]
        
        1. 실행할 질의명령을 포함하는 프로시저를 만들어 놓는다.
        2. 프로그램 등록
            ==> 스케줄러가 실행할 프로그램(1번에서 만든 프로시저)를 등록해 줘야 한다.
            
            형식 ]
                BEGIN
                    DBMS_SCHEDULER.CREATE_PROGRAM(
                        program_name => '프로그램이름',
                        program_action => '사용할 프로시저이름',
                        -- 프로시저를 이용하지 않고 
                        -- 직접 질의명령을 만들어서 사용해도 무방하다.
                        program_type    => 'STORED_PROCEDURE',
                        -- STORED_PROCEDURE : 저장프로시저를 사용하는 경우
                        -- EXECUTABLE       : 프로시저를 사용하지 않고 질의며령을 기술하는 경우
                        comments    => '설명',
                        enabled     => 'TRUE'
                        -- TRUE : 만드는 순간 활성화하세요.
                    );
                END;
                /
        
        3. 스케줄을 등록
            ==> 언제 프로시저가 실행될지를 지정하는 내용을 만드는 것
            
            형식 ]
                BEGIN
                    DBMS_SCHEDULER.CREATE_SCHEDULE(
                        schedule_name   => '스케줄이름',
                        start_date  => 시작 날짜,
                        end_date    =>  종료날짜,
                        repeat_interval => 반복주기,
                        comments => '설명'
                    );
                END;
                /
                
            참고 ]
                start_date, end_date는 생략해도 무방하다.
                start_date 를 생략하면 만드는 순간부터 스케줄이 가동하도록한다.
                end_date 를 생략하면 무한정 반복한다.
                
                repeat_interval 은 반복 주기를 지정하는 부분
                
                형식 ]
                    repeat_interval => FREQ=?1?;INVERVAL=?2? 의 형식으로 지정한다.
                    
                    ?1?     간격을 의미한다.
                        예]
                            HOURLY      - 시간간격
                            MINUTELY    - 분 간격
                            DAILY       - 일간격
                            
                    ?2?     간격주기
                    
                    repeat_interval => FREQ=MINUTELY;INTERVAL=1
                    ==> 1분 간격으로 실행하세요...
            
        4. 잡 등록
            ==> 2번의 내용과 3번 내용을 합쳐서 하나의 스케줄 작업을 완성하는 단계
            
            형식 ]
                BEGIN
                    DBMS_SCHEDULER.CREATE_JOB(
                        job_name => '잡이름',
                        program_name => '프로그램이름',
                        schedule_name => '스케줄이름',
                        comments => '설명'
                    );
                END;
                /
                
    삭제하기
        execute DBMS_SCHEDULER.DROP_JOB('잡이름', false);
        execute DBMS_SCHEDULER.DROP_PROGRAM('프로그램이름', false);
        execute DBMS_SCHEDULER.DROP_SCHEDULE('스케줄이름', false);
*/

CREATE TABLE tmp3(
    no NUMBER(4),
    wdate DATE default sysdate
);

/*
    tmp3 테이블에 1분 마다 자동으로 데이터가 채워지도록 
    스케줄러를 작성해서 실행하세요.
*/

-- 1. 프로시저를 만든다.
CREATE OR REPLACE PROCEDURE adddata01
IS
BEGIN
    INSERT INTO
        tmp3(no)
    VALUES(
        (SELECT NVL(MAX(no) + 1, 1) FROM tmp3)
    );
END;
/
-- 2. 프로그램 등록
BEGIN
    DBMS_SCHEDULER.CREATE_PROGRAM(
        program_name => 'addsch00',
        program_action => 'adddata01',
        program_type    => 'STORED_PROCEDURE',
        comments    => 'test 프로그램',
        enabled     => TRUE
    );
END;
/
-- 3. 스케줄 등록
BEGIN
    DBMS_SCHEDULER.CREATE_SCHEDULE(
        schedule_name => 'jom01',
        repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
        comments => 'just one minute'
    );
END;
/
-- 4. 잡 등록
BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name => 'job01',
        program_name => 'addsch00',
        schedule_name => 'jom01',
        comments => '분마다 데이터 입력 스케줄러',
        enabled => TRUE
    );
END;
/