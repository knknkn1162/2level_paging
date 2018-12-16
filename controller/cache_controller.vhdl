library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.cache_pkg.ALL;

entity cache_controller is
  port (
    i_load : in std_logic;
    i_cache_valid : in std_logic;
    i_addr_tag, i_cache_tag : in cache_tag_vector;
    i_addr_index : in cache_index_vector;
    i_addr_offset : in cache_offset_vector;
    o_cache_miss_en : out std_logic;
    o_rd_s : out cache_offset_vector
  );
end entity;

architecture behavior of cache_controller is
begin
  -- cache_hit or cache_miss
  process(i_addr_index, i_addr_tag, i_cache_valid, i_cache_tag, i_load)
  begin
    if i_load = '1' then
      o_cache_miss_en <= '0';
    elsif i_cache_valid = '1' then
      -- cache hit!
      if i_cache_tag = i_addr_tag then
        o_cache_miss_en <= '0';
      else
        -- cache miss
        o_cache_miss_en <= '1';
      end if;
    else
      -- if ram is invalid, cache_miss also occurs
      if not is_X(i_addr_index) then
        o_cache_miss_en <= '1';
      end if;
    end if;
  end process;

  -- direct mux8 selector
  process(i_addr_tag, i_addr_offset, i_cache_valid, i_cache_tag)
  begin
    if i_cache_valid = '1' and i_cache_tag = i_addr_tag then
      o_rd_s <= i_addr_offset;
    else
      o_rd_s <= (others => 'X');
    end if;
  end process;
end architecture;
