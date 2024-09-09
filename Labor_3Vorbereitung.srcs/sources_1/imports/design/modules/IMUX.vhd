----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: IMUX
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IMUX is
    Port ( S      : in  std_ulogic;
           D0, D1 : in  std_ulogic_vector (7 downto 0);
           Y      : out std_ulogic_vector (7 downto 0));
end entity IMUX;

architecture IMUXBehavior of IMUX is
begin
   
    Y <= D0 when (S='0') else D1;
    
end architecture IMUXBehavior;
