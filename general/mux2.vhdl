library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
  generic(N : integer);
  port (
    i_d0 : in std_logic_vector(N-1 downto 0);
    i_d1 : in std_logic_vector(N-1 downto 0);
    i_s : in std_logic;
    o_y : out std_logic_vector(N-1 downto 0)
       );
end entity;


architecture behavior of mux2 is
begin
  -- The conditional signal assignment sets y to d1 if s is 1. Other- wise it sets y to d0.
  o_y <= i_d1 when i_s = '1' else i_d0;
end architecture;
