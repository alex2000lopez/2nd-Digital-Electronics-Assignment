LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY KEYPAD IS
  PORT (
    START, CLK : IN std_logic; --start pulse
    C : IN std_logic_vector(2 DOWNTO 0); --column of keypad
    L : OUT std_logic_vector(3 DOWNTO 0); -- lines of keypad
    SIG : OUT std_logic_vector(3 DOWNTO 0); -- BCD of key pressed
    pulse : OUT std_logic; --a button is pressed
    READY : OUT std_logic := '1'
  );
END KEYPAD;

ARCHITECTURE ARCH OF KEYPAD IS
  SIGNAL l_temp : std_logic_vector(3 DOWNTO 0); --temporal value line
BEGIN
  pulse <= (C(0) OR C(1) OR C(2)); --detects if a button is pressed
  PROCESS (CLK)
  BEGIN
    IF (CLK = '1' AND CLK'EVENT) THEN
      IF START = '1' THEN --start pulse
        l_temp <= "0001"; --bit for ring introduced
      ELSE --ring
        l_temp(1) <= l_temp(0);
        l_temp(2) <= l_temp(1);
        l_temp(3) <= l_temp(2);
        l_temp(0) <= l_temp(3);
      END IF;
      IF (pulse = '1') THEN --if key pressed check table to BCD
        IF (l_temp(0) = '1' AND C(0) = '1') THEN
          SIG <= "0001";
        ELSIF (l_temp(1) = '1' AND C(0) = '1') THEN
          SIG <= "0100";
        ELSIF (l_temp(2) = '1' AND C(0) = '1') THEN
          SIG <= "0111";
        ELSIF (l_temp(3) = '1' AND C(0) = '1') THEN
          SIG <= "1100";
        ELSIF (l_temp(0) = '1' AND C(1) = '1') THEN
          SIG <= "0010";
        ELSIF (l_temp(1) = '1' AND C(1) = '1') THEN
          SIG <= "0101";
        ELSIF (l_temp(2) = '1' AND C(1) = '1') THEN
          SIG <= "1000";
        ELSIF (l_temp(3) = '1' AND C(1) = '1') THEN
          SIG <= "0000";
        ELSIF (l_temp(0) = '1' AND C(2) = '1') THEN
          SIG <= "0011";
        ELSIF (l_temp(1) = '1' AND C(2) = '1') THEN
          SIG <= "0110";
        ELSIF (l_temp(2) = '1' AND C(2) = '1') THEN
          SIG <= "1001";
        ELSIF (l_temp(3) = '1' AND C(2) = '1') THEN
          SIG <= "1111";
        ELSE
          SIG <= "1111";
        END IF;
      END IF;
    END IF;
  END PROCESS;
  L <= l_temp;
END ARCH;