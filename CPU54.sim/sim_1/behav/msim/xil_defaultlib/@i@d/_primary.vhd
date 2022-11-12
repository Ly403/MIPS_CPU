library verilog;
use verilog.vl_types.all;
entity ID is
    port(
        rst             : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        inst            : in     vl_logic_vector(31 downto 0);
        is_pipeline     : in     vl_logic;
        reg_dataa       : in     vl_logic_vector(31 downto 0);
        reg_datab       : in     vl_logic_vector(31 downto 0);
        ex_wreg         : in     vl_logic;
        ex_wdata        : in     vl_logic_vector(31 downto 0);
        ex_wd           : in     vl_logic_vector(4 downto 0);
        ex_aluop        : in     vl_logic_vector(7 downto 0);
        mem_wreg        : in     vl_logic;
        mem_wdata       : in     vl_logic_vector(31 downto 0);
        mem_wd          : in     vl_logic_vector(4 downto 0);
        is_in_dalay_slot: in     vl_logic;
        reg_reada       : out    vl_logic;
        reg_readb       : out    vl_logic;
        reg_addra       : out    vl_logic_vector(4 downto 0);
        reg_addrb       : out    vl_logic_vector(4 downto 0);
        alu_op          : out    vl_logic_vector(7 downto 0);
        alu_sel         : out    vl_logic_vector(2 downto 0);
        rega            : out    vl_logic_vector(31 downto 0);
        regb            : out    vl_logic_vector(31 downto 0);
        wd              : out    vl_logic_vector(4 downto 0);
        wreg            : out    vl_logic;
        stall_req       : out    vl_logic;
        next_inst_in_delay_slot: out    vl_logic;
        branch_flag     : out    vl_logic;
        branch_address  : out    vl_logic_vector(31 downto 0);
        link_addr       : out    vl_logic_vector(31 downto 0);
        o_is_in_dalay_slot: out    vl_logic;
        o_inst          : out    vl_logic_vector(31 downto 0);
        excepttype      : out    vl_logic_vector(31 downto 0);
        current_inst_addr: out    vl_logic_vector(31 downto 0)
    );
end ID;
