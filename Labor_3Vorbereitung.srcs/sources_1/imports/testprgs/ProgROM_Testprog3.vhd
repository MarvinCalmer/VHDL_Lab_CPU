----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: ProgROM_Testprog3
-- 
-- Dependencies: 
-- 
-- Revision: 0.2
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProgROM_Testprog3 is
    Port ( ADDRESS : in  std_ulogic_vector (7 downto 0);
           OPCODE, OPERAND : out std_ulogic_vector (7 downto 0));
end entity ProgROM_Testprog3;

architecture ProgROMBehavior of ProgROM_Testprog3 is

begin

    ROM : process (ADDRESS)
    begin
        case ADDRESS is
            when x"00" => OPCODE <= x"02"; OPERAND <= x"00"; -- lda 0
            when x"01" => OPCODE <= x"41"; OPERAND <= x"00"; -- star 0
            when x"02" => OPCODE <= x"41"; OPERAND <= x"01"; -- star 1
            when x"03" => OPCODE <= x"80"; OPERAND <= x"00"; -- in
            when x"04" => OPCODE <= x"41"; OPERAND <= x"02"; -- star 2
            when x"05" => OPCODE <= x"05"; OPERAND <= x"14"; -- sub 14
            when x"06" => OPCODE <= x"25"; OPERAND <= x"0A"; -- jns A
            when x"07" => OPCODE <= x"02"; OPERAND <= x"01"; -- lda 1
            when x"08" => OPCODE <= x"41"; OPERAND <= x"00"; -- star 0
            when x"09" => OPCODE <= x"20"; OPERAND <= x"10"; -- jmp 10
            when x"0A" => OPCODE <= x"44"; OPERAND <= x"02"; -- ldra 2
            when x"0B" => OPCODE <= x"05"; OPERAND <= x"28"; -- sub 28
            when x"0C" => OPCODE <= x"24"; OPERAND <= x"10"; -- js 10
            when x"0D" => OPCODE <= x"22"; OPERAND <= x"10"; -- jz 10
            when x"0E" => OPCODE <= x"02"; OPERAND <= x"01"; -- lda 1
            when x"0F" => OPCODE <= x"41"; OPERAND <= x"01"; -- star 1
            when x"10" => OPCODE <= x"44"; OPERAND <= x"00"; -- ldra 0
            when x"11" => OPCODE <= x"22"; OPERAND <= x"15"; -- jz 15
            when x"12" => OPCODE <= x"02"; OPERAND <= x"F0"; -- lda F0
            when x"13" => OPCODE <= x"00"; OPERAND <= x"00"; -- out
            when x"14" => OPCODE <= x"20"; OPERAND <= x"1C"; -- jmp 1C
            when x"15" => OPCODE <= x"44"; OPERAND <= x"01"; -- ldra 1
            when x"16" => OPCODE <= x"22"; OPERAND <= x"1A"; -- jz 1A
            when x"17" => OPCODE <= x"02"; OPERAND <= x"0F"; -- lda F 
            when x"18" => OPCODE <= x"00"; OPERAND <= x"00"; -- out
            when x"19" => OPCODE <= x"20"; OPERAND <= x"1C"; -- jmp 1C
            when x"1A" => OPCODE <= x"02"; OPERAND <= x"00"; -- lda 0 
            when x"1B" => OPCODE <= x"00"; OPERAND <= x"00"; -- out
            when x"1C" => OPCODE <= x"20"; OPERAND <= x"00"; -- jmp 00
            when others => OPCODE <= (others => '-'); OPERAND <= (others => '-');  -- unused ROM
        end case;
    end process;

end architecture ProgROMBehavior;
