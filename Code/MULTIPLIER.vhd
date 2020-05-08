LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MULTIPLIER IS
  PORT (
    CLK : IN std_logic;
    DONE_s : IN std_logic; --DONE_s input
    DIGIT_s : IN std_logic_vector(3 DOWNTO 0); --out from GAL DIGIT
    CORRECT : OUT std_logic; --password check
    SENT_PULSE : OUT std_logic; --exit pulse
    RESET : IN std_logic --RESET input
  );
END MULTIPLIER;

ARCHITECTURE ARCH OF MULTIPLIER IS
  TYPE STATE_TYPE IS (Q0, Q1, Q2); --State declaration
  SIGNAL STATE : STATE_TYPE;
BEGIN
  PROCESS (CLK)
  BEGIN
    IF (rising_edge(CLK)) THEN
      CASE STATE IS
        WHEN Q0 => CORRECT <= '0';
          SENT_PULSE <= '0';
          IF (DONE_s = '1' AND DIGIT_s = "1111") THEN
            STATE <= Q1; --when DONE_s and all correct change state
          ELSIF (DONE_s = '1' AND DIGIT_s /= "1111") THEN
            STATE <= Q2; --some DIGIT output is not one so INCORRECT
          ELSE
            STATE <= Q0;
          END IF;
        WHEN Q1 => CORRECT <= '1';
          SENT_PULSE <= '1';
          IF (RESET = '1') THEN
            STATE <= Q0; --if RESET then restart
          ELSE
            STATE <= Q1; --if not, stay in Q1
          END IF;
        WHEN Q2 => CORRECT <= '0'; --INCORRECT= !CORRECT 
          SENT_PULSE <= '1';
          IF (RESET = '1') THEN
            STATE <= Q0; --if RESET then restart
          ELSE
            STATE <= Q2; --if not, stay in Q2
          END IF;
      END CASE;
    END IF;
  END PROCESS;
END ARCH;