----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: MINIuP_T1
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MINIuP_T1 is
    Port ( CLK100MHZ : in std_ulogic; -- The NEXYS4DDR board uses an external 100MHz oscillator at E3
           RESETN    : in std_ulogic; -- This is wired to the CPU_RESET button of the NEXYS4DDR board
           SW        : in std_ulogic_vector (15 downto 0);
           BTNC      : in std_ulogic;
           BTNL      : in std_ulogic;
           BTNR      : in std_ulogic;
           BTND      : in std_ulogic;
           BTNU      : in std_ulogic;             
           LED       : out std_ulogic_vector (15 downto 0);
           AN        : out std_ulogic_vector (7 downto 0);
           CT        : out std_ulogic_vector (1 to 7);
           CTP       : out std_ulogic );
end MINIuP_T1;

architecture MINIuP_T1Behavior of MINIuP_T1 is

    signal clk_base                    : std_ulogic;
    signal s                           : std_ulogic_vector (3 downto 0);
    signal a, b                        : std_ulogic_vector (7 downto 0);
    signal zero, sign, carry, overflow : std_ulogic;
    signal y                           : std_ulogic_vector (15 downto 0);
    
    component Aux_ClockDiv is
        Generic( divider: natural := 2 );
        
        Port ( RSTN               : in  std_ulogic;
               INCLK              : in  std_ulogic;
               OUTCLK             : out std_ulogic);
    end component;

    component ALU
        Port ( A, B                    : in  std_ulogic_vector (7 downto 0);
           S                           : in  std_ulogic_vector (3 downto 0);
           Y                           : out std_ulogic_vector (15 downto 0);
           ZERO, SIGN, CARRY, OVERFLOW : out std_ulogic);
    end component;
    
    component Aux_ALUCtrlS
    Port ( CLK, RSTN     : in std_ulogic;
           BTNUP, BTNDWN : in std_ulogic;
           S             : out std_ulogic_vector (3 downto 0)); 
    end component;

    component Aux_NXS47Seg
       Port ( CLK     : in std_ulogic;
              RSTN    : in std_ulogic;
              DWORD   : in std_ulogic_vector (31 downto 0);
              DDOTS   : in std_ulogic_vector (7 downto 0);
              DENABLE : in std_ulogic_vector (7 downto 0);
              ANOSEL  : out std_ulogic_vector (7 downto 0);
              CATNO   : out std_ulogic_vector (1 to 7);
              CATDD   : out std_ulogic );
    end component;


begin

    a <= SW(15 downto 8);
    b <= SW(7 downto 0);
    
    BCLK      : Aux_ClockDiv generic map ( divider => 12 ) -- 100e6MHz/12=8.33MHz
                         port map ( RSTN=>RESETN,
                                    INCLK=>CLK100MHz, OUTCLK=>clk_base );
    
    CtrlSMAP : Aux_ALUCtrlS port map ( CLK=>clk_base, RSTN=>RESETN, BTNUP=>BTNU, BTNDWN=>BTND, S=>s);
    
    ALUMAP   : ALU port map ( A=>a, B=>b, S=>s,
                              Y=>y, ZERO=>zero, SIGN=>sign, CARRY=>carry, OVERFLOW=>overflow);
                              
    Seg7MAP  : Aux_NXS47Seg port map ( CLK=>clk_base, RSTN=>RESETN,
                                   DWORD(31 downto 24)=>a, DWORD(23 downto 16)=>b,
                                   DWORD(15 downto 0)=>Y,
                                   DDOTS=>"10111011",   DENABLE=>"11111111",
                                   ANOSEL=>AN, CATNO=>CT, CATDD=> CTP ); 
                                    
    LED(15) <= zero;
    LED(14) <= sign;
    LED(13) <= carry;
    LED(12) <= overflow;
    LED(11 downto 4) <= (others => '0');
    LED(3 downto 0) <= s;
                       
end MINIuP_T1Behavior;
