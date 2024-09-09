----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: MicroProgV2
-- 
-- Dependencies: 
-- 
-- revision: 0.2
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MicroProgV2 is
    Port ( OPCODE       : in std_ulogic_vector(7 downto 0);
           S            : out std_ulogic_vector (3 downto 0);  
           IMUX, OMUX   : out std_ulogic;
           ACCUEN       : out std_ulogic;
           WE, OE       : out std_ulogic;
           PE           : out std_ulogic);
end entity MicroProgV2;

architecture MicroProgV2Behavior of MicroProgV2 is

begin

     OPDEC: process (OPCODE)
     begin

         case OPCODE is
             when x"00"  => S <= "0000"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- out   
             when x"02"  => S <= "0010"; IMUX <= '0'; OMUX <= '-'; ACCUEN <= '-'; WE <= '-'; OE <= '0'; PE <= '0'; -- lda 
             when x"03"  => S <= "0011"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- add
             when x"04"  => S <= "0100"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- inc
             when x"05"  => S <= "0101"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- sub   
             when x"06"  => S <= "0110"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- dec
             when x"07"  => S <= "0111"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- mul  
             when x"08"  => S <= "1000"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- div
             when x"13"  => S <= "0011"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- addr
             when x"15"  => S <= "0101"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- subr
             when x"17"  => S <= "0111"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- mulr
             when x"18"  => S <= "1000"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- divr
			 
             when x"41"  => S <= "0000"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; WE <= '1'; OE <= '0'; PE <= '0'; -- star
             when x"42"  => S <= "0000"; IMUX <= '1'; OMUX <= '1'; ACCUEN <= '1'; WE <= '1'; OE <= '0'; PE <= '0'; -- stbr 
             when x"44"  => S <= "0000"; IMUX <= '-'; OMUX <= '0'; ACCUEN <= '0'; WE <= '0'; OE <= '1'; PE <= '0'; -- ldra
             when x"80"  => S <= "0001"; IMUX <= '-'; OMUX <= '0'; ACCUEN <= '0'; WE <= '0'; OE <= '0'; PE <= '1'; -- in
			 
             when x"89"  => S <= "1001"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- nota
             when x"8A"  => S <= "1010"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- notb
             when x"8B"  => S <= "1011"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- and
             when x"8C"  => S <= "1100"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- or
             when x"8D"  => S <= "1101"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- xor
             when x"8E"  => S <= "1110"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- shl
             when x"8F"  => S <= "1111"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1'; WE <= '-'; OE <= '0'; PE <= '0'; -- shr
             when others => S <= "----"; IMUX <= '-'; OMUX <= '-'; ACCUEN <= '0'; WE <= '-'; OE <= '0'; PE <= '0'; -- not assigned
         end case;
     end process;

end architecture MicroProgV2Behavior;
