----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: ProgROM_Testprog1
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProgROM_Testprog1 is
    Port ( ADDRESS : in  std_ulogic_vector (7 downto 0);
           OPCODE, OPERAND : out std_ulogic_vector (7 downto 0));
end entity ProgROM_Testprog1;

architecture ProgROMBehavior of ProgROM_Testprog1 is

begin

    ROM : process (ADDRESS)
    begin
        case ADDRESS is
            when x"00" => OPCODE <= x"02"; OPERAND <= x"03";                       -- lda 3 
            when x"01" => OPCODE <= x"07"; OPERAND <= x"05";  -- mul 5
            when x"02" => OPCODE <= x"07"; OPERAND <= x"08";  -- mul 8
            when x"03" => OPCODE <= x"8F"; OPERAND <= x"01";  -- shr 1
            when x"04" => OPCODE <= x"05"; OPERAND <= x"0C";  -- sub 12 
            when x"05" => OPCODE <= x"00"; OPERAND <= (others => '-');   -- out
            when x"06" => OPCODE <= x"02"; OPERAND <= x"04";  -- lda 4
            when x"07" => OPCODE <= x"07"; OPERAND <= x"04";  -- mul 4 
            when x"08" => OPCODE <= x"07"; OPERAND <= x"06";   -- mul 6
            when x"09" => OPCODE <= x"08"; OPERAND <= x"03";  -- div 3
            when x"0A" => OPCODE <= x"00"; OPERAND <= (others => '-'); -- out
            when others => OPCODE <= (others => '-'); OPERAND <= (others => '-');  -- unused ROM
        end case;
    end process;

end architecture ProgROMBehavior;
