LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SAFECODE IS
  PORT (
    CLK : IN std_logic;
    SIG : IN std_logic_vector(3 DOWNTO 0); --Keypad input
    A : INOUT INTEGER RANGE 0 TO 3; --Address input & output
    D : OUT std_logic_vector(3 DOWNTO 0); --Password output to RAM
    CS : OUT std_logic --Chip select output
  );
END SAFECODE;

ARCHITECTURE ARCH OF SAFECODE IS
  TYPE STATE_TYPE IS (Q0, Q1, Q2, Q3); --State declaration
  SIGNAL STATE : STATE_TYPE;
BEGIN
  PROCESS (CLK)
  BEGIN
    IF (rising_edge(CLK)) THEN
      CASE STATE IS --State 0, A=0, CS=1
        WHEN Q0 => A <= 0;
          CS <= '1';
          IF (SIG = "1100") THEN --If “*”
            STATE <= Q1; --Go to State 1
          ELSE
            STATE <= Q0; --Stay in State 0
          END IF;
        WHEN Q1 => D <= SIG; --State 1, D=SIG, A=A, CS=0
          CS <= '0';
          A <= A;
          IF (SIG = "1100") --If “*”
            STATE <= Q1; --Stay in State 1
          ELSIF (SIG = "1111") THEN --If “#”
            STATE <= Q0; --Go back to State 0
          ELSE --If not “#”
            STATE <= Q2; --Go to State 2
          END IF;
        WHEN Q2 => CS <= '1'; --State 1, D=SIG, A=A, CS=1
          IF (D = SIG) THEN --If D=SIG
            STATE <= Q2; --Stay in State 2
          ELSIF (SIG = "1111") THEN --If “#”
            STATE <= Q0; --Go to State 0
          ELSE
            STATE <= Q3; --Go to State 3
          END IF;
        WHEN Q3 => A <= A + 1; --State 3, D=SIG, A=A+1, CS=1
          STATE <= Q1; --Go to State 1
      END CASE;
    END IF;
  END PROCESS;
END ARCH;