LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DISPLAY IS
  PORT(CLK : IN std_logic;
       DONE : IN std_logic; --DONE input
       SEL : OUT std_logic_vector(3 DOWNTO 0); --DISP select output 
       A_OUT : OUT std_logic_vector(1 DOWNTO 0); --ADDR enable output
       WE_OUT : OUT std_logic; --Write enable output
       CS_OUT : OUT std_logic --Chip select output
END DISPLAY;

ARCHITECTURE ARCH OF DISPLAY IS
   TYPE STATE_TYPE IS (Q0, Q1, Q2, Q3); --State declaration
   SIGNAL STATE : STATE_TYPE;
BEGIN
   PROCESS (CLK)
      BEGIN
         IF (rising_edge(CLK)) THEN
            IF (DONE = '0') THEN --If DONE=0
               CS_OUT <= '0'; --Chip select=0
               WE_OUT <= '0'; --Write enable=0
               SEL <= "0000"; --DISPLAY select output=0
               A_OUT <= "00"; --ADDRESS enable output=0
            ELSE --If DONE=1
               CS_OUT <= '1'; --Chip select=1
               WE_OUT <= '1'; --Write enable=1
               CASE STATE IS
                  WHEN Q0 => A_OUT <= "00"; --State 0, A_OUT=0, SEL=1
                             SEL <= "0001";
                             STATE <= Q1; --Go to State 1
                  WHEN Q1 => A_OUT <= "01"; --State 1, A_OUT=1, SEL=2
                             SEL <= "0010";
                             STATE <= Q2; --Go to State 2
                  WHEN Q2 => A_OUT <= "10"; --State 2, A_OUT=3, SEL=3
                             SEL <= "0100";
                             STATE <= Q3; --Go to state 3
                  WHEN Q3 => A_OUT <= "11"; --State 3, A_OUT=4, SEL=4
                             SEL <= "1000";
                             STATE <= Q0; --Go back to State 0
               END CASE;
            END IF;
         END IF;
   END PROCESS;
END ARCH;