library ieee;
  use ieee.std_logic_1164.all;  -- logic elements
  use ieee.numeric_std.all;     -- unsigned type
  use ieee.math_real.all;       -- real calculations

library std;
  use std.env.all;              -- flow control

entity bench_microprogV1 is
end entity bench_microprogV1;

architecture behav of bench_microprogV1 is
  --
  -- DUT interface
  --
  signal OPCODE                 : std_ulogic_vector (7 downto 0);
  signal S                      : std_ulogic_vector (3 downto 0);
  signal IMUX                   : std_ulogic;
  signal OMUX                   : std_ulogic;
  signal ACCUEN                 : std_ulogic;

begin

  DUT: entity work.microprogV1(MicroProgV1Behavior)
    port map(
      OPCODE                    => OPCODE,
      S                         => S,
      IMUX                      => IMUX,
      OMUX                      => OMUX,
      ACCUEN                    => ACCUEN
    );

  stimuli_process: process
    procedure check_function(
      input_opcode              : in std_ulogic_vector(7 downto 0);
      output_s                  : in std_ulogic_vector(3 downto 0);
      ctrlsigs                  : in std_ulogic_vector(2 downto 0);
      message                   : in string
    )
    is
    begin
      OPCODE <= input_opcode;

      wait for 10 ns;

      assert( S = output_s )                        report "FEHLER Microcode: "      & message severity FAILURE;
                                                    report "OK Microcode: "          & message;
      assert( (IMUX, OMUX, ACCUEN) = ctrlsigs )     report "FEHLER Steuersignale: "  & message severity FAILURE;
                                                         report "OK Steuersignale: " & message;
    end procedure check_function;
  begin

    check_function(x"00", "0000", "101", "Mnemonic out");
    check_function(x"02", "0010", "0--", "Mnemonic lda");
    check_function(x"03", "0011", "001", "Mnemonic add");
    check_function(x"04", "0100", "001", "Mnemonic inc");
    check_function(x"05", "0101", "001", "Mnemonic sub");
    check_function(x"06", "0110", "001", "Mnemonic dec");
    check_function(x"07", "0111", "001", "Mnemonic mul");
    check_function(x"08", "1000", "001", "Mnemonic div");
    check_function(x"89", "1001", "001", "Mnemonic nota");
    check_function(x"8A", "1010", "001", "Mnemonic notb");
    check_function(x"8B", "1011", "001", "Mnemonic and");
    check_function(x"8C", "1100", "001", "Mnemonic or");
    check_function(x"8D", "1101", "001", "Mnemonic xor");
    check_function(x"8E", "1110", "001", "Mnemonic shl");
    check_function(x"8F", "1111", "001", "Mnemonic shr");
    
    stop;
    wait;
  end process stimuli_process;

end architecture behav;
