DECLARE
    -- 선언부 시작
    tmp NUMBER;
    FUNCTION test(
        b_ex IN boolean,
        t_num IN NUMBER,
        f_num IN NUMBER
    )
    RETURN NUMBER IS
    BEGIN
        IF b_ex THEN
            RETURN t_num;
        ELSIF NOT b_ex THEN
            RETURN f_num;
        ELSE
            RETURN NULL;
        END IF; -- IF 명령 종료
    END;    -- 함수 프로시저 종료
BEGIN
    DBMS_OUTPUT.PUT_LINE('2 > 1 : ' || test(2 > 1, 1, 0));
    DBMS_OUTPUT.PUT_LINE('2 > 3 : ' || test(2 > 3, 1, 0));
    tmp := test(null, 1, 0);
    
    IF tmp IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('널 데이터 입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE(tmp);
    END IF; -- IF 명령 종료 선언
END;    -- 무명 프로시저 종료 선언
/    
    