LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FSM IS
  PORT (
    CLK : IN std_logic;
    RESET : IN std_logic; --RESET input
    S : IN std_logic_vector(1 DOWNTO 0); --States from SAFECODE
    DONE : OUT std_logic := '0'; --DONE output
  );
END FSM;

ARCHITECTURE ARCH OF FSM IS
  TYPE STATE_TYPE IS (Q0, Q1, Q2); --State declaration
  SIGNAL STATE : STATE_TYPE;
BEGIN
  PROCESS (CLK, RESET)
  BEGIN
    IF (rising_edge(CLK)) THEN
      DONE <= '0';-- Initialize DONE=0
      CASE STATE IS
        WHEN Q0 => DONE <= '0'; --State 0, DONE=0
          IF (S = "00") THEN --If State of SAFECODE 0
            STATE <= Q1; --Go to State 1
          END IF;
        WHEN Q1 => DONE <= DONE; --State 1, DONE=DONE
          IF (S = "10") THEN --If State of SAFECODE 2
            DONE <= '1'; --DONE=1
            STATE <= Q2; --Go to State 2
          END IF;
        WHEN Q2 => DONE <= DONE; --State 2, DONE=DONE
          IF (RESET = '1') THEN --If RESET=1
            STATE <= Q0; --Go back to State 0
          END IF;
      END CASE;
    END IF;
  END PROCESS;
END ARCH;