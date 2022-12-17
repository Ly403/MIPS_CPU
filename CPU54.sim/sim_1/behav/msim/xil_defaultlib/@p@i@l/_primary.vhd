library verilog;
use verilog.vl_types.all;
entity PIL is
    port(
        clk_in          : in     vl_logic;
        clk             : out    vl_logic
    );
end PIL;
