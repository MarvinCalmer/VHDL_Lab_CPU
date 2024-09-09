----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: OMUX
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OMUX is
    Port ( S, EN  : in  std_ulogic;
           D0, D1 : in  std_ulogic_vector (7 downto 0);
           Y      : out std_logic_vector (7 downto 0));
end entity OMUX;

architecture OMUXBehavior of OMUX is
begin
   
    Y <= std_logic_vector(D0) when (EN='1' and S='0')
         else std_logic_vector(D1) when (EN='1' and S='1') else (others => 'Z');
    
end architecture OMUXBehavior;
