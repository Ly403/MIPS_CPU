library verilog;
use verilog.vl_types.all;
entity PIL is
    port(
        clk             : out    vl_logic;
        clk_in_IBUF_BUFG: in     vl_logic
    );
end PIL;
