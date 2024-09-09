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

entity Aux_ButtonClk is
    Port ( CLK, RSTN                             : in  std_ulogic;
           BTNL, BTNC, BTNR, BTND, BTNU          : in  std_ulogic;
           IRCLK, ACCUCLK, OUTCLK, IPCLK, MANCLK : out std_ulogic);
end Aux_ButtonClk;

architecture Aux_ButtonClkBehavior of Aux_ButtonClk is

type btnstates is (idle, trigger, locked);

signal BTLS, BTLSplus  : btnstates;
signal BTCS, BTCSplus  : btnstates;
signal BTRS, BTRSplus  : btnstates;
signal BTDS, BTDSplus  : btnstates;
signal BTUS, BTUSplus  : btnstates;

-- counters for debouncing the buttons
signal DBLCTR, DBLCTRplus : unsigned (20 downto 0);
signal DBCCTR, DBCCTRplus : unsigned (20 downto 0);
signal DBRCTR, DBRCTRplus : unsigned (20 downto 0);
signal DBDCTR, DBDCTRplus : unsigned (20 downto 0);
signal DBUCTR, DBUCTRplus : unsigned (20 downto 0);

begin

    UDCtr: process (CLK, RSTN)
    begin
        if (RSTN = '0') then 
            BTLS <= idle;
            BTCS <= idle;
            BTRS <= idle;
            BTDS <= idle;
            BTUS <= idle;            
            DBLCTR <= (others => '1');
            DBCCTR <= (others => '1');
            DBRCTR <= (others => '1');
            DBDCTR <= (others => '1');
            DBUCTR <= (others => '1');
        elsif (rising_edge(CLK)) then
            BTLS <= BTLSplus;
            BTCS <= BTCSplus;
            BTRS <= BTRSplus;
            BTDS <= BTDSplus;
            BTUS <= BTUSplus; 
            DBLCTR <= DBLCTRplus;
            DBCCTR <= DBCCTRplus;
            DBRCTR <= DBRCTRplus;
            DBDCTR <= DBDCTRplus;
            DBUCTR <= DBUCTRplus;           
        end if; 
    end process;
      
    BTLTransOutNet : process (BTLS, BTNL, DBLCTR)
    begin
        BTLSplus <= BTLS;
        IRCLK <= '0';
        DBLCTRplus <= (others => '1');
        
        case BTLS is
            when idle => if (BTNL = '1') then BTLSplus <= trigger; end if;
            when trigger => BTLSplus <= locked; IRCLK <= '1';
            when locked => if (DBLCTR /= 0) then DBLCTRplus <= DBLCTR-1;
                           elsif (BTNL = '0') then BTLSplus <= idle; end if;
        end case;
        
    end process;
    
    BTCTransOutNet : process (BTCS, BTNC, DBCCTR)
    begin
        BTCSplus <= BTCS;
        ACCUCLK <= '0';
        DBCCTRplus <= (others => '1');
        
        case BTCS is
            when idle => if (BTNC = '1') then BTCSplus <= trigger; end if;
            when trigger => BTCSplus <= locked; ACCUCLK <= '1';
            when locked => if (DBCCTR /= 0) then DBCCTRplus <= DBCCTR-1;
                           elsif (BTNC = '0') then BTCSplus <= idle; end if;
        end case;
        
    end process;
    
    BTRTransOutNet : process (BTRS, BTNR, DBCCTR, DBRCTR)
    begin
        BTRSplus <= BTRS;
        OUTCLK <= '0';
        DBRCTRplus <= (others => '1');
        
        case BTRS is
            when idle => if (BTNR = '1') then BTRSplus <= trigger; end if;
            when trigger => BTRSplus <= locked; OUTCLK <= '1';
            when locked =>  if (DBRCTR /= 0) then DBRCTRplus <= DBRCTR-1;
                            elsif (BTNR = '0') then BTRSplus <= idle; end if;
        end case;
        
    end process;
    
    BTDTransOutNet : process (BTDS, BTND, DBCCTR, DBDCTR)
    begin
        BTDSplus <= BTDS;
        IPCLK <= '0';
        DBDCTRplus <= (others => '1');
        
        case BTDS is
            when idle => if (BTND = '1') then BTDSplus <= trigger; end if;
            when trigger => BTDSplus <= locked; IPCLK <= '1';
            when locked =>  if (DBDCTR /= 0) then DBDCTRplus <= DBDCTR-1;
                            elsif (BTND = '0') then BTDSplus <= idle; end if;
        end case;
        
    end process;
    
    BTUTransOutNet : process (BTUS, BTNU, DBCCTR, DBUCTR)
    begin
        BTUSplus <= BTUS;
        MANCLK <= '0';
        DBUCTRplus <= (others => '1');
        
        case BTUS is
            when idle => if (BTNU = '1') then BTUSplus <= trigger; end if;
            when trigger => BTUSplus <= locked; MANCLK <= '1';
            when locked => if (DBUCTR /= 0) then DBUCTRplus <= DBUCTR-1;
                           elsif (BTNU = '0') then BTUSplus <= idle; end if;
        end case;
        
    end process;
          
end architecture Aux_ButtonClkBehavior;
