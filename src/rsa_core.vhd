library IEEE;
  use IEEE.std_logic_1164.all;

entity rsa_core is
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
end rsa_core;

architecture behavioral of rsa_core is

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
