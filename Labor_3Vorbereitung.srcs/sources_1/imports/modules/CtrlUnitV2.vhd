----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: CtrlUnitV2
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CtrlUnitV2 is
    Port ( CLK, RSTN                             : in  std_ulogic;
           OPCODE                                : in  std_ulogic_vector (7 downto 0);
           STATEIND                              : out std_ulogic_vector (1 downto 0);
           IPCLK, IRCLK, ACCLK, OUTCLK           : out std_ulogic;
           RE                                    : out std_ulogic);
end CtrlUnitV2;

architecture CtrlUnitBehavior of CtrlUnitV2 is

type ctrlstates is (S0, S1, S2, S3);

signal S, Splus  : ctrlstates;

begin

    REG: process (CLK, RSTN)
    begin
        if (RSTN = '0') then 
            S <= S0;
        elsif (rising_edge(CLK)) then
            S <= Splus;         
        end if; 
    end process;
      
    TransOutNet : process (S, OPCODE)
    begin
        IPCLK <= '0';
        IRCLK <= '0';
        ACCLK <= '0';
        OUTCLK <= '0';
        
        RE <= '0';

        case S is
            when S0 => Splus <= S1; IPCLK <= '1'; STATEIND <= "00";
            when S1 => IRCLK <= '1'; STATEIND <= "01";
                       
                       case OPCODE is
						   when x"00"  => Splus <= S3; RE <= '0';-- something is missing here ...;
                           when x"41"  => Splus <= S2; RE <= '1';-- and here ...;
                           when x"42"  => Splus <= S2; RE <= '1'; -- and here ...;
                           when x"44"  => Splus <= S2; RE <= '1';-- and here;
                           when others => Splus <= S2; RE <= '0';
                       end case;
                       
            when S2 => Splus <= S0; ACCLK <= '1'; STATEIND <= "10";
            when S3 => SPLUS <= S0; OUTCLK <= '1'; STATEIND <= "11";
        end case;
        
    end process;
    
end architecture CtrlUnitBehavior;
