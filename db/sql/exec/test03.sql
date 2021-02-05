DECLARE
    error_flag BOOLEAN := false;
BEGIN
    DBMS_OUTPUT.PUT_LINE('*** 100 ~ 1000 숫자 처리 ***');
    DECLARE
        h_num NUMBER(1, -2);
    BEGIN
        h_num := 100;
        LOOP
            DBMS_OUTPUT.PUT_LINE(h_num);
            h_num  := h_num + 100;
            
            IF h_num > 1000 THEN
                exit;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN OTHERS  THEN
            error_flag := true;
    END;
    IF error_flag THEN
        DBMS_OUTPUT.PUT_LINE('### 숫자를 계산할 수 없습니다. ###');
    ELSE
        DBMS_OUTPUT.PUT_LINE('***** 계산이 종료 되었습니다. *****');
    END IF;
END;
/