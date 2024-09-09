library ieee;
  use ieee.std_logic_1164.all;  -- logic elements
  use ieee.numeric_std.all;     -- unsigned type
  use ieee.math_real.all;       -- real calculations

library std;
  use std.env.all;              -- flow control

entity bench_alu is
end entity bench_alu;

architecture behav of bench_alu is
  --
  -- DUT interface
  --
  signal A                      : std_ulogic_vector (7 downto 0);
  signal B                      : std_ulogic_vector (7 downto 0);
  signal S                      : std_ulogic_vector (3 downto 0);
  signal Y                      : std_ulogic_vector (15 downto 0);
  signal ZERO                   : std_ulogic;
  signal SIGN                   : std_ulogic;
  signal CARRY                  : std_ulogic;
  signal OVERFLOW               : std_ulogic;

  alias alu_result_lo           : std_ulogic_vector(7 downto 0) is Y(7 downto 0);
  alias alu_result_hi           : std_ulogic_vector(7 downto 0) is Y(15 downto 8);

begin

  DUT: entity work.alu(alubehavior)
    port map(
      A                         => A,
      B                         => B,
      S                         => S,
      Y                         => Y,
      ZERO                      => ZERO,
      SIGN                      => SIGN,
      CARRY                     => CARRY,
      OVERFLOW                  => OVERFLOW
    );

  stimuli_process: process
    procedure check_function(
      input_a                   : in integer;
      input_b                   : in integer;
      code                      : in std_ulogic_vector(3 downto 0);
      output_lo                 : in integer;
      output_hi                 : in integer;
      flags                     : in std_ulogic_vector(3 downto 0);
      message                   : in string
    )
    is
    begin
      a <= std_ulogic_vector(to_signed(input_a, a'length));
      b <= std_ulogic_vector(to_signed(input_b, b'length));
      s <= code;

      wait for 10 ns;

      assert( to_integer(signed(alu_result_lo)) = output_lo )  report "FEHLER Ergebnis: "  & message severity FAILURE;
                                                               report "OK Ergebnis: "      & message;
      assert( to_integer(signed(alu_result_hi)) = output_hi )  report "FEHLER Ergebnis: "  & message severity FAILURE;
                                                               report "OK Ergebnis: "      & message;

      assert( ZERO     = flags(3) ) report "FEHLER ZERO Flag "      & message severity FAILURE;
      assert( SIGN     = flags(2) ) report "FEHLER SIGN Flag "      & message severity FAILURE;
      assert( CARRY    = flags(1) ) report "FEHLER CARRY Flag "     & message severity FAILURE;
      assert( OVERFLOW = flags(0) ) report "FEHLER OVERFLOW Flag "  & message severity FAILURE;
                                    report "OK Flags: "             & message;
    end procedure check_function;
  begin

    check_function(3, 4,    "0011",   7,  0,  "0000", "Addiere 3 und 4");
    check_function(5, 4,    "0011",   9,  0,  "0000", "Addiere 5 und 4");
    check_function(-5, -3,  "0011",  -8, 1,   "0110", "Addiere -5 und -3");
    check_function(-5, -4,  "0011",  -9, 1,   "0110", "Addiere -5 und -4");
    check_function(5, -3,   "0011",   2,  0,  "0000", "Addiere 5 und -3");
    check_function(3, -5,   "0011",  -2, 1,   "0110", "Addiere 3 und -5");
    check_function(120, 15, "0011", -121, 0,  "0101", "Addiere 120 und 15");
    check_function(4, 5,    "0101",  -1, 1,   "0110", "Subtrahiere 4 und 5");
    check_function(5, 4,    "0101",   1,  0,  "0000", "Subtrahiere 5 und 4");
    check_function(4, -5,   "0101",   9,  0,  "0000", "Subtrahiere 4 und -5");
    check_function(4, -4,   "0101",   8,  0,  "0000", "Subtrahiere 4 und -4");
    check_function(-125, 4, "0101",   127,1,  "0011", "Subtrahiere -125 und 4");
    check_function(5, 13,   "1011",   5,  0,  "0000", "UND 5 und 13");
    check_function(5, 10,   "1011",   0,  0,  "1000", "UND 5 und 10");
    check_function(10, 6,   "1100",  14, 0,   "0000", "ODER 10 und 6");
    check_function(9, 13,   "1101",   4,  0,  "0000", "XOR 9 und 13");
    check_function(2, 12,   "0111",  24,  0,  "0000", "Multipliziere 2 und 12");
    check_function(-2, 12,  "0111", -24,  -1, "0100", "Multipliziere -2 und 12");
    check_function(65, 3,   "0111", -61,  0,  "0101", "Multipliziere -2 und 12");
    check_function(3, 3,    "1110",  24,  0,  "0000", "Schiebe 3 um 3 nach links");
    check_function(-126, 2, "1111",  32,  0,  "0000", "Schiebe -126 um 2 nach rechts");
    
    stop;
    wait;
  end process stimuli_process;

end architecture behav;
