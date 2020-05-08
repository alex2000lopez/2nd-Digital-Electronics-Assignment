LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ENABLES IS
  PORT (
    CLK : IN std_logic; --CLOCK input
    READY : IN std_logic; --READY input
    DISP_EN_ : IN std_logic_vector(0 TO 1); --Display choice input
    DISP_EN : OUT std_logic_vector(0 TO 2); --Display choice output
    TURN_ON : OUT std_logic --Begin 
  );
END ENABLES;

ARCHITECTURE ARCH OF ENABLES IS
BEGIN
  PROCESS (CLK)
  BEGIN
    IF (rising_edge(CLK)) THEN
      IF (READY = '1') THEN
        TURN_ON <= '1';
      ELSE
        TURN_ON <= '0';
      END IF;
      IF DISP_EN_(0) = '1' THEN --Display OPEN
        DISP_EN(0) <= '0';
        DISP_EN(1) <= '1';--Enable tristates OPEN
        DISP_EN(2) <= '0';
      ELSIF DISP_EN_(1) = '1' THEN --Display ERR
        DISP_EN(0) <= '0';
        DISP_EN(1) <= '0';
        DISP_EN(2) <= '1';--Enable tristates ERROR
      ELSE --Display RAM
        DISP_EN(0) <= '1';--Enable decoder and tristates display
        DISP_EN(1) <= '0';
        DISP_EN(2) <= '0';
      END IF;
    END IF;
  END PROCESS;
END ARCH;