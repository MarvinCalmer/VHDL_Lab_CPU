----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: RAM
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity RAM is

    Generic( addrWidth: integer := 8;
             dataWidth: integer := 8 );
    
    Port ( CLK         : in  std_ulogic;
           RE, WE, OE  : in  std_ulogic;
           ADDR        : in std_ulogic_vector (addrWidth-1 downto 0);
           DATAIN      : in std_ulogic_vector (dataWidth-1 downto 0);
           DATAOUT     : out std_ulogic_vector (dataWidth-1 downto 0));
           
end entity RAM;

architecture RAMBehavior of RAM is

    type ram_array is array (2**addrWidth-1 downto 0) of std_ulogic_vector(dataWidth-1 downto 0);

    signal Memory : ram_array;
    signal RAMout : std_ulogic_vector (dataWidth-1 downto 0);
   
begin

    Mem: process (CLK)
    begin
    
        if (falling_edge(CLK)) then
            if (RE = '1') then
                if (WE = '1') then
                    Memory(to_integer(unsigned(ADDR))) <= DATAIN;
                    RAMout <= DATAIN;
                else
                    RAMout <= Memory(to_integer(unsigned(ADDR)));
                end if;
            end if;
        end if;
             
    end process;
    
    DATAOUT <= RAMout when (OE = '1') else (others => 'Z');
    
end architecture RAMBehavior;
