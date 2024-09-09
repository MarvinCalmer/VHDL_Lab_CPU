----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: Accu
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Accu is
    Port ( ACCUCLK, RSTN       : in  std_ulogic;
           A, B   : in  std_ulogic_vector (7 downto 0);
           AX, BX : out std_ulogic_vector (7 downto 0));
end entity Accu;

architecture AccuBehavior of Accu is

    signal S, Splus : std_ulogic_vector (15 downto 0);

begin

    Reg: process (ACCUCLK, RSTN)
    begin
        if (RSTN = '0') then 
            S <= (others => '0');
        elsif (rising_edge(ACCUCLK)) then
            S <= Splus;
        end if; 
    end process;
    
    Splus <= ( A & B );
    
    AX <= S(15 downto 8);
    BX <= S(7 downto 0); 

end architecture AccuBehavior;
