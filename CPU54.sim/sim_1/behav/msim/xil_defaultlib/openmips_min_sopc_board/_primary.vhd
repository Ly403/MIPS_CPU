library verilog;
use verilog.vl_types.all;
entity openmips_min_sopc_board is
    port(
        clk_in          : in     vl_logic;
        rst             : in     vl_logic;
        choice          : in     vl_logic_vector(5 downto 0);
        stall           : in     vl_logic;
        o_sel           : out    vl_logic_vector(7 downto 0);
        o_seg           : out    vl_logic_vector(7 downto 0)
    );
end openmips_min_sopc_board;
