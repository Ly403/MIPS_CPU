library verilog;
use verilog.vl_types.all;
entity wishbone_bus_if is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic_vector(5 downto 0);
        flush           : in     vl_logic;
        cpu_ce          : in     vl_logic;
        cpu_data        : in     vl_logic_vector(31 downto 0);
        cpu_addr        : in     vl_logic_vector(31 downto 0);
        cpu_we          : in     vl_logic;
        cpu_sel         : in     vl_logic_vector(3 downto 0);
        o_cpu_data      : out    vl_logic_vector(31 downto 0);
        o_wishbone_addr : out    vl_logic_vector(31 downto 0);
        o_wishbone_data : out    vl_logic_vector(31 downto 0);
        o_wishbone_we   : out    vl_logic;
        o_wishbone_sel  : out    vl_logic_vector(3 downto 0);
        o_wishbone_stb  : out    vl_logic;
        o_wishbone_cyc  : out    vl_logic;
        wishbone_data   : in     vl_logic_vector(31 downto 0);
        wishbone_ack    : in     vl_logic;
        stallreq        : out    vl_logic
    );
end wishbone_bus_if;
