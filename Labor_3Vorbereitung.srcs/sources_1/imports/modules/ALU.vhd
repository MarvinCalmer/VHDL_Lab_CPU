----------------------------------------------------------------------------------
-- Institution: Esslingen University of Applied Sciences
-- Engineer: G. Schmidt
-- 
-- Design Name: MINIuP
-- Module Name: ALU
-- 
-- Dependencies: 
-- 
-- Revision: 0.2
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( A, B                        : in  std_ulogic_vector (7 downto 0);
           S                           : in  std_ulogic_vector (3 downto 0);
           Y                           : out std_ulogic_vector (15 downto 0);
           ZERO, SIGN, CARRY, OVERFLOW : out std_ulogic);
end entity ALU;

architecture ALUBehavior of ALU is

    signal Asign, Bsign     : signed(7 downto 0);
    signal Ysign            : signed(15 downto 0);
    signal Yshl             : signed(15 downto 0);
    signal Yshr             : signed(7 downto 0);

    signal addoflw, muloflw : std_ulogic;

begin

    Asign <= signed(A);
    Bsign <= signed(B);
    
    SHLL : process (Asign, B)
    begin
     
        case B is
            when x"00" =>  Yshl <= "00000000" & Asign;
            when x"01" =>  Yshl <= "0000000" & Asign & "0";
            when x"02" =>  Yshl <= "000000" & Asign & "00";
            when x"03" =>  Yshl <= "00000" & Asign & "000";
            when x"04" =>  Yshl <= "0000" & Asign & "0000";
            when x"05" =>  Yshl <= "000" & Asign & "00000";
            when x"06" =>  Yshl <= "00" & Asign & "000000";
            when x"07" =>  Yshl <= "0" & Asign & "0000000";
            when x"08" =>  Yshl <=  Asign(7 downto 0) & "00000000";
            when x"09" =>  Yshl <=  Asign(6 downto 0) & "000000000";
            when x"0A" =>  Yshl <=  Asign(5 downto 0) & "0000000000";
            when x"0B" =>  Yshl <=  Asign(4 downto 0) & "00000000000";
            when x"0C" =>  Yshl <=  Asign(3 downto 0) & "000000000000";
            when x"0D" =>  Yshl <=  Asign(2 downto 0) & "0000000000000";
            when x"0E" =>  Yshl <=  Asign(1 downto 0) & "00000000000000";
            when x"0F" =>  Yshl <=  Asign(0)          & "000000000000000";       
            when others => Yshl <= (others => '0'); 
        end case;
        
    end process SHLL;

    SHLR : process (Asign, B)
    begin
     
        Yshr <= (others => '0');    
    
        case B is
            when x"00" =>  Yshr <= Asign;
            when x"01" =>  Yshr <= "0" & Asign(7 downto 1);
            when x"02" =>  Yshr <= "00" & Asign(7 downto 2);
            when x"03" =>  Yshr <= "000" & Asign(7 downto 3);
            when x"04" =>  Yshr <= "0000" & Asign(7 downto 4);
            when x"05" =>  Yshr <= "00000" & Asign(7 downto 5);
            when x"06" =>  Yshr <= "000000" & Asign(7 downto 6);
            when x"07" =>  Yshr <= "0000000" & Asign(7);     
            when others => Yshr <= (others => '0'); 
        end case;
        
    end process SHLR;

    ALC : process (Asign,Bsign,S, Yshl, Yshr)
    begin
    
        Ysign <= (others => '0');
        
        case S is
            when "0000" => Ysign <= (Bsign & Asign);
            when "0001" => Ysign(7 downto 0) <= Asign;
            when "0010" => Ysign(7 downto 0) <= Bsign;
            when "0011" => Ysign(8 downto 0) <= (Asign(7) & Asign) + (Bsign(7) & Bsign);
            when "0100" => Ysign(8 downto 0) <= (Asign(7) & Asign) + 1;
			-- own solution 
			when "0101" => Ysign(8 downto 0) <= (Asign(7) & Asign) - (Bsign(7) & Bsign);
            -- something is missing here
            when "0110" => Ysign(8 downto 0) <= (Asign(7) & Asign) - 1;
            when "0111" => Ysign <= Asign * Bsign;
            when "1000" => Ysign(7 downto 0) <= Asign / Bsign;
            when "1001" => Ysign(7 downto 0) <= not(Asign);
            when "1010" => Ysign(7 downto 0) <= not(Bsign);                        
            when "1011" => Ysign(7 downto 0) <= Asign and Bsign; 
			-- own
			when "1100" => Ysign(7 downto 0) <= Asign or Bsign;
			 when "1101" => Ysign(7 downto 0) <= Asign xor Bsign;
            -- something is missing here
            when "1110" => Ysign <= Yshl;
            when "1111" => Ysign(7 downto 0) <= Yshr;
            when others => Ysign <= (others => '-');
        end case;
    end process;
    
    FLAGS : process(Asign, Bsign, Ysign, S)
    begin
    
        ZERO <= '0';
        SIGN <= '0';
        CARRY <= '0';
        
        if (Ysign(7 downto 0) = x"00") then ZERO <= '1'; end if;
		-- own: set to 1 not to 0
        if (Ysign(7) = '1') then SIGN <= '1'; end if;
		--
        if ((Ysign(15 downto 8) /= x"00") and
            (Ysign(15 downto 8) /= x"FF")) then CARRY <= '1'; end if;
        
        addoflw <= Ysign(7) xor Ysign(8);

        if ((Ysign(7)='0' and Ysign(15 downto 8)=x"00") or
            (Ysign(7)='1' and Ysign(15 downto 8)=x"FF")) then
            muloflw <= '0';
        else
            muloflw <= '1';  
        end if;

    end process;

    OVERFLW : process (S, addoflw, muloflw)
    begin

        case S is
            when "0011" => OVERFLOW <= addoflw;
            when "0100" => OVERFLOW <= addoflw;
            when "0101" => OVERFLOW <= addoflw;
            when "0110" => OVERFLOW <= addoflw;
            when "0111" => OVERFLOW <= muloflw;
            when others => OVERFLOW <= '0';
        end case;

     end process;
        
    
    Y <= std_ulogic_vector(Ysign);

end architecture ALUBEhavior;
