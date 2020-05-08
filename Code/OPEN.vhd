LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY OPEN_DOOR IS
  PORT (
    CLK : IN std_logic;
    INCOMING_PULSE : IN std_logic; --INCOMING_PULSE input
    DONE : IN std_logic; --DONE input
    CORRECT : IN std_logic; --CORRECT PASSWORD input
    NUMBER : OUT std_logic_vector(0 TO 3); --Ring for display output
    ENABLE : OUT std_logic; --ENABLE output
    ENDPULSE_SEND_O : OUT std_logic; --ENDPULSE_SEND_O output
    RESET : IN std_logic --RESET input
  );
END OPEN_DOOR;

ARCHITECTURE ARCH OF OPEN_DOOR IS
  TYPE STATE_TYPE IS (Q0, Q1, Q2, Q3, Q4); --State declaration
  SIGNAL STATE : STATE_TYPE;

BEGIN
  PROCESS (CLK)
  BEGIN
    IF (rising_edge(CLK)) THEN
      CASE STATE IS

        WHEN Q0 => ENABLE <= '0'; --initialize ENABLE=0
          ENDPULSE_SEND_O <= '0'; --initialize ENDPULSE_SEND=0

          IF (DONE = '1' AND CORRECT = '1' 
          AND INCOMING_PULSE = '1') THEN 
          --If Done=1 && Correct=0 && Incoming_pulse=1
            STATE <= Q1; --Go to state 1
          ELSE
            STATE <= Q0; --Stay at state 0
          END IF;
          -- RING INITIALIZE
        WHEN Q1 => ENABLE <= '1'; --ENABLE=1
          ENDPULSE_SEND_O <= '1'; --ENDPULSE_SEND=1
          NUMBER <= "1000"; --DISPLAY 1 ON
          STATE <= Q2; --Go to state 2

        WHEN Q2 => NUMBER <= "0100"; --DISPLAY 2 ON
          STATE <= Q3;--Go to state 

        WHEN Q3 => NUMBER <= "0010"; --DISPLAY 3 ON
          STATE <= Q4;--Go to state 4

        WHEN Q4 => NUMBER <= "0001"; --DISPLAY 4 ON

          IF (RESET = '1') THEN --If RESET=1
            STATE <= Q0; --Go back to state 0 (FINISH DISPLAYING)
          ELSE
            STATE <= Q1; --Go back to state 1 (KEEP DISPLAYING)
          END IF;
      END CASE;
    END IF;
  END PROCESS;
END ARCH;