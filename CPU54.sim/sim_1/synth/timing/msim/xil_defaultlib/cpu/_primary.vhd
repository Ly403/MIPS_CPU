library verilog;
use verilog.vl_types.all;
entity cpu is
    port(
        clk_in          : in     vl_logic;
        rst             : in     vl_logic;
        o_sel           : out    vl_logic_vector(7 downto 0);
        o_seg           : out    vl_logic_vector(7 downto 0)
    );
end cpu;
