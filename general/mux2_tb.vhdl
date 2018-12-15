library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_tb is
end entity;

architecture testbench of mux2_tb is
  component mux2
    generic (N: integer);
    port (
      i_d0 : in std_logic_vector(N-1 downto 0);
      i_d1 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic;
      o_y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  constant N : integer := 32;
  signal s_d0 : std_logic_vector(N-1 downto 0);
  signal s_d1 : std_logic_vector(N-1 downto 0);
  signal s_s : std_logic;
  signal s_y : std_logic_vector(N-1 downto 0);

begin
  uut : mux2 generic map (N => N)
    port map (
    i_d0 => s_d0,
    i_d1 => s_d1,
    i_s => s_s,
    o_y => s_y
  );

  stim_proc: process
  begin
    s_d0 <= X"00000001"; s_d1 <= X"00000010";
    wait for 20 ns;
    s_s <= '0'; wait for 10 ns; assert s_y <= X"00000001";
    s_s <= 'U'; wait for 10 ns; assert s_y <= X"00000001";
    s_s <= '-'; wait for 10 ns; assert s_y <= X"00000001";
    s_s <= '1'; wait for 10 ns; assert s_y <= X"00000010";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
