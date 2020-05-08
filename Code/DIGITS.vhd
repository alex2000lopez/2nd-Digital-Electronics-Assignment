LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DIGIT0 IS
  PORT(CLK : IN std_logic; --CLOCK input
       RESET : IN std_logic; --RESET input
       A : IN std_logic_vector(1 DOWNTO 0); --ADDRESS input
       D : IN std_logic_vector(3 DOWNTO 0); --password in keyboard
       PASS0 : IN std_logic_vector(3 DOWNTO 0); --correct password
       DONE : IN std_logic; --Done input
       DIGIT_0 : OUT std_logic --”correct or incorrect digit” out);
END DIGIT0;

ARCHITECTURE ARCH OF DIGIT0 IS
  TYPE STATE_TYPE IS (Q0, Q1); --State declaration
  SIGNAL STATE : STATE_TYPE;
BEGIN
  PROCESS (CLK, RESET)
  BEGIN
    IF (rising_edge(CLK)) THEN
      DIGIT_0 <= '0'; --initialize OKAY=0
      CASE STATE IS
        WHEN Q0 => DIGIT_0 <= '0'; --State 0, OKAY=0
          IF (DONE = '1' AND D = PASS0 AND A = "00") THEN 
            --If DONE && password = correct password && A=00
            STATE <= Q1; --Go to State 1
          END IF;
        WHEN Q1 => DIGIT_0 <= '1';--State 1, OKAY=1
          IF (RESET = '1') THEN --If RESET=1
            STATE <= Q0; --Go back to State 0
          END IF;
      END CASE;
    END IF;
  END PROCESS;
END ARCH;