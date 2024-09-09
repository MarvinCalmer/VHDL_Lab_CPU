----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: Aux_ClockDiv
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Aux_ClockDiv is

    -- Attention: if divider is odd, duty cycle of OUTCLK is not 50% !
    Generic( divider: natural := 2 );

    Port ( RSTN               : in  std_ulogic;
           INCLK              : in  std_ulogic;
           OUTCLK             : out std_ulogic);
           
end entity Aux_ClockDiv;

architecture Aux_ClockDivBehavior of Aux_ClockDiv is

function num_bits(n: natural) return natural is

variable nbits, ntmp : natural;

begin
    nbits := 1;
    
    ntmp := n / 2;
    
    while (ntmp /= 0) loop
        nbits := nbits + 1;
        ntmp := ntmp / 2;
    end loop;
    
    return nbits;
 
end num_bits;

constant flip1   : natural := divider / 2 - 1;
constant flip2   : natural := divider - 1;
constant cntbits : natural := num_bits(divider); 

signal DIVCTR, DIVCTRplus : unsigned (cntbits-1 downto 0);
signal CLK, CLKplus       : std_ulogic;

begin

    CtrUpd: process (INCLK, RSTN)
    begin
        if (RSTN = '0') then  
              DIVCTR <= (others=>'0');
              CLK <= '1';
        elsif (rising_edge(INCLK)) then
            CLK <= CLKplus;
            DIVCTR <= DIVCTRplus; 
        end if; 
    end process;
    
    CLKplus <= not CLK when ( ( DIVCTR = flip1 ) or 
                              ( DIVCTR = flip2 ) ) else CLK;
    DIVCTRplus <= (others=>'0') when ( DIVCTR = flip2 ) else DIVCTR + 1;
      
    OUTCLK <= CLK;
      
end architecture Aux_ClockDivBehavior;
