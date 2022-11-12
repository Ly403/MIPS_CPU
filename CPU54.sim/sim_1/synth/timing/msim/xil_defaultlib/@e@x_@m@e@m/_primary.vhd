library verilog;
use verilog.vl_types.all;
entity EX_MEM is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        ex_wd           : in     vl_logic_vector(4 downto 0);
        ex_wreg         : in     vl_logic;
        ex_wdata        : in     vl_logic_vector(31 downto 0);
        ex_hi           : in     vl_logic_vector(31 downto 0);
        ex_lo           : in     vl_logic_vector(31 downto 0);
        ex_w_hilo       : in     vl_logic;
        stall           : in     vl_logic_vector(5 downto 0);
        flush           : in     vl_logic;
        i_hilo          : in     vl_logic_vector(63 downto 0);
        i_cnt           : in     vl_logic_vector(1 downto 0);
        ex_aluop        : in     vl_logic_vector(7 downto 0);
        ex_mem_addr     : in     vl_logic_vector(31 downto 0);
        ex_regb         : in     vl_logic_vector(31 downto 0);
        ex_cp0_reg_we   : in     vl_logic;
        ex_cp0_reg_waddr: in     vl_logic_vector(4 downto 0);
        ex_cp0_reg_data : in     vl_logic_vector(31 downto 0);
        ex_excepttype   : in     vl_logic_vector(31 downto 0);
        ex_in_delay_slot: in     vl_logic;
        ex_current_inst_addr: in     vl_logic_vector(31 downto 0);
        mem_wd          : out    vl_logic_vector(4 downto 0);
        mem_wreg        : out    vl_logic;
        mem_wdata       : out    vl_logic_vector(31 downto 0);
        mem_hi          : out    vl_logic_vector(31 downto 0);
        mem_lo          : out    vl_logic_vector(31 downto 0);
        mem_w_hilo      : out    vl_logic;
        o_hilo          : out    vl_logic_vector(63 downto 0);
        o_cnt           : out    vl_logic_vector(1 downto 0);
        mem_aluop       : out    vl_logic_vector(7 downto 0);
        mem_mem_addr    : out    vl_logic_vector(31 downto 0);
        mem_regb        : out    vl_logic_vector(31 downto 0);
        mem_cp0_reg_we  : out    vl_logic;
        mem_cp0_reg_waddr: out    vl_logic_vector(4 downto 0);
        mem_cp0_reg_data: out    vl_logic_vector(31 downto 0);
        mem_excepttype  : out    vl_logic_vector(31 downto 0);
        mem_is_in_delay_slot: out    vl_logic;
        mem_current_inst_addr: out    vl_logic_vector(31 downto 0)
    );
end EX_MEM;
