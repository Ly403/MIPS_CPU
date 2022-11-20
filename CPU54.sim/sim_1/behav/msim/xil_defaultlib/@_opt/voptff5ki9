library verilog;
use verilog.vl_types.all;
entity openmips is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        rom_data_i      : in     vl_logic_vector(31 downto 0);
        int             : in     vl_logic_vector(5 downto 0);
        rom_addr_o      : out    vl_logic_vector(31 downto 0);
        rom_ce_o        : out    vl_logic;
        i_ram_data      : in     vl_logic_vector(31 downto 0);
        o_ram_addr      : out    vl_logic_vector(31 downto 0);
        o_ram_data      : out    vl_logic_vector(31 downto 0);
        o_ram_we        : out    vl_logic;
        o_ram_sel       : out    vl_logic_vector(3 downto 0);
        o_ram_ce        : out    vl_logic;
        timer_int       : out    vl_logic
    );
end openmips;
