library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.type_pkg.ALL;

entity decode_virtual_addr is
  port (
    i_addr : in std_logic_vector(31 downto 0);
    o_directory : out page_index_vector;
    o_table : out page_index_vector;
    o_offset : out page_offset_vector
  );
end entity;

architecture behavior of decode_virtual_addr is
begin
  o_directory <= i_addr(31 downto 22);
  o_table <= i_addr(21 downto 12);
  o_offset <= i_addr(11 downto 0);
end architecture;
