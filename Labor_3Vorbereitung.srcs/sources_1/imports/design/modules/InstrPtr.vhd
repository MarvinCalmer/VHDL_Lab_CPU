----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: InstrPtr
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstrPtr is
    Port ( IPCLK, RSTN, IPLOADN : in  std_ulogic;
           DSTPTR               : in  std_ulogic_vector (7 downto 0);
           ISTPTR               : out std_ulogic_vector (7 downto 0));
end entity InstrPtr;

architecture InstrPtrBehavior of InstrPtr is

    signal IP, IPplus : std_ulogic_vector (7 downto 0);

begin

    Reg: process (IPCLK, RSTN)
    begin
        if (RSTN = '0') then 
            IP <= (others => '0');
        elsif (rising_edge(IPCLK)) then
            IP <= IPplus;
        end if; 
    end process;
   
    TransNet : process (IP, IPLOADN, DSTPTR)
    begin
        if (IPLOADN = '1') then
            IPplus <= std_ulogic_vector(unsigned(IP) + 1);
        else
            IPplus <= DSTPTR;
        end if;
    end process;
    
    ISTPTR <= std_ulogic_vector(IP);
 
end architecture InstrPtrBehavior;

