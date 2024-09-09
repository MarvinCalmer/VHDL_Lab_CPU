----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: InstrReg
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OutReg is
    Port ( OUTCLK, RSTN : in std_ulogic;
           INWORD       : in std_logic_vector (7 downto 0);
           OUTWORD      : out std_ulogic_vector (7 downto 0));
end entity OutReg;

architecture OutRegBehavior of OutReg is

    signal S, Splus : std_ulogic_vector (7 downto 0);

begin

    Reg: process (OUTCLK, RSTN)
    begin
        if (RSTN = '0') then 
            S <= (others => '0');
        elsif (rising_edge(OUTCLK)) then
            S <= Splus;
        end if; 
    end process;
    
    Splus <= std_ulogic_vector(INWORD);
    
    OUTWORD <= S;

end architecture OutRegBehavior;
