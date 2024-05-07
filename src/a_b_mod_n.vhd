library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.numeric_std.all;

entity a_b_mod_n is
  generic (
    data_width : integer := 128 -- W_BLOCK
  );
  port (
    clk  : in    std_logic;
    rstn : in    std_logic; -- active low
    a    : in    std_logic_vector(data_width - 1 downto 0);
    b    : in    std_logic_vector(data_width - 1 downto 0);
    n    : in    std_logic_vector(data_width - 1 downto 0);
    p    : out   std_logic_vector(data_width - 1 downto 0);
    done : out   std_logic
  );
end a_b_mod_n;

architecture behavioral of a_b_mod_n is

  -- Internal for temporary storing the computed value
  signal temp : std_logic_vector(data_width + 1 downto 0);

  -- Internal signal for computation
  signal i : integer;

  type calc_state is (S_INIT, S_ADD, S_SUB, S_DONE);

  signal state : calc_state;

begin

  process (clk, rstn) begin
    if (rstn = '0') then
      temp <= (others => '0'); -- reset internal register
      -- p <= (others=>'0'); -- reset
      i     <= 0;              -- reset i
      done  <= '0';
      state <= S_ADD;
    elsif (clk'event and clk = '1') then
      done <= '0';
      if (state = S_ADD) then
        if (a(data_width - 1 - i) = '1') then
          temp <= temp + temp + b;
        else
          temp <= temp + temp;
        end if;
        state <= S_SUB;
      elsif (state = S_SUB) then
        if (temp >= n) then
          temp <= temp - n;
        else
          if (i < data_width - 1) then
            state <= S_ADD;
            i     <= i + 1;
          else
            state <= S_DONE;
          end if;
        end if;
      elsif (state = S_DONE) then
        p    <= temp(data_width - 1 downto 0);
        done <= '1';
      end if;
    end if;
  end process;

end architecture behavioral;
