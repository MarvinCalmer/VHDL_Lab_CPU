----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: MINIuP_T5
-- 
-- Dependencies: 
-- 
-- Revision: 0.2
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MINIuP_T5 is
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
end MINIuP_T5;

architecture MINIuP_T5Behavior of MINIuP_T5 is

    signal clk_base                           : std_ulogic;
    signal irclk, ipclk, accuclk, outclk      : std_ulogic;
    signal manclk                             : std_ulogic;
    signal stind                              : std_ulogic_vector (1 downto 0);
    signal istptr                             : std_ulogic_vector (7 downto 0);
    signal opcodei, operandi                  : std_ulogic_vector (7 downto 0);
    signal opcodeo, operando                  : std_ulogic_vector (7 downto 0);
    signal s                                  : std_ulogic_vector (3 downto 0);
    signal imuxc, omuxc                       : std_ulogic;
    signal accuen                             : std_ulogic;
    signal a, b                               : std_ulogic_vector (7 downto 0);
    signal ao, bo                             : std_ulogic_vector (7 downto 0);
    signal ax, bx                             : std_ulogic_vector (7 downto 0);
    signal zero, sign, carry, overflow        : std_ulogic;
    signal y                                  : std_ulogic_vector (15 downto 0);
    signal iobus                            : std_logic_vector (7 downto 0);
    signal outsig                             : std_ulogic_vector (7 downto 0);
    signal dspsel                             : std_ulogic;
    signal dspword                            : std_ulogic_vector (7 downto 0);
    signal re, we, oe                         : std_ulogic;
    signal inport                             : std_ulogic_vector (7 downto 0);
    signal ipen                               : std_ulogic;
   
    component Aux_ClockDiv is
        Generic( divider: natural := 2 );

        Port ( RSTN               : in  std_ulogic;
               INCLK              : in  std_ulogic;
               OUTCLK             : out std_ulogic);
    end component;
    
    component CtrlUnitV2 is
    Port ( CLK, RSTN                             : in  std_ulogic;
           OPCODE                                : in  std_ulogic_vector (7 downto 0);
           STATEIND                              : out std_ulogic_vector (1 downto 0);
           IPCLK, IRCLK, ACCLK, OUTCLK           : out std_ulogic;
           RE                                    : out std_ulogic);
    end component;

    component InstrReg
        Port ( IRCLK, RSTN       : in  std_ulogic;
               OPCODEI, OPERANDI : in  std_ulogic_vector (7 downto 0);
               OPCODEO, OPERANDO : out std_ulogic_vector (7 downto 0));
    end component;
    
    component IMUX
        Port ( S      : in  std_ulogic;
               D0, D1 : in  std_ulogic_vector (7 downto 0);
               Y      : out std_ulogic_vector (7 downto 0));     
    end component;
    
    component MicroProgV2
        Port ( OPCODE        : in std_ulogic_vector(7 downto 0);
               S             : out std_ulogic_vector (3 downto 0);  
               IMUX, OMUX    : out std_ulogic;
               ACCUEN        : out std_ulogic;
               WE, OE        : out std_ulogic;
               PE            : out std_ulogic);
    end component;
    
    component ALU
        Port ( A, B                    : in  std_ulogic_vector (7 downto 0);
               S                           : in  std_ulogic_vector (3 downto 0);
               Y                           : out std_ulogic_vector (15 downto 0);
               ZERO, SIGN, CARRY, OVERFLOW : out std_ulogic);
    end component;
     
    component Accu
        Port ( ACCUCLK, RSTN       : in  std_ulogic;
               A, B   : in  std_ulogic_vector (7 downto 0);
               AX, BX : out std_ulogic_vector (7 downto 0));   
    end component;
    
    component OMUX
        Port ( S, EN  : in  std_ulogic;
               D0, D1 : in  std_ulogic_vector (7 downto 0);
               Y      : out std_logic_vector (7 downto 0));
    end component;
    
    component OutReg
        Port ( OUTCLK, RSTN : in std_ulogic;
               INWORD       : in std_logic_vector (7 downto 0);
               OUTWORD      : out std_ulogic_vector (7 downto 0));  
    end component; 
    
    component InstrPtr
        Port ( IPCLK, RSTN, IPLOADN : in  std_ulogic;
               DSTPTR               : in  std_ulogic_vector (7 downto 0);
               ISTPTR               : out std_ulogic_vector (7 downto 0));
    end component;
    
    component ProgROM_Testprog2
        Port ( ADDRESS : in  std_ulogic_vector (7 downto 0);
               OPCODE, OPERAND : out std_ulogic_vector (7 downto 0));
    end component;
    
    component RAM
        Generic ( addrWidth: integer;
                  dataWidth: integer );
             
        Port    ( CLK         : in  std_ulogic;
                  RE, WE, OE  : in  std_ulogic;
                  ADDR        : in std_ulogic_vector (addrWidth-1 downto 0);
                  DATAIN      : in std_ulogic_vector (dataWidth-1 downto 0);
                  DATAOUT     : out std_ulogic_vector (dataWidth-1 downto 0));       
    end component;

    component InBuffer
    Port ( EN   : in  std_ulogic;
           Din  : in  std_ulogic_vector (7 downto 0);
           Dout : out std_logic_vector (7 downto 0));
    end component;
    
    component Aux_AUXMUX
        Port ( S      : in  std_ulogic;
               D0, D1 : in  std_ulogic_vector (7 downto 0);
               Y      : out std_ulogic_vector (7 downto 0));     
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
    
    component Aux_ButtonClk
    Port ( CLK, RSTN                     : in  std_ulogic;
           BTNL, BTNC, BTNR              : in  std_ulogic;
           BTND, BTNU                    : in  std_ulogic;  -- won't be required (but mapped) in this task
           IRCLK, ACCUCLK, OUTCLK        : out std_ulogic;
           IPCLK, MANCLK                 : out std_ulogic); -- won't be required in this task 
    end component;
    
begin

    dspsel <= SW(0);
    inport <= SW(15 downto 8);-- add assignment of SW15..8 here;
   
    BCLK      : Aux_ClockDiv generic map ( divider => 12 ) -- 100e6MHz/12=8.33MHz
                         port map ( RSTN=>RESETN,
                                    INCLK=>CLK100MHz, OUTCLK=>clk_base );
    
    CTRL      : CtrlUnitV2 port map ( CLK=>manclk, RSTN=>RESETN,
                                      OPCODE=>opcodeo, STATEIND=>stind,
                                      IPCLK=>ipclk, IRCLK=>irclk, ACCLK=>accuclk, OUTCLK=>outclk, RE=>re);
    
    IP        : InstrPtr port map ( IPCLK=>ipclk, RSTN=>RESETN,
                                    IPLOADN=>'1', DSTPTR=>(others => '-'), ISTPTR=>istptr);
                                    
    PRG       : ProgROM_Testprog2 port map ( ADDRESS=>istptr, OPCODE=>opcodei, OPERAND=>operandi);
    
    IR        : InstrReg port map ( IRCLK=>irclk, RSTN=>RESETN,
                                    OPCODEI=>opcodei, OPERANDI=>operandi,
                                    OPCODEO=>opcodeo, OPERANDO=>operando );
                                
    INMUX     : IMUX port map ( S=>imuxc, D0=>operando, D1=>bx, Y=>b );     
                                
    MICROPROG : MicroProgV2 port map ( OPCODE=>opcodeo, S=>s,
                                       IMUX=>imuxc, OMUX=>omuxc, ACCUEN=>accuen,
                                       WE=>we, OE=>oe, PE=>ipen );
    
    ALUNIT    : ALU port map ( A=>a, B=>b, S=>s, Y(15 downto 8)=>bo, Y(7 downto 0)=>ao,
                               ZERO=>zero, SIGN=>sign, CARRY=>carry, OVERFLOW=>overflow );     
                             
    ACCUREG   : Accu port map ( ACCUCLK=>accuclk, RSTN=>RESETN,
                                A=>ao, B=>bo, AX=>ax, BX=>bx ); 
                              
    OUTMUX    : OMUX port map ( S=>omuxc, EN=>accuen, D0=>ax, D1=>bx, Y=>iobus );     
    
    OUTPUTREG : OutReg port map (OUTCLK=>outclk, RSTN=>RESETN, INWORD=>iobus, OUTWORD=>outsig ); 
    
    BLOCKRAM  : RAM generic map ( addrWidth => 8, dataWidth => 8)
                    port map ( CLK=>manclk, RE=>re, WE=>we, OE=>oe,
                               ADDR=>operando, DATAIN=>std_ulogic_vector(iobus),std_logic_vector(DATAOUT)=>iobus);

    INPUTPORT : InBuffer port map ( EN=>ipen, DIN=>inport, DOUT=>iobus );    -- add port map for input buffer here
      
    BUTTONS   : Aux_ButtonClk port map ( CLK=>clk_base, RSTN=>RESETN,
                                     BTNL=>BTNL, BTNC=>BTNC, BTNR=>BTNR, BTND=>BTND, BTNU=>BTNU,
                                     MANCLK=>manclk);

                                     
    ACCUSEL   : Aux_AUXMUX port map ( S=>dspsel, D0=>ax, D1=>bx, Y=>dspword );                                  
                              
    DEC7SEG   : Aux_NXS47Seg port map ( CLK=>clk_base, RSTN=>RESETN,
                                    DWORD(31 downto 24)=>opcodeo, DWORD(23 downto 16)=>operando,
                                    DWORD(15 downto 8)=>istptr, DWORD(7 downto 0)=>dspword,
                                    DDOTS=>"10111011",   DENABLE=>"11111111",
                                    ANOSEL=>AN, CATNO=>CT, CATDD=> CTP ); 
                                   
    a <= std_ulogic_vector(iobus);
                                    
    LED(15)          <= zero;
    LED(14)          <= sign;
    LED(13)          <= carry;
    LED(12)          <= overflow;
    LED(10 downto 9) <= stind;
    LED(7 downto 0)  <= outsig;
                                              
end MINIuP_T5Behavior;
