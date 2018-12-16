library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cache_pkg.ALL;

entity data_cache is
  port (
    clk, i_rst, i_load : in std_logic;
    i_we : in std_logic;
    -- program counter is 4-byte aligned
    i_a : in std_logic_vector(31 downto 0);
    i_wd : in std_logic_vector(31 downto 0);
    i_tag_s : in std_logic;
    o_rd : out std_logic_vector(31 downto 0);
    i_wd1, i_wd2, i_wd3, i_wd4, i_wd5, i_wd6, i_wd7, i_wd8 : in std_logic_vector(31 downto 0);
    o_rd_tag_index : out cache_tag_index_vector;
    o_rd1, o_rd2, o_rd3, o_rd4, o_rd5, o_rd6, o_rd7, o_rd8 : out std_logic_vector(31 downto 0);
    -- push cache miss to the memory
    o_cache_miss_en : out std_logic;
    o_valid_flag : out std_logic;
    o_dirty_flag : out std_logic;
    -- pull load from the memory
    i_load_en : in std_logic
  );
end entity;

architecture behavior of data_cache is
  component cache_decoder
    port (
      i_addr : in std_logic_vector(31 downto 0);
      o_tag : out cache_tag_vector;
      o_index : out cache_index_vector;
      o_offset : out cache_offset_vector
    );
  end component;

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

  component mux2
    generic(N : integer);
    port (
      i_d0 : in std_logic_vector(N-1 downto 0);
      i_d1 : in std_logic_vector(N-1 downto 0);
      i_s : in std_logic;
      o_y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  -- component cache_controller
  --   port (
  --     load : in std_logic;
  --     cache_valid : in std_logic;
  --     addr_tag, cache_tag : in cache_tag_vector;
  --     addr_index : in cache_index_vector;
  --     addr_offset : in cache_offset_vector;
  --     cache_miss_en : out std_logic;
  --     rd_s : out cache_offset_vector
  --   );
  -- end component;

  -- The size of data cache assumes to be 1K-byte
  constant SIZE : natural := 256; -- 0x0100
  constant DATA_BLOCK_SIZE : natural := 2**CONST_CACHE_OFFSET_SIZE;

  -- decode addr
  signal s_addr_tag : cache_tag_vector;
  signal s_addr_index : cache_index_vector;
  signal s_addr_offset : cache_offset_vector;

  -- TODO: compatible with CONST_CACHE_OFFSET_SIZE
  signal s_ram1_datum : std_logic_vector(31 downto 0);
  signal s_ram2_datum : std_logic_vector(31 downto 0);
  signal s_ram3_datum : std_logic_vector(31 downto 0);
  signal s_ram4_datum : std_logic_vector(31 downto 0);
  signal s_ram5_datum : std_logic_vector(31 downto 0);
  signal s_ram6_datum : std_logic_vector(31 downto 0);
  signal s_ram7_datum : std_logic_vector(31 downto 0);
  signal s_ram8_datum : std_logic_vector(31 downto 0);
  signal s_valid_datum, s_dirty_datum: std_logic;
  signal s_tag_datum : cache_tag_vector;

  -- is cache miss occurs or not
  signal s_rd_s : cache_offset_vector; -- selector for mux8
  signal s_rd_tag : cache_tag_vector;

begin
  cache_decoder0 : cache_decoder port map(
    i_addr => i_a,
    o_tag => s_addr_tag,
    o_index => s_addr_index,
    o_offset => s_addr_offset
  );

  -- read & write data or load block from memory
  process(clk, i_rst, i_we, s_addr_tag, s_valid_datum, s_addr_index, s_addr_offset, i_wd1, i_wd2, i_wd3, i_wd4, i_wd5, i_wd6, i_wd7, i_wd8, i_wd)
    variable v_idx : natural;
    variable v_valid_data : valid_array_type(0 to SIZE-1);
    variable v_tag_data : tag_array_type(0 to SIZE-1);
    variable v_dirty_data : dirty_array_type(0 to SIZE-1);

    -- TODO: compatible with CONST_CACHE_OFFSET_SIZE
    variable v_ram1_data : ram_type(0 to SIZE-1);
    variable v_ram2_data : ram_type(0 to SIZE-1);
    variable v_ram3_data : ram_type(0 to SIZE-1);
    variable v_ram4_data : ram_type(0 to SIZE-1);
    variable v_ram5_data : ram_type(0 to SIZE-1);
    variable v_ram6_data : ram_type(0 to SIZE-1);
    variable v_ram7_data : ram_type(0 to SIZE-1);
    variable v_ram8_data : ram_type(0 to SIZE-1);
  begin
    -- initialization
    if i_rst = '1' then
      -- initialize with zeros
      v_valid_data := (others => '0');
    -- writeback
    elsif rising_edge(clk) then
      -- pull the notification from the memory
      if i_load_en = '1' then
        v_idx := to_integer(unsigned(s_addr_index));
        -- when the ram_data is initial state
        v_valid_data(v_idx) := '1';
        v_dirty_data(v_idx) := '0';
        v_tag_data(v_idx) := s_addr_tag;
        v_ram1_data(v_idx) := i_wd1;
        v_ram2_data(v_idx) := i_wd2;
        v_ram3_data(v_idx) := i_wd3;
        v_ram4_data(v_idx) := i_wd4;
        v_ram5_data(v_idx) := i_wd5;
        v_ram6_data(v_idx) := i_wd6;
        v_ram7_data(v_idx) := i_wd7;
        v_ram8_data(v_idx) := i_wd8;
      elsif i_we = '1' then
        if s_valid_datum = '1' then
          -- cache hit!
          if s_tag_datum = s_addr_tag then
            v_dirty_data(v_idx) := '1';
            v_idx := to_integer(unsigned(s_addr_index));
            case s_addr_offset is
              when "000" =>
                v_ram1_data(v_idx) := i_wd;
              when "001" =>
                v_ram2_data(v_idx) := i_wd;
              when "010" =>
                v_ram3_data(v_idx) := i_wd;
              when "011" =>
                v_ram4_data(v_idx) := i_wd;
              when "100" =>
                v_ram5_data(v_idx) := i_wd;
              when "101" =>
                v_ram6_data(v_idx) := i_wd;
              when "110" =>
                v_ram7_data(v_idx) := i_wd;
              when "111" =>
                v_ram8_data(v_idx) := i_wd;
              when others =>
                -- do nothing
            end case;
          end if;
        end if;
      end if;
    end if;

    -- read
    if not is_X(s_addr_index) then
      s_ram1_datum <= v_ram1_data(to_integer(unsigned(s_addr_index)));
      s_ram2_datum <= v_ram2_data(to_integer(unsigned(s_addr_index)));
      s_ram3_datum <= v_ram3_data(to_integer(unsigned(s_addr_index)));
      s_ram4_datum <= v_ram4_data(to_integer(unsigned(s_addr_index)));
      s_ram5_datum <= v_ram5_data(to_integer(unsigned(s_addr_index)));
      s_ram6_datum <= v_ram6_data(to_integer(unsigned(s_addr_index)));
      s_ram7_datum <= v_ram7_data(to_integer(unsigned(s_addr_index)));
      s_ram8_datum <= v_ram8_data(to_integer(unsigned(s_addr_index)));
      s_dirty_datum <= v_dirty_data(to_integer(unsigned(s_addr_index)));
      s_valid_datum <= v_valid_data(to_integer(unsigned(s_addr_index)));
      s_tag_datum <= v_tag_data(to_integer(unsigned(s_addr_index)));
    end if;
  end process;

  o_valid_flag <= s_valid_datum;
  o_dirty_flag <= s_dirty_datum;

  -- cache_controller0 : cache_controller port map (
  --   load => load,
  --   cache_valid => valid_datum,
  --   addr_tag => addr_tag, cache_tag => tag_datum,
  --   addr_index => addr_index, addr_offset => addr_offset,
  --   cache_miss_en => cache_miss_en,
  --   rd_s => rd_s
  -- );

  -- if cache_hit
  mux8_0 : mux8 generic map(N=>32)
  port map (
    i_d000 => s_ram1_datum,
    i_d001 => s_ram2_datum,
    i_d010 => s_ram3_datum,
    i_d011 => s_ram4_datum,
    i_d100 => s_ram5_datum,
    i_d101 => s_ram6_datum,
    i_d110 => s_ram7_datum,
    i_d111 => s_ram8_datum,
    i_s => s_rd_s,
    o_y => o_rd
  );

  -- out rd_tag, rd_index,rd0*
  mux2_tag : mux2 generic map(N=>CONST_CACHE_TAG_SIZE)
  port map (
    i_d0 => s_tag_datum,
    i_d1 => s_addr_tag,
    i_s => i_tag_s,
    o_y => s_rd_tag
  );
  o_rd_tag_index <= s_rd_tag & s_addr_index;

  o_rd1 <= s_ram1_datum;
  o_rd2 <= s_ram2_datum;
  o_rd3 <= s_ram3_datum;
  o_rd4 <= s_ram4_datum;
  o_rd5 <= s_ram5_datum;
  o_rd6 <= s_ram6_datum;
  o_rd7 <= s_ram7_datum;
  o_rd8 <= s_ram8_datum;
end architecture;
