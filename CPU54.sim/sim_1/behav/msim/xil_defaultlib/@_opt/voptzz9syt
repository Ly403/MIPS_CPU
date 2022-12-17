library verilog;
use verilog.vl_types.all;
entity CTRL is
    port(
        rst             : in     vl_logic;
        id_stall        : in     vl_logic;
        ex_stall        : in     vl_logic;
        excepttype      : in     vl_logic_vector(31 downto 0);
        cp0_epc         : in     vl_logic_vector(31 downto 0);
        stallreq_from_if: in     vl_logic;
        stallreq_from_mem: in     vl_logic;
        new_pc          : out    vl_logic_vector(31 downto 0);
        flush           : out    vl_logic;
        stall           : out    vl_logic_vector(5 downto 0)
    );
end CTRL;
