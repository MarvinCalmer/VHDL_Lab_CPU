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

entity InstrReg is
    Port ( IRCLK, RSTN       : in  std_ulogic;
           OPCODEI, OPERANDI : in  std_ulogic_vector (7 downto 0);
           OPCODEO, OPERANDO : out std_ulogic_vector (7 downto 0));
end entity InstrReg;

architecture InstrRegBehavior of InstrReg is

    signal S, Splus : std_ulogic_vector (15 downto 0);

begin

    Reg: process (IRCLK, RSTN)
    begin
        if (RSTN = '0') then 
            S <= (others => '0');
        elsif (rising_edge(IRCLK)) then
            S <= Splus;
        end if; 
    end process;
    
    Splus <= ( OPCODEI & OPERANDI );
    
    OPCODEO <= S(15 downto 8);
    OPERANDO <= S(7 downto 0); 

end architecture InstrRegBehavior;
