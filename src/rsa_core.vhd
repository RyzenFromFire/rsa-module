library IEEE;
  use IEEE.std_logic_1164.all;

entity rsacore is
  generic (
    G_size : integer := 128
  );
  port (
    clk        : in    std_logic;
    reset      : in    std_logic;
    start      : in    std_logic;
    key_e      : in    std_logic_vector(G_size - 1 downto 0);
    key_n      : in    std_logic_vector(G_size - 1 downto 0);
    plaintext  : in    std_logic_vector(G_size - 1 downto 0);
    ciphertext : out   std_logic_vector(G_size - 1 downto 0);
    done       : out   std_logic
  );
end rsacore;

architecture behavioral of rsacore is

  component m_e_mod_c is
    generic (
      data_width : integer
    );
    port (
      clk   : in    std_logic;
      rstn  : in    std_logic;
      start : in    std_logic;
      m     : in    std_logic_vector(data_width - 1 downto 0);
      e     : in    std_logic_vector(data_width - 1 downto 0);
      n     : in    std_logic_vector(data_width - 1 downto 0);
      c     : buffer std_logic_vector(data_width - 1 downto 0);
      done  : out   std_logic
    );
  end component;

  signal c : std_logic_vector(G_size - 1 downto 0);

begin

  -- finite_state_machine : fsm
  --   generic map (
  --     word_width => w_data,
  --     data_width => G_size
  --   )
  --   port map (
  --     clk           => clk,
  --     reset_n       => reset,
  --     start_rsa     => start,
  --     init_rsa      => initrsa,
  --     core_finished => done,
  --     data_in       => datain,
  --     data_out      => dataout,
  --     rstn_bin_add  => resetn_bin_add,
  --     m_buf         => m,
  --     n_buf         => n,
  --     e_buf         => e,
  --     c_buf         => c,
  --     rsa_finished  => rsa_done
  --   );

  lr_bin_adder : m_e_mod_c
    generic map (
      data_width => G_size
    )
    port map (
      clk   => clk,
      rstn  => reset,
      start => start,
      m     => plaintext,
      n     => key_n,
      e     => key_e,
      c     => c,
      done  => done
    );

  ciphertext <= c;

end architecture behavioral;
