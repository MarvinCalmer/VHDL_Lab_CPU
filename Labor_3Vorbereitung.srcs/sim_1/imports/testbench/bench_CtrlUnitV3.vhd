library ieee;
  use ieee.std_logic_1164.all;  -- logic elements
  use ieee.numeric_std.all;     -- unsigned type
  use ieee.math_real.all;       -- real calculations

library std;
  use std.env.all;              -- flow control

entity bench_ctrlunitv3 is
end entity bench_ctrlunitv3;

architecture behav of bench_ctrlunitv3 is
  --
  -- DUT interface
  --
  signal CLK                    : std_ulogic  := '0';
  signal RSTN                   : std_ulogic;
  signal OPCODE                 : std_ulogic_vector (7 downto 0);
  signal ZERO                   : std_ulogic;
  signal SIGN                   : std_ulogic;
  signal STATEIND               : std_ulogic_vector (1 downto 0);
  signal IPCLK                  : std_ulogic;
  signal IRCLK                  : std_ulogic;
  signal ACCLK                  : std_ulogic;
  signal OUTCLK                 : std_ulogic;
  signal RE                     : std_ulogic;
  signal IPLOADN                : std_ulogic;

begin

  DUT: entity work.ctrlunitv3
    port map(
      CLK                       => CLK,
      RSTN                      => RSTN,
      OPCODE                    => OPCODE,
      ZERO                      => ZERO,
      SIGN                      => SIGN,
      STATEIND                  => STATEIND,
      IPCLK                     => IPCLK,
      IRCLK                     => IRCLK,
      ACCLK                     => ACCLK,
      OUTCLK                    => OUTCLK,
      RE                        => RE,
      IPLOADN                   => IPLOADN
    );

  generate_clock: CLK   <= not CLK after 10 ns;
  deassert_reset: RSTN  <= '0', '1' after 33 ns;

  stimuli_process: process
    procedure check_state_transition(
      statecode               : in std_ulogic_vector(1 downto 0);
      ctrl_signals            : in std_ulogic_vector(5 downto 0))
    is
      variable statecode_i    : integer := to_integer(unsigned(statecode));
    begin
      wait until falling_edge( CLK );
      assert (STATEIND = statecode) report "FEHLER Zustand falsch, erwartet " & integer'image(statecode_i) & ", bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPLOADN= ctrl_signals(5))    report "FEHLER IPLOADN falsch, erwartet " & std_ulogic'image(ctrl_signals(5)) & ", bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IPCLK  = ctrl_signals(4))    report "FEHLER IPCLK  falsch, erwartet " & std_ulogic'image(ctrl_signals(4)) & ", bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = ctrl_signals(3))    report "FEHLER IRCLK  falsch, erwartet " & std_ulogic'image(ctrl_signals(3)) & ", bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = ctrl_signals(2))    report "FEHLER ACCLK  falsch, erwartet " & std_ulogic'image(ctrl_signals(2)) & ", bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = ctrl_signals(1))    report "FEHLER OUTCLK falsch, erwartet " & std_ulogic'image(ctrl_signals(1)) & ", bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
      assert (RE     = ctrl_signals(0))    report "FEHLER RE     falsch, erwartet " & std_ulogic'image(ctrl_signals(0)) & ", bekommen " & std_ulogic'image( RE ) severity FAILURE;
                               report "OK Zustand " & integer'image(to_integer(unsigned(statecode)));
    end procedure check_state_transition;

  begin
    OPCODE <= x"03";
    ZERO   <= '0';
    SIGN   <= '0';
    wait until RSTN = '1';
    check_state_transition( "00", "110000" );
    wait until rising_edge( CLK );

    report "Pruefe add Befehl";
    check_state_transition( "01", "101000" );
    check_state_transition( "10", "100100" );
    check_state_transition( "00", "110000" );

    report "Pruefe jmp Befehl";
    OPCODE <= x"20";
    check_state_transition( "01", "001000" );
    check_state_transition( "10", "000100" );
    check_state_transition( "00", "010000" );

    report "Pruefe jz Befehl, Springbedingung erfuellt";
    OPCODE <= x"22";
    ZERO   <= '1';
    check_state_transition( "01", "001000" );
    check_state_transition( "10", "000100" );
    check_state_transition( "00", "010000" );

    report "Pruefe jz Befehl, Springbedingung nicht erfuellt";
    OPCODE <= x"22";
    ZERO   <= '0';
    check_state_transition( "01", "101000" );
    check_state_transition( "10", "100100" );
    check_state_transition( "00", "110000" );

    report "Pruefe jnz Befehl, Springbedingung erfuellt";
    OPCODE <= x"23";
    ZERO   <= '0';
    check_state_transition( "01", "001000" );
    check_state_transition( "10", "000100" );
    check_state_transition( "00", "010000" );

    report "Pruefe jnz Befehl, Springbedingung nicht erfuellt";
    OPCODE <= x"23";
    ZERO   <= '1';
    check_state_transition( "01", "101000" );
    check_state_transition( "10", "100100" );
    check_state_transition( "00", "110000" );

    report "Pruefe js Befehl, Springbedingung erfuellt";
    OPCODE <= x"24";
    SIGN   <= '1';
    check_state_transition( "01", "001000" );
    check_state_transition( "10", "000100" );
    check_state_transition( "00", "010000" );

    report "Pruefe js Befehl, Springbedingung nicht erfuellt";
    OPCODE <= x"24";
    SIGN   <= '0';
    check_state_transition( "01", "101000" );
    check_state_transition( "10", "100100" );
    check_state_transition( "00", "110000" );

    report "Pruefe jns Befehl, Springbedingung erfuellt";
    OPCODE <= x"25";
    SIGN   <= '0';
    check_state_transition( "01", "001000" );
    check_state_transition( "10", "000100" );
    check_state_transition( "00", "010000" );

    report "Pruefe jns Befehl, Springbedingung nicht erfuellt";
    OPCODE <= x"25";
    SIGN   <= '1';
    check_state_transition( "01", "101000" );
    check_state_transition( "10", "100100" );
    check_state_transition( "00", "110000" );

    stop;
    wait;
  end process stimuli_process;

end architecture behav;
