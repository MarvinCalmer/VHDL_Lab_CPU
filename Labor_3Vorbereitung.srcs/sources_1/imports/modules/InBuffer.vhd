----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: InBuffer
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InBuffer is
    Port ( EN   : in  std_ulogic;
           DIN  : in  std_ulogic_vector (7 downto 0);
           DOUT : out std_logic_vector (7 downto 0));
end entity InBuffer;

architecture InBufferBehavior of InBuffer is
begin
   
    DOUT <= std_logic_vector(DIn) when (EN='1') else (others => 'Z');
    
end architecture InBufferBehavior;
