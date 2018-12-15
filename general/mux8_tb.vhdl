library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8_tb is
end entity;

architecture testbench of mux8_tb is
  component mux8
    generic(N : integer);
    port (
      i_d000 : in std_logic_vector(N-1 downto 0);
      i_d001 : in std_logic_vector(N-1 downto 0);
      i_d010 : in std_logic_vector(N-1 downto 0);
      i_d011 : in std_logic_vector(N-1 downto 0);
      i_d100 : in std_logic_vector(N-1 downto 0);
      i_d101 : in std_logic_vector(N-1 downto 0);
      i_d110 : in std_logic_vector(N-1 downto 0);
      i_d111 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic_vector(2 downto 0);
      o_y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal N : natural := 8;
  signal s_d000 : std_logic_vector(N-1 downto 0);
  signal s_d001 : std_logic_vector(N-1 downto 0);
  signal s_d010 : std_logic_vector(N-1 downto 0);
  signal s_d011 : std_logic_vector(N-1 downto 0);
  signal s_d100 : std_logic_vector(N-1 downto 0);
  signal s_d101 : std_logic_vector(N-1 downto 0);
  signal s_d110 : std_logic_vector(N-1 downto 0);
  signal s_d111 : std_logic_vector(N-1 downto 0);
  signal s_s : std_logic_vector(2 downto 0);
  signal s_y : std_logic_vector(N-1 downto 0);

begin
  uut : mux8 generic map (N=>N)
  port map (
    i_d000 => s_d000,
    i_d001 => s_d001,
    i_d010 => s_d010,
    i_d011 => s_d011,
    i_d100 => s_d100,
    i_d101 => s_d101,
    i_d110 => s_d110,
    i_d111 => s_d111,
    i_s => s_s,
    o_y => s_y
  );

  stim_proce : process
  begin
    wait for 20 ns;
    s_d000 <= X"01"; s_s <= "000"; wait for 10 ns; assert s_y = X"01";
    s_s <= "XXX"; wait for 10 ns; assert s_y = "XXXXXXXX";
    s_d001 <= X"02"; s_s <= "001"; wait for 10 ns; assert s_y = X"02";
    s_d010 <= X"03"; s_s <= "010"; wait for 10 ns; assert s_y = X"03";
    s_d011 <= X"04"; s_s <= "011"; wait for 10 ns; assert s_y = X"04";
    s_d100 <= X"05"; s_s <= "100"; wait for 10 ns; assert s_y = X"05";
    s_d101 <= X"06"; s_s <= "101"; wait for 10 ns; assert s_y = X"06";
    s_d110 <= X"07"; s_s <= "110"; wait for 10 ns; assert s_y = X"07";
    s_d111 <= X"08"; s_s <= "111"; wait for 10 ns; assert s_y = X"08";

    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
