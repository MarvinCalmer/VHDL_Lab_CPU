----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: MicroProg
-- 
-- Dependencies: 
-- 
-- Revision: 0.2
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MicroProgV1 is
    Port ( OPCODE       : in std_ulogic_vector(7 downto 0);
           S            : out std_ulogic_vector (3 downto 0);  
           IMUX, OMUX   : out std_ulogic;
           ACCUEN       : out std_ulogic);
end entity MicroProgV1;

architecture MicroProgV1Behavior of MicroProgV1 is

begin

     OPDEC: process (OPCODE)
     begin

         case OPCODE is
             when x"00"  => S <= "0000"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1'; -- out   
             when x"02"  => S <= "0010"; IMUX <= '0'; OMUX <= '-'; ACCUEN <= '-'; -- lda 
             -- add
			 when x"03"  => S <= "0011"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- inc
			 when x"04"  => S <= "0100"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- sub 
			 when x"05"  => S <= "0101"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';			 
             -- dec
			 when x"06"  => S <= "0110"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';			
             -- mul  
			 when x"07"  => S <= "0111"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';			 
             -- div
			 when x"08"  => S <= "1000"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';			 
             -- addr
			 when x"13"  => S <= "0011"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1';
             -- subr
			 when x"15"  => S <= "0101"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1';
             -- mulr
			 when x"17"  => S <= "0111"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1';
             -- divr
			 when x"18"  => S <= "1000"; IMUX <= '1'; OMUX <= '0'; ACCUEN <= '1';
             -- nota
			 when x"89"  => S <= "1001"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- notb
			 when x"8A"  => S <= "1010"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- and
			 when x"8B"  => S <= "1011"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- or
			 when x"8C"  => S <= "1100"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- xor
			 when x"8D"  => S <= "1101"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- shl
			 when x"8E"  => S <= "1110"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
             -- shr 
			 when x"8F"  => S <= "1111"; IMUX <= '0'; OMUX <= '0'; ACCUEN <= '1';
			 
             when others => S <= "----"; IMUX <= '-'; OMUX <= '-'; ACCUEN <= '0'; -- not assigned
         end case;
     end process;

end MicroProgV1Behavior;
