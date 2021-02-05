DECLARE
    x NUMBER;   -- 이 부분을 우리는 "변수 선언"이라고 한다.
BEGIN
    DBMS_OUTPUT.ENABLE;
    x := 1000;  -- 대입명령
    
    DBMS_OUTPUT.PUT_LINE('결과 = ');  -- 콘솔 화면에 '결과 = ' 이라는 문자열을 출력해준다.
    DBMS_OUTPUT.PUT_LINE(x);    -- 콘솔화면에 변수를 출력해준다.
END;
/