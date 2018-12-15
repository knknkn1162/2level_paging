library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8 is
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
end entity;


architecture behavior of mux8 is
begin
  process(i_d000, i_d001, i_d010, i_d011, i_d100, i_d101, i_d110, i_d111, i_s)
  begin
    case i_s is
      when "000" => o_y <= i_d000;
      when "001" => o_y <= i_d001;
      when "010" => o_y <= i_d010;
      when "011" => o_y <= i_d011;
      when "100" => o_y <= i_d100;
      when "101" => o_y <= i_d101;
      when "110" => o_y <= i_d110;
      when "111" => o_y <= i_d111;
      when others => o_y <= (others => 'X');
    end case;
  end process;
end architecture;
