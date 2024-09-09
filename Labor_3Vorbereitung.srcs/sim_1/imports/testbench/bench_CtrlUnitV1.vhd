library ieee;
  use ieee.std_logic_1164.all;  -- logic elements
  use ieee.numeric_std.all;     -- unsigned type
  use ieee.math_real.all;       -- real calculations

library std;
  use std.env.all;              -- flow control

entity bench_ctrlunitv1 is
end entity bench_ctrlunitv1;

architecture behav of bench_ctrlunitv1 is
  --
  -- DUT interface
  --
  signal CLK                    : std_ulogic  := '0';
  signal RSTN                   : std_ulogic;
  signal OPCODE                 : std_ulogic_vector (7 downto 0);
  signal STATEIND               : std_ulogic_vector (1 downto 0);
  signal IPCLK                  : std_ulogic;
  signal IRCLK                  : std_ulogic;
  signal ACCLK                  : std_ulogic;
  signal OUTCLK                 : std_ulogic;

begin

  DUT: entity work.ctrlunitv1
    port map(
      CLK                       => CLK,
      RSTN                      => RSTN,
      OPCODE                    => OPCODE,
      STATEIND                  => STATEIND,
      IPCLK                     => IPCLK,
      IRCLK                     => IRCLK,
      ACCLK                     => ACCLK,
      OUTCLK                    => OUTCLK
    );

  generate_clock: CLK   <= not CLK after 10 ns;
  deassert_reset: RSTN  <= '0', '1' after 33 ns;

  stimuli_process: process
    -- --------------------------------------------------------------------------------------------
    procedure check_regular_state_transition
    -- {{{
    is
    begin
      assert (OPCODE /= (OPCODE'range => '0')) report "FEHLER [Regulaerer Ablauf] Setzen sie den Operationscode auf ungleich 0" severity FAILURE;
      assert (STATEIND = "00") report "FEHLER [Regulaerer Ablauf] Initialzustand falsch, erwartet 0, bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '1')    report "FEHLER [Regulaerer Ablauf] IPCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Regulaerer Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Regulaerer Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Regulaerer Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Regulaerer Ablauf] Initialzustand";
      wait until rising_edge( CLK );

      -- after falling edge the state should be stable
      wait until falling_edge( CLK );
      assert (STATEIND = "01") report "FEHLER [Regulaerer Ablauf] Folgezustand falsch, erwartet 1, bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '0')    report "FEHLER [Regulaerer Ablauf] IPCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '1')    report "FEHLER [Regulaerer Ablauf] IRCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Regulaerer Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Regulaerer Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Regulaerer Ablauf] Folgezustand 1";

      wait until falling_edge( CLK );
      assert (STATEIND = "10") report "FEHLER [Regulaerer Ablauf] Folgezustand falsch, erwartet 2 bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '0')    report "FEHLER [Regulaerer Ablauf] IPCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Regulaerer Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '1')    report "FEHLER [Regulaerer Ablauf] ACCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Regulaerer Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Regulaerer Ablauf] Folgezustand 2";

      wait until falling_edge( CLK );
      assert (STATEIND = "00") report "FEHLER [Regulaerer Ablauf] Folgezustand falsch, erwartet 0 bekommen " & integer'image( to_integer(unsigned(STATEIND)));
      assert (IPCLK  = '1')    report "FEHLER [Regulaerer Ablauf] IPCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Regulaerer Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Regulaerer Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Regulaerer Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Regulaerer Ablauf] Folgezustand 0";

    -- }}}                           
    end procedure check_regular_state_transition;

    -- --------------------------------------------------------------------------------------------
    procedure check_output_state_transition
    -- {{{
    is
    begin
      assert (OPCODE = (OPCODE'range => '0')) report "FEHLER [Ausgabe Ablauf] Setzen sie den Operationscode auf gleich 0" severity FAILURE;
      assert (STATEIND = "00") report "FEHLER [Ausgabe Ablauf] Initialzustand falsch, erwartet 0, bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '1')    report "FEHLER [Ausgabe Ablauf] IPCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Ausgabe Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Ausgabe Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Ausgabe Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Ausgabe Ablauf] Initialzustand";
      wait until rising_edge( CLK );

      -- after falling edge the state should be stable
      wait until falling_edge( CLK );
      assert (STATEIND = "01") report "FEHLER [Ausgabe Ablauf] Folgezustand falsch, erwartet 1, bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '0')    report "FEHLER [Ausgabe Ablauf] IPCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '1')    report "FEHLER [Ausgabe Ablauf] IRCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Ausgabe Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Ausgabe Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Ausgabe Ablauf] Folgezustand 1";

      wait until falling_edge( CLK );
      assert (STATEIND = "11") report "FEHLER [Ausgabe Ablauf] Folgezustand falsch, erwartet 3 bekommen " & integer'image( to_integer(unsigned(STATEIND))) severity FAILURE;
      assert (IPCLK  = '0')    report "FEHLER [Ausgabe Ablauf] IPCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Ausgabe Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Ausgabe Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '1')    report "FEHLER [Ausgabe Ablauf] OUTCLK falsch, erwartet 1, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Ausgabe Ablauf] Folgezustand 2";

      wait until falling_edge( CLK );
      assert (STATEIND = "00") report "FEHLER [Ausgabe Ablauf] Folgezustand falsch, erwartet 0 bekommen " & integer'image( to_integer(unsigned(STATEIND)));
      assert (IPCLK  = '1')    report "FEHLER [Ausgabe Ablauf] IPCLK  falsch, erwartet 1, bekommen " & std_ulogic'image( IPCLK  ) severity FAILURE;
      assert (IRCLK  = '0')    report "FEHLER [Ausgabe Ablauf] IRCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( IRCLK  ) severity FAILURE;
      assert (ACCLK  = '0')    report "FEHLER [Ausgabe Ablauf] ACCLK  falsch, erwartet 0, bekommen " & std_ulogic'image( ACCLK  ) severity FAILURE;
      assert (OUTCLK = '0')    report "FEHLER [Ausgabe Ablauf] OUTCLK falsch, erwartet 0, bekommen " & std_ulogic'image( OUTCLK ) severity FAILURE;
                               report "OK [Ausgabe Ablauf] Folgezustand 0";

    -- }}}
    end procedure check_output_state_transition;
      
  begin
    OPCODE <= (others => '1');
    wait until RSTN = '1';
    check_regular_state_transition;

    OPCODE <= (others => '0');
    wait for 0 ns;    -- trigger opcode change
    check_output_state_transition;
    
    stop;
    wait;
  end process stimuli_process;

end architecture behav;
