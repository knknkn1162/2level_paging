library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package type_pkg is
  subtype page_index_vector is std_logic_vector(9 downto 0);
  subtype page_vector is std_logic_vector(19 downto 0);
  subtype page_offset_vector is std_logic_vector(11 downto 0);
end package;
