----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences 
-- Engineer: G. Schmidt
-- 
-- Module Name: Aux_NXS47Seg - Aux_NXS47Seg 
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity Aux_NXS47Seg is

   Port ( CLK      : in std_ulogic; -- The NEXYS4DDR board uses an external 100MHz oscillator at E3
          RSTN    : in std_ulogic; -- This is wired to the CPU_RESET button of the NEXYS4DDR board
          DWORD   : in std_ulogic_vector (31 downto 0);
          DDOTS   : in std_ulogic_vector (7 downto 0);
          DENABLE : in std_ulogic_vector (7 downto 0);
          ANOSEL  : out std_ulogic_vector (7 downto 0);
          CATNO   : out std_ulogic_vector (1 to 7);
          CATDD   : out std_ulogic );
           
end Aux_NXS47Seg;


architecture Aux_NXS47SegBehavior of Aux_NXS47Seg is

    subtype Counter is unsigned (12 downto 0); 

    signal Hex2Disp   : std_ulogic_vector (3 downto 0); -- The hex value to be displayed
    signal RefreshCtr : Counter;
    signal DspSel : std_ulogic_vector (2 downto 0);
    
begin

    -- Hex to 7 Segment decoder
    Hex2Seg7 : process(Hex2Disp) -- please note that bit patterns need to be inverted
    begin                        -- to control cathode signals
        case Hex2Disp is
           when x"0"   => CATNO <= "0000001"; -- "0"     
           when x"1"   => CATNO <= "1001111"; -- "1" 
           when x"2"   => CATNO <= "0010010"; -- "2" 
           when x"3"   => CATNO <= "0000110"; -- "3" 
           when x"4"   => CATNO <= "1001100"; -- "4" 
           when x"5"   => CATNO <= "0100100"; -- "5" 
           when x"6"   => CATNO <= "0100000"; -- "6" 
           when x"7"   => CATNO <= "0001111"; -- "7" 
           when x"8"   => CATNO <= "0000000"; -- "8"     
           when x"9"   => CATNO <= "0000100"; -- "9" 
           when x"A"   => CATNO <= "0001000"; -- "A"
           when x"B"   => CATNO <= "1100000"; -- "b"
           when x"C"   => CATNO <= "0110001"; -- "C"
           when x"D"   => CATNO <= "1000010"; -- "d"
           when x"E"   => CATNO <= "0110000"; -- "E"
           when x"F"   => CATNO <= "0111000"; -- "F"
           when others => CATNO <= "1111111"; -- off
       end case;
    end process;
    
    -- generate display refresh signal from counter
    Refresh : process (CLK, RSTN)
    begin
        if (RSTN = '0') then
            RefreshCtr <= (others => '0');
        elsif (rising_edge(CLK)) then
            RefreshCtr <= RefreshCtr + 1;
        end if;
    end process;
    
    -- control LED anode and cathode signals for selected display element 
    SelDspEl : process (DspSel, DWORD, DDOTS, DENABLE, RSTN)
    begin
        ANOSEL <= (others => '1'); -- default assignment disables displayed digit
        
        case DspSel is
            when "000"  => if (DENABLE(0) = '1' and RSTN = '1') then ANOSEL <= "11111110"; end if;
                           Hex2Disp <= DWORD(3 downto 0); CATDD <= DDOTS(0);
            when "001"  => if (DENABLE(1) = '1' and RSTN = '1') then ANOSEL <= "11111101"; end if;
                           Hex2Disp <= DWORD(7 downto 4); CATDD <= DDOTS(1);
            when "010"  => if (DENABLE(2) = '1' and RSTN = '1') then ANOSEL <= "11111011"; end if;
                           Hex2Disp <= DWORD(11 downto 8); CATDD <= DDOTS(2);
            when "011"  => if (DENABLE(3) = '1' and RSTN = '1') then ANOSEL <= "11110111"; end if;
                           Hex2Disp <= DWORD(15 downto 12); CATDD <= DDOTS(3);
            when "100"  => if (DENABLE(4) = '1' and RSTN = '1') then ANOSEL <= "11101111"; end if;
                           Hex2Disp <= DWORD(19 downto 16); CATDD <= DDOTS(4);
            when "101"  => if (DENABLE(5) = '1' and RSTN = '1') then ANOSEL <= "11011111"; end if;
                           Hex2Disp <= DWORD(23 downto 20); CATDD <= DDOTS(5);
            when "110"  => if (DENABLE(6) = '1' and RSTN = '1') then ANOSEL <= "10111111"; end if;
                           Hex2Disp <= DWORD(27 downto 24); CATDD <= DDOTS(6);
            when "111"  => if (DENABLE(7) = '1' and RSTN = '1') then ANOSEL <= "01111111"; end if;
                           Hex2Disp <= DWORD(31 downto 28); CATDD <= DDOTS(7);
            when others => if (DENABLE(7) = '1' and RSTN = '1') then ANOSEL <= "11111111"; end if;
                           Hex2Disp <= "0000"; CATDD <= '0';
        end case;
    end process;
    
    DspSel <= std_ulogic_vector(RefreshCtr(RefreshCtr'left downto RefreshCtr'left-2));
    
end architecture Aux_NXS47SegBehavior;
