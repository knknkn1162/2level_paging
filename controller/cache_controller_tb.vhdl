library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.cache_pkg.ALL;

entity cache_controller_tb is
end entity;

architecture testbench of cache_controller_tb is
  component cache_controller
    port (
      i_load : in std_logic;
      i_cache_valid : in std_logic;
      i_addr_tag, i_cache_tag : in cache_tag_vector;
      i_addr_index : in cache_index_vector;
      i_addr_offset : in cache_offset_vector;
      o_cache_miss_en : out std_logic;
      o_rd_s : out cache_offset_vector
    );
  end component;

  signal s_load : std_logic;
  signal s_cache_valid : std_logic;
  signal s_addr_tag, s_cache_tag : cache_tag_vector;
  signal s_addr_index : cache_index_vector;
  signal s_addr_offset : cache_offset_vector;
  signal s_cache_miss_en : std_logic;
  signal s_rd_s : cache_offset_vector;
  constant PERIOD : time := 10 ns;

begin
  uut : cache_controller port map (
    i_load => s_load,
    i_cache_valid => s_cache_valid,
    i_addr_tag => s_addr_tag, i_cache_tag => s_cache_tag,
    i_addr_index => s_addr_index, i_addr_offset => s_addr_offset,
    o_cache_miss_en => s_cache_miss_en,
    o_rd_s => s_rd_s
  );

  stim_proc : process
  begin
    wait for PERIOD;
    s_load <= '1'; wait for 1 ns;
    s_addr_index <= "0000001";
    wait for PERIOD/2;
    -- when initialization, cache_miss_en disable
    s_addr_tag <= X"00000"; s_cache_tag <= X"00001"; s_cache_valid <= '1';
    wait for 1 ns;
    assert s_cache_miss_en = '0';
    wait for PERIOD/2; s_load <= '0';
    wait for 1 ns;

    -- if addr_tag = cache_tag
    s_addr_tag <= X"00000"; s_cache_tag <= X"00000";
    s_addr_offset <= "010";
    wait for 1 ns;
    assert s_cache_miss_en = '0'; assert s_rd_s = "010";
    wait for PERIOD/2; wait for 1 ns;

    -- if addr_tag /= cache_tag & cache_valid = '1' -> cache_miss
    s_addr_tag <= X"00000"; s_cache_tag <= X"00001"; s_cache_valid <= '1';
    wait for 1 ns;
    assert s_cache_miss_en = '1';
    wait for PERIOD/2; wait for 1 ns;

    -- if addr_tag /= cache_tag & cache_valid = '0' -> cache_miss
    s_addr_tag <= X"00001"; s_cache_tag <= X"00000"; s_cache_valid <= '0';
    wait for 1 ns;
    assert s_cache_miss_en = '1';

    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
