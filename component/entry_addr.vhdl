library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.type_pkg.ALL;

entity entry_addr is
  port (
    i_start : in std_logic_vector(31 downto 0);
    i_index : in page_index_vector;
    o_addr : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of entry_addr is
  signal s_offset : page_offset_vector;
begin
  s_offset <= i_index & "00";
  o_addr <= std_logic_vector(unsigned(s_offset) + unsigned(i_start));
end architecture;
