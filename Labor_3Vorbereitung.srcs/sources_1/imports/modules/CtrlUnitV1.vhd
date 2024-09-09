----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: CtrlUnitV1
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CtrlUnitV1 is
    Port ( CLK, RSTN                             : in  std_ulogic;
           OPCODE                                : in  std_ulogic_vector (7 downto 0);
           STATEIND                              : out std_ulogic_vector (1 downto 0);
           IPCLK, IRCLK, ACCLK, OUTCLK           : out std_ulogic);
end CtrlUnitV1;

architecture CtrlUnitBehavior of CtrlUnitV1 is

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
      
    TransNet : process (S, OPCODE)
    begin
        case S is
            when S0 => Splus <= S1;
            when S1 =>
                if OPCODE = x"00" then
                    Splus <= S3;
                else
                    Splus <= S2;
                end if; -- something is missing here; 
            when S2 =>
                Splus <= S0; -- something is missing here;
            when S3 =>
                Splus <= S0; -- something is missing here;
        end case;
        
    end process;

    OutNet : process (S)
    begin
        IPCLK <= '0';
        IRCLK <= '0';
        ACCLK <= '0';
        OUTCLK <= '0';

        case S is
            when S0 => IPCLK <= '1'; STATEIND <= "00";
            when S1 => IRCLK <= '1'; STATEIND <= "01";-- something is missing here;
            when S2 => ACCUCLK <= '1'; STATEIND <= "10"; -- something is missing here;
            when S3 => OUTCLK <= '1'; STATEIND <= "11"; -- something is missing here;
			when others =>
                IPCLK <= '0';
                IRCLK <= '0';
                ACCUCLK <= '0';
                OUTCLK <= '0';
                STATEIND <= "00";
        end case;
        
    end process;
    
end architecture CtrlUnitBehavior;
