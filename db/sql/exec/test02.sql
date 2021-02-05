DECLARE
    f_num NUMBER;
    s_num NUMBER;
    
    PROCEDURE swap( -- 일반 프로시저 선언
        no1 IN OUT NUMBER,
        no2 IN OUT NUMBER
    )
    IS
        tmp_no NUMBER;
    BEGIN
        tmp_no := no1;
        no1 := no2;
        no2 := tmp_no;
    END;            -- 일반 프로시저 종료
-- 여기까지가 무명 프로시저 선언부 
BEGIN   -- 여기서부터 무명 프로시저 실행
    f_num := 10;
    s_num := 20;
    
    -- 출력
    DBMS_OUTPUT.PUT_LINE('첫번째 숫자 : ' || TO_CHAR(f_num));
    DBMS_OUTPUT.PUT_LINE('두번째 숫자 : ' || TO_CHAR(s_num));
    swap(f_num, s_num);
    DBMS_OUTPUT.PUT_LINE('######### 저장프로시저 호출 후 #############');
    DBMS_OUTPUT.PUT_LINE('첫번째 숫자 : ' || TO_CHAR(f_num));
    DBMS_OUTPUT.PUT_LINE('두번째 숫자 : ' || TO_CHAR(s_num));
END;
/