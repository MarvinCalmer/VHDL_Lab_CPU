library ieee;
  use ieee.std_logic_1164.all;  -- logic elements
  use ieee.numeric_std.all;     -- unsigned type
  use ieee.math_real.all;       -- real calculations

library std;
  use std.env.all;              -- flow control

entity bench_microprogV2 is
end entity bench_microprogV2;

architecture behav of bench_microprogV2 is
  --
  -- DUT interface
  --
  signal OPCODE                 : std_ulogic_vector (7 downto 0);
  signal S                      : std_ulogic_vector (3 downto 0);
  signal IMUX                   : std_ulogic;
  signal OMUX                   : std_ulogic;
  signal ACCUEN                 : std_ulogic;
  signal WE                     : std_ulogic;
  signal OE                     : std_ulogic;

begin

  DUT: entity work.microprogV2(MicroProgV2Behavior)
    port map(
      OPCODE                    => OPCODE,
      S                         => S,
      IMUX                      => IMUX,
      OMUX                      => OMUX,
      ACCUEN                    => ACCUEN,
      WE                        => WE,
      OE                        => OE
    );

  stimuli_process: process
    procedure check_function(
      input_opcode              : in std_ulogic_vector(7 downto 0);
      output_s                  : in std_ulogic_vector(3 downto 0);
      ctrlsigs                  : in std_ulogic_vector(4 downto 0);
      message                   : in string
    )
    is
    begin
      OPCODE <= input_opcode;

      wait for 10 ns;

      assert( S = output_s )                        report "FEHLER Microcode: "      & message severity FAILURE;
                                                    report "OK Microcode: "          & message;

      assert( OE      = ctrlsigs(4) ) report "FEHLER OE Steuersignal: " & message severity FAILURE;
      assert( WE      = ctrlsigs(3) ) report "FEHLER WE Steuersignal: " & message severity FAILURE;
      assert( IMUX    = ctrlsigs(2) ) report "FEHLER IMUX Steuersignal: " & message severity FAILURE;
      assert( OMUX    = ctrlsigs(1) ) report "FEHLER OMUX Steuersignal: " & message severity FAILURE;
      assert( ACCUEN  = ctrlsigs(0) ) report "FEHLER ACCUEN Steuersignal: " & message severity FAILURE;
                                      report "OK Steuersignale: " & message;
    end procedure check_function;
  begin

    check_function(x"00", "0000", "0-101", "Mnemonic out");
    check_function(x"02", "0010", "0-0--", "Mnemonic lda");
    check_function(x"03", "0011", "0-001", "Mnemonic add");
    check_function(x"04", "0100", "0-001", "Mnemonic inc");
    check_function(x"05", "0101", "0-001", "Mnemonic sub");
    check_function(x"06", "0110", "0-001", "Mnemonic dec");
    check_function(x"07", "0111", "0-001", "Mnemonic mul");
    check_function(x"08", "1000", "0-001", "Mnemonic div");

    check_function(x"13", "0011", "0-101", "Mnemonic addr");
    check_function(x"15", "0101", "0-101", "Mnemonic subr");
    check_function(x"17", "0111", "0-101", "Mnemonic mulr");
    check_function(x"18", "1000", "0-101", "Mnemonic divr");

    check_function(x"41", "0000", "01101", "Mnemonic star");
    check_function(x"42", "0000", "01111", "Mnemonic stbr");
    check_function(x"44", "0000", "10-00", "Mnemonic ldra");
    check_function(x"80", "0001", "0--00", "Mnemonic in");

    check_function(x"89", "1001", "0-001", "Mnemonic nota");
    check_function(x"8A", "1010", "0-001", "Mnemonic notb");
    check_function(x"8B", "1011", "0-001", "Mnemonic and");
    check_function(x"8C", "1100", "0-001", "Mnemonic or");
    check_function(x"8D", "1101", "0-001", "Mnemonic xor");
    check_function(x"8E", "1110", "0-001", "Mnemonic shl");
    check_function(x"8F", "1111", "0-001", "Mnemonic shr");
    
    stop;
    wait;
  end process stimuli_process;

end architecture behav;
