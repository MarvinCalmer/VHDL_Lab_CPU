----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: Aux_ALUCtrlS
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Aux_ALUCtrlS is
    Port ( CLK, RSTN     : in std_ulogic;
           BTNUP, BTNDWN : in std_ulogic;
           S             : out std_ulogic_vector (3 downto 0));
end Aux_ALUCtrlS;

architecture Aux_ALUCtrlSBehavior of Aux_ALUCtrlS is

type btnstates is (idle, trigger, locked);

signal CTR4, CTR4plus  : unsigned (3 downto 0);

signal BTUS, BTUSplus  : btnstates;
signal BTDS, BTDSplus  : btnstates;

-- counters for debouncing the buttons
signal DBUCTR, DBUCTRplus : unsigned (20 downto 0);
signal DBDCTR, DBDCTRplus : unsigned (20 downto 0);

begin

    UDCtr: process (CLK, RSTN)
    begin
        if (RSTN = '0') then 
            CTR4 <= (others => '0');
            BTUS <= idle;
            BTDS <= idle;
            DBUCTR <= (others => '1');
            DBDCTR <= (others => '1');            
        elsif (rising_edge(CLK)) then
            CTR4 <= CTR4plus;
            BTUS <= BTUSplus;
            BTDS <= BTDSplus;
            DBUCTR <= DBUCTRplus; 
            DBDCTR <= DBDCTRplus;
        end if; 
    end process;
    
    CTRTransNet: process (CTR4, BTUS, BTDS)
    begin
        CTR4plus <= CTR4;

        if (BTUS = trigger) then
            CTR4plus <= CTR4 + 1;
        elsif (BTDS = trigger) then
            CTR4plus <= CTR4 - 1;
        end if;
        
    end process;
    
    BTUTransNet : process (BTUS, BTNUP, DBUCTR)
    begin
        BTUSplus <= BTUS;
        DBUCTRplus <= (others => '1');
        
        case BTUS is
            when idle => if (BTNUP = '1') then BTUSplus <= trigger; end if;
            when trigger => BTUSplus <= locked;
            when locked => if (DBUCTR /= 0) then DBUCTRplus <= DBUCTR-1;
                           elsif (BTNUP = '0') then BTUSplus <= idle; end if;
        end case;
        
    end process;
    
    BTDTransNet : process (BTDS, BTNDWN, DBDCTR)
    begin
        BTDSplus <= BTDS;
        DBDCTRplus <= (others => '1');
        
        case BTDS is
            when idle => if (BTNDWN = '1') then BTDSplus <= trigger; end if;
            when trigger => BTDSplus <= locked;
            when locked => if (DBDCTR /= 0) then DBDCTRplus <= DBDCTR-1;
                           elsif (BTNDWN = '0') then BTDSplus <= idle; end if;
        end case;
        
    end process; 
          
    S <= std_ulogic_vector(CTR4);

end architecture Aux_ALUCtrlSBehavior;
