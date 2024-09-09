----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: ProgROM_Testprog4
-- 
-- Dependencies: 
-- 
-- Revision: 0.1
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProgROM_Testprog4 is
    Port ( ADDRESS : in  std_ulogic_vector (7 downto 0);
           OPCODE, OPERAND : out std_ulogic_vector (7 downto 0));
end entity ProgROM_Testprog4;

architecture ProgROMBehavior of ProgROM_Testprog4 is

begin

    ROM : process (ADDRESS)
    begin
        case ADDRESS is
            when x"00" => OPCODE <= x"02"; OPERAND <= x"80";                       -- LDA 128
            when x"01" => OPCODE <= x"41"; OPERAND <= x"01";                       -- STAR 1
            when x"02" => OPCODE <= x"44"; OPERAND <= x"01";                       -- LDRA 1
            when x"03" => OPCODE <= x"00"; OPERAND <= (others => '-');             -- OUT
            when x"04" => OPCODE <= x"8F"; OPERAND <= x"01";                       -- SHR 1
            when x"05" => OPCODE <= x"41"; OPERAND <= x"01";                       -- STAR 1
            when x"06" => OPCODE <= x"23"; OPERAND <= x"02";                       -- JNZ 2
           
            when x"07" => OPCODE <= x"02"; OPERAND <= x"01";
            when x"08" => OPCODE <= x"41"; OPERAND <= x"01";
            when x"09" => OPCODE <= x"44"; OPERAND <= x"01";
            when x"0A" => OPCODE <= x"00"; OPERAND <= (others=> '-');
            when x"0B" => OPCODE <= x"8E"; OPERAND <= x"01";
            when x"0C" => OPCODE <= x"41"; OPERAND <= x"01";
            when x"0D" => OPCODE <= x"23"; OPERAND <= x"09";
       
            
            
            when x"0E" => OPCODE <= x"20"; OPERAND <= x"00";                       -- JMP 0
            
            when others => OPCODE <= (others => '-'); OPERAND <= (others => '-');  -- unused ROM
        end case;
    end process;

end architecture ProgROMBehavior;
