library verilog;
use verilog.vl_types.all;
entity openmips is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        stallreq_from_if: in     vl_logic;
        rom_data_i      : in     vl_logic_vector(31 downto 0);
        int             : in     vl_logic_vector(5 downto 0);
        rom_addr_o      : out    vl_logic_vector(31 downto 0);
        rom_ce_o        : out    vl_logic;
        dwishbone_data_i: in     vl_logic_vector(31 downto 0);
        dwishbone_ack_i : in     vl_logic;
        dwishbone_addr_o: out    vl_logic_vector(31 downto 0);
        dwishbone_data_o: out    vl_logic_vector(31 downto 0);
        dwishbone_we_o  : out    vl_logic;
        dwishbone_sel_o : out    vl_logic_vector(3 downto 0);
        dwishbone_stb_o : out    vl_logic;
        dwishbone_cyc_o : out    vl_logic;
        timer_int       : out    vl_logic
    );
end openmips;
