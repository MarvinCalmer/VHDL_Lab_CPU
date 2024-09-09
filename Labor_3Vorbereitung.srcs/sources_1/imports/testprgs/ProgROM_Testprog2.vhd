----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: ProgROM_Testprog2
-- 
-- Dependencies: 
-- 
-- Revision: 0.2
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProgROM_Testprog2 is
    Port ( ADDRESS : in  std_ulogic_vector (7 downto 0);
           OPCODE, OPERAND : out std_ulogic_vector (7 downto 0));
end entity ProgROM_Testprog2;

architecture ProgROMBehavior of ProgROM_Testprog2 is

begin

    ROM : process (ADDRESS)
    begin
        case ADDRESS is
		    when x"00" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in
            when x"01" => 
                OPCODE <= x"41"; OPERAND <= x"00";  -- star 0
            when x"02" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in
            when x"03" => 
                OPCODE <= x"41"; OPERAND <= x"01";  -- star 1
            when x"04" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in 
            when x"05" => 
                OPCODE <= x"41"; OPERAND <= x"02";  -- star 2
            when x"06" => 
                OPCODE <= x"44"; OPERAND <= x"00";  -- ldra 0
            when x"07" => 
                OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8
            when x"08" => 
                OPCODE <= x"44"; OPERAND <= x"01";  -- ldra 1
            when x"09" => 
                OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"0A" => 
                OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8
            when x"0B" => 
                OPCODE <= x"44"; OPERAND <= x"02";  -- ldra 2
            when x"0C" => 
                OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"0D" => 
                OPCODE <= x"8F"; OPERAND <= x"01";  -- shr 1
            when x"0E" => 
                OPCODE <= x"41"; OPERAND <= x"03";  -- star 3
            when x"0F" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in   
            when x"10" => 
                OPCODE <= x"41"; OPERAND <= x"00";  -- star 0
            when x"11" => 
                OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8
            when x"12" => 
                OPCODE <= x"44"; OPERAND <= x"00";  -- ldra 0
            when x"13" => 
                OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"14" => 
                OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8
            when x"15" => 
                OPCODE <= x"44"; OPERAND <= x"00";  -- ldra 0
            when x"16" => 
                OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"17" => 
                OPCODE <= x"41"; OPERAND <= x"04";  -- star 4
            when x"18" => 
                OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8 
            when x"19" => 
                OPCODE <= x"44"; OPERAND <= x"03";  -- ldra 3
            when x"1A" => 
                OPCODE <= x"15"; OPERAND <= x"00";  -- subr
            when x"1B" => 
                OPCODE <= x"00"; OPERAND <= x"00";  -- out
            when x"1C" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in
            when x"1D" => 
                OPCODE <= x"41"; OPERAND <= x"00";  -- star 0
            when x"1E" => 
                OPCODE <= x"80"; OPERAND <= x"00";  -- in
            when x"1F" => 
                OPCODE <= x"41"; OPERAND <= x"02";  -- star 2
				
			when x"20" => OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8 
            when x"21" => OPCODE <= x"44"; OPERAND <= x"00";  -- ldra 0
            when x"22" => OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"23" => OPCODE <= x"8E"; OPERAND <= x"08";  -- shl 8 
            when x"24" => OPCODE <= x"44"; OPERAND <= x"00";  -- ldra 0
            when x"25" => OPCODE <= x"17"; OPERAND <= x"00";  -- mulr
            when x"26" => OPCODE <= x"08"; OPERAND <= x"03";  -- div 3
            when x"27" => OPCODE <= x"41"; OPERAND <= x"05";  -- star 5
            when x"28" => OPCODE <= x"00"; OPERAND <= x"00";  -- out	
				
       
            when others => OPCODE <= (others => '-'); OPERAND <= (others => '-');  -- unused ROM
        end case;
    end process;

end architecture ProgROMBehavior;
