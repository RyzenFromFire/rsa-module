library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.numeric_std.all;

entity m_e_mod_c is
  generic (
    data_width : integer := 128 -- W_BLOCK
  );
  port (
    clk   : in    std_logic;
    rstn  : in    std_logic; -- active low
    start : in    std_logic;
    m     : in    std_logic_vector(data_width - 1 downto 0);
    e     : in    std_logic_vector(data_width - 1 downto 0);
    n     : in    std_logic_vector(data_width - 1 downto 0);
    c     : buffer std_logic_vector(data_width - 1 downto 0);
    done  : out   std_logic
  );
end m_e_mod_c;

architecture behavioral of m_e_mod_c is

  component a_b_mod_n is
    generic (
      data_width : integer
    );
    port (
      clk  : in    std_logic;
      rstn : in    std_logic;
      a    : in    std_logic_vector(data_width - 1 downto 0);
      b    : in    std_logic_vector(data_width - 1 downto 0);
      n    : in    std_logic_vector(data_width - 1 downto 0);
      p    : out   std_logic_vector(data_width - 1 downto 0);
      done : out   std_logic
    );
  end component;

  -- Internal counter
  signal i : integer;

  -- Internal state machine
  type lr_adder_state is (S_INIT, S_CC, S_CM, S_DONE);

  signal state : lr_adder_state;

  -- Internal signals for ABmodN
  signal a       : std_logic_vector(data_width - 1 downto 0);
  signal b       : std_logic_vector(data_width - 1 downto 0);
  signal p       : std_logic_vector(data_width - 1 downto 0);
  signal ab_rst  : std_logic;
  signal ab_done : std_logic;

begin process (clk, rstn)
  begin
    if (rstn = '0') then
      state  <= S_INIT;
      ab_rst <= '0'; -- rstn;
      c      <= (others => '0');
      i      <= data_width - 2;
      done   <= '0';
    elsif (clk'event and clk = '1') then
      done <= '0';
      if (state = S_INIT) then
        if (e(data_width - 1) = '1') then
          c <= m;
        else
          c(0) <= '1';
        end if;
        state <= S_CC;
      elsif (state = S_CC) then
        a      <= c;
        b      <= c;
        ab_rst <= '1';
        if (ab_done = '1') then
          c      <= p;
          ab_rst <= '0';
          state  <= S_CM;
        end if;
      elsif (state = S_CM) then
        if (e(i) = '1') then
          a      <= c;
          b      <= m;
          ab_rst <= '1';
          if (ab_done = '1') then
            c      <= p;
            ab_rst <= '0';
            if (i > 0) then
              i     <= i - 1;
              state <= S_CC;
            else
              state <= S_DONE;
            end if;
          end if;
        else
          if (i > 0) then
            i     <= i - 1;
            state <= S_CC;
          else
            state <= S_DONE;
          end if;
        end if;
      elsif (state = S_DONE) then
        done <= '1';
      end if;
    end if;
  end process;

  abmodn : a_b_mod_n
    generic map (
      data_width => data_width
    )
    port map (
      clk  => clk,
      a    => a,
      b    => b,
      n    => n,
      p    => p,
      rstn => ab_rst,
      done => ab_done
    );
end architecture behavioral;
