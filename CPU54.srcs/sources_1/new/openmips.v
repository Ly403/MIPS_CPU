`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/27 21:54:41
// Design Name: 
// Module Name: openmips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "D:/desktop/MIPS_CPU/CPU54.srcs/sources_1/new/defines.v"
//顶层模块
module openmips(
    input rst,
    input clk,
    //input [`__regfile__data__bus__]rom_data_i,

    input [5:0] int,

    //output wire[`__regfile__data__bus__] rom_addr_o,
    //output wire rom_ce_o,
    
    //input [`__regfile__data__bus__] i_ram_data,
    
    //output wire [`__regfile__data__bus__] o_ram_addr,
    //output wire [`__regfile__data__bus__] o_ram_data,
    //output wire o_ram_we,
    //output wire [3:0] o_ram_sel,
    //output wire o_ram_ce,
    
    input     [`__regfile__data__bus__] iwishbone_data_i,
    input                               iwishbone_ack_i,
    output wire[`__regfile__data__bus__]iwishbone_addr_o,
    output wire[`__regfile__data__bus__]iwishbone_data_o,
    output wire                         iwishbone_we_o,
    output wire[3:0]                    iwishbone_sel_o,
    output wire                         iwishbone_stb_o,
    output wire                         iwishbone_cyc_o,
    
    input     [`__regfile__data__bus__] dwishbone_data_i,
    input                               dwishbone_ack_i,
    output wire[`__regfile__data__bus__]dwishbone_addr_o,
    output wire[`__regfile__data__bus__]dwishbone_data_o,
    output wire                         dwishbone_we_o,
    output wire[3:0]                    dwishbone_sel_o,
    output wire                         dwishbone_stb_o,
    output wire                         dwishbone_cyc_o,
    
    output wire timer_int
    );


    //连接IF_ID模块与ID模块的线
    wire [`__inst__address__bus__] pc;
    wire [`__inst__data__bus__] inst;
    wire [`__inst__address__bus__] _id_pc;
    wire [`__inst__data__bus__] _id_inst;

	wire rom_ce_o;

	wire[31:0] o_ram_addr;
	wire o_ram_we;
    wire[3:0] o_ram_sel;
	wire[`__regfile__data__bus__] o_ram_data;
	wire o_ram_ce;
    wire[`__regfile__data__bus__] i_ram_data;

    //连接ID和ID_EX
    wire [`ALUOP] id_aluop_;
    wire [`ALUSEL] id_alusel_;
    wire [`__regfile__data__bus__] id_rega_;
    wire [`__regfile__data__bus__] id_regb_;
    wire id_wreg_;
    wire [`__regfile__address__bus__] id_wd_;

    wire id_is_in_delay_slot_;
    wire [`__regfile__data__bus__] id_link_addr_;
    wire [`__regfile__data__bus__] id_inst_;
    wire [31:0] id_excepttype_;
    wire [`__regfile__data__bus__] id_current_inst_addr_;


    //连接ID_EX模块和执行模块EX
    wire [`ALUOP] _ex_aluop;
    wire [`ALUSEL] _ex_alusel;
    wire [`__regfile__data__bus__] _ex_rega;
    wire [`__regfile__data__bus__] _ex_regb;
    wire _ex_wreg;
    wire [`__regfile__address__bus__] _ex_wd;


    wire _ex_is_in_delay_slot;
    wire [`__regfile__data__bus__] _ex_link_addr;
    wire [`__regfile__data__bus__] _ex_inst;
    wire [31:0] _ex_excepttype;
    wire [`__regfile__data__bus__] _ex_current_inst_addr;

    //wire [`__regfile__data__bus__]_ex_hi;
    //wire [`__regfile__data__bus__]_ex_lo;
    
    //连接EX模块和EX_MEM模块
    wire ex_wreg_;
    wire [`__regfile__address__bus__] ex_wd_;
    wire [`__regfile__data__bus__] ex_wdata_;

    
    wire [`__regfile__data__bus__]ex_hi_;
    wire [`__regfile__data__bus__]ex_lo_;
    wire ex_w_hilo_;

    wire [`ALUOP] ex_aluop_;
    wire [`__regfile__data__bus__] ex_mem_addr_;
    //wire [`__regfile__data__bus__] ex_rega_;
    wire [`__regfile__data__bus__] ex_regb_;
    wire ex_cp0_reg_we_;
    wire [4:0]ex_cp0_reg_waddr_;
    wire [`__regfile__data__bus__] ex_cp0_reg_data_;

	wire[31:0] ex_excepttype_;
	wire[`__regfile__data__bus__] ex_current_inst_addr_;
	wire ex_is_in_delayslot_;

    //连接EX_MEM模块和MEM模块
    wire _mem_wreg;
    wire [`__regfile__address__bus__]_mem_wd;
    wire [`__regfile__data__bus__]_mem_wdata;
    wire [`__regfile__data__bus__] _mem_hi;
    wire [`__regfile__data__bus__] _mem_lo;
    wire _mem_w_hilo;
       
    wire [`ALUOP] _mem_aluop;
    wire [`__regfile__data__bus__] _mem_mem_addr;
    //wire [`__regfile__data__bus__] _mem_rega;
    wire [`__regfile__data__bus__] _mem_regb;
    
    wire _mem_cp0_reg_we;
    wire [4:0]_mem_cp0_reg_waddr;
    wire [`__regfile__data__bus__] _mem_cp0_reg_data;

    wire[31:0] _mem_excepttype;	
	wire _mem_is_in_delayslot;
	wire[`__regfile__data__bus__] _mem_current_inst_addr;	

    //连接MEM模块和MEM_WB模块
    wire mem_wreg_;
    wire [`__regfile__address__bus__] mem_wd_;
    wire [`__regfile__data__bus__] mem_wdata_;

    wire [`__regfile__data__bus__] mem_hi_;
    wire [`__regfile__data__bus__] mem_lo_;
    wire mem_w_hilo_;

    wire mem_LLbit_value_o;
	wire mem_LLbit_we_o;
    //wire mem_LLbit_value_;
	//wire mem_LLbit_we_;

    wire mem_cp0_reg_we_;
    wire [4:0]mem_cp0_reg_waddr_;
    wire [`__regfile__data__bus__] mem_cp0_reg_data_;

    wire[31:0] mem_excepttype_;
	wire mem_is_in_delayslot_;
	wire[`__regfile__data__bus__] mem_current_inst_addr_;		
    //连接MEM_WB模块和回写阶段
    
    wire _wb_wreg;
    wire [`__regfile__address__bus__]_wb_wd;
    wire [`__regfile__data__bus__]_wb_wdata;
    wire [`__regfile__data__bus__]_wb_hi;
    wire [`__regfile__data__bus__]_wb_lo;
    wire _wb_w_hilo;

	wire wb_LLbit_value_i;
	wire wb_LLbit_we_i;	
    //wire wb_LLbit_value_i;
	//wire wb_LLbit_we_i;	

    wire _wb_cp0_reg_we;
    wire [4:0]_wb_cp0_reg_waddr;
    wire [`__regfile__data__bus__] _wb_cp0_reg_data;
	wire[31:0] _wb_excepttype;
	wire _wb_is_in_delayslot;
	wire[`__regfile__data__bus__] _wb_current_inst_addr;

    //连接ID模块和Regfile
    wire reg_reada;
    wire reg_readb;
    wire [`__regfile__data__bus__]reg_dataa;
    wire [`__regfile__data__bus__]reg_datab;
    wire [`__regfile__address__bus__]reg_addra;
    wire [`__regfile__address__bus__]reg_addrb;

    //连接执行阶段和HI LO模块
    wire [`__regfile__data__bus__] hi;
    wire [`__regfile__data__bus__] lo;
    
    //连接执行阶段和ex_reg模块，用于乘累加、乘累减等指令
    wire[`__regfile__twice__data__bus__] o_hilo;
	wire[1:0] o_cnt;
	
	wire[`__regfile__twice__data__bus__] i_hilo;
	wire[1:0] i_cnt;

    wire [`__regfile__twice__data__bus__]div_result;
    wire div_ready;
    wire [`__regfile__data__bus__] div_opdata1;
    wire [`__regfile__data__bus__] div_opdata2;
    wire div_start;
    wire div_annul;
    wire signed_div;

    wire _is_in_dalay_slot;
    wire is_in_dalay_slot_;
    wire next_inst_in_delay_slot_;
    wire id_branch_flag_;
    wire [`__regfile__data__bus__] branch_address;

    wire [5:0]stall;
    wire stall_req_from_id;
    wire stall_req_from_ex;
    wire stallreq_from_if;
    wire stallreq_from_mem;
    
    wire LLbit_o;
    //wire LLbit_o;

    
    wire[`__regfile__data__bus__] o_cp0_data;
    wire[4:0] i_cp0_raddr;
  
    wire flush;
    wire[`__regfile__data__bus__] new_pc;

	wire[`__regfile__data__bus__]   cp0_count;
	wire[`__regfile__data__bus__]   cp0_compare;
	wire[`__regfile__data__bus__]	cp0_status;
	wire[`__regfile__data__bus__]	cp0_cause;
	wire[`__regfile__data__bus__]	cp0_epc;
	wire[`__regfile__data__bus__]	cp0_config;
	wire[`__regfile__data__bus__]	cp0_prid; 

    wire[`__regfile__data__bus__] latest_epc;
    //开始例化模块
    PC pc0(
        .clk(clk),
        .rst(rst),
        .branch_address(branch_address),
        .branch_flag(id_branch_flag_),
        .stall(stall),
        .flush(flush),
        .new_pc(new_pc),
        .pc(pc),
        .cs(rom_ce_o)
    );

    //指令寄存器的输入地址就是pc地址
    //assign rom_addr_o = pc;

    IF_ID if_id0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .if_pc(pc),
        .if_inst(inst),
        .id_pc(_id_pc),
        .id_inst(_id_inst)
    );

    ID id0(
        .is_pipeline(1'b1),
        .is_delayslot(1'b0),
        .rst(rst),
        .pc(_id_pc),
        .inst(_id_inst),

        //处于执行阶段的指令要写入的目的寄存器信息
        .ex_wreg(ex_wreg_),
        .ex_wdata(ex_wdata_),
        .ex_wd(ex_wd_),
        .ex_aluop(ex_aluop_),

        //处于访存阶段的指令要写入的目的寄存器信息
        .mem_wreg(mem_wreg_),
        .mem_wd(mem_wd_),
        .mem_wdata(mem_wdata_),

        //送到regfile的信息
        .reg_dataa(reg_dataa),
        .reg_datab(reg_datab),
        .reg_addra(reg_addra),
        .reg_addrb(reg_addrb),
        .reg_reada(reg_reada),
        .reg_readb(reg_readb),

        //送到ID/EX模块的信息
        .alu_op(id_aluop_),
        .alu_sel(id_alusel_),
        .rega(id_rega_),
        .regb(id_regb_),
        .wd(id_wd_),
        .wreg(id_wreg_),

        .o_inst(id_inst_),
        
        .is_in_dalay_slot(_is_in_dalay_slot),
        .next_inst_in_delay_slot(next_inst_in_delay_slot_),
        .branch_address(branch_address),
        .branch_flag(id_branch_flag_),
        .link_addr(id_link_addr_),
        .o_is_in_dalay_slot(id_is_in_delay_slot_),

        .stall_req(stall_req_from_id),
        .excepttype(id_excepttype_),
        .current_inst_addr(id_current_inst_addr_)
    );
    
    regfile cpu_ref(
        .clk(clk),
        .rst(rst),
        .write(_wb_wreg),
        .write_addr(_wb_wd),
        .write_data(_wb_wdata),
        .dataa(reg_dataa),
        .datab(reg_datab),
        .addra(reg_addra),
        .addrb(reg_addrb),
        .ra(reg_reada),
        .rb(reg_readb)
    );
    
    ID_EX id_ex0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        //ID
        .id_alusel(id_alusel_),
        .id_aluop(id_aluop_),
        .id_rega(id_rega_),
        .id_regb(id_regb_),
        .id_wd(id_wd_),
        .id_wreg(id_wreg_),
        .id_link_addr(id_link_addr_),
        .id_is_in_delay_slot(id_is_in_delay_slot_),
        .next_inst_in_delay_slot(next_inst_in_delay_slot_),
        .id_inst(id_inst_),
        .id_current_inst_addr(id_current_inst_addr_),
        .id_excepttype(id_excepttype_),
        //EX
        .ex_alusel(_ex_alusel),
        .ex_aluop(_ex_aluop),
        .ex_rega(_ex_rega),
        .ex_regb(_ex_regb),
        .ex_wd(_ex_wd),
        .ex_wreg(_ex_wreg),
        .ex_link_addr(_ex_link_addr),
        .ex_in_delay_slot(_ex_is_in_delay_slot),
        .ex_inst(_ex_inst),
        .o_is_in_dalay_slot(_is_in_dalay_slot),
        .ex_excepttype(_ex_excepttype),
        .ex_current_inst_addr(_ex_current_inst_addr)
    );


    EX EX0(
        .rst(rst),

        //送到执行阶段EX模块的信息
        .aluop(_ex_aluop),
        .alusel(_ex_alusel),
        .rega(_ex_rega),
        .regb(_ex_regb),
        .wd(_ex_wd),
        .wreg(_ex_wreg),
        .o_wd(ex_wd_),
        .o_wdata(ex_wdata_),
        .o_wreg(ex_wreg_),
        
        ._hi(hi),
        ._lo(lo),
        .inst(_ex_inst),
        
        .i_wb_hi(_wb_hi),
        .i_wb_lo(_wb_lo),
        .i_wb_w_hilo(_wb_w_hilo),

        .i_mem_hi(mem_hi_),
        .i_mem_lo(mem_lo_),
        .i_mem_w_hilo(mem_w_hilo_),

        .i_hilo(i_hilo),
        .i_cnt(i_cnt),

        .hi(ex_hi_),
        .lo(ex_lo_),
        .w_hilo(ex_w_hilo_),

        .o_hilo(o_hilo),
        .o_cnt(o_cnt),

        .div_result(div_result),
        .div_ready(div_ready),
        .div_opdata1(div_opdata1),
        .div_opdata2(div_opdata2),
        .div_start(div_start),
        .signed_div(signed_div),

        .link_addr(_ex_link_addr),
        .is_in_dalay_slot(_ex_is_in_delay_slot),

        .o_aluop(ex_aluop_),
        .o_mem_addr(ex_mem_addr_),
        .o_regb(ex_regb_),
        .stall_req(stall_req_from_ex),

        .mem_cp0_reg_data(mem_cp0_reg_data_),
        .mem_cp0_reg_we(mem_cp0_reg_we_),
        .mem_cp0_reg_waddr(mem_cp0_reg_waddr_),

        .wb_cp0_reg_data(_wb_cp0_reg_data),
        .wb_cp0_reg_waddr(_wb_cp0_reg_waddr),
        .wb_cp0_reg_we(_wb_cp0_reg_we),

        .cp0_reg_data(o_cp0_data),
        .cp0_reg_read_addr(i_cp0_raddr),

        .cp0_reg_we(ex_cp0_reg_we_),
        .cp0_reg_waddr(ex_cp0_reg_waddr_),
        .o_cp0_reg_data(ex_cp0_reg_data_),
    
        .excepttype(_ex_excepttype),
        .current_inst_addr(_ex_current_inst_addr),

        .o_excepttype(ex_excepttype_),
        .o_current_inst_addr(ex_current_inst_addr_),
        .o_is_in_dalay_slot(ex_is_in_delayslot_)
    );

    EX_MEM EX_MEM0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        
        //EX
        .ex_wd(ex_wd_),
        .ex_wreg(ex_wreg_),
        .ex_wdata(ex_wdata_),
        .ex_hi(ex_hi_),
        .ex_lo(ex_lo_),
        .ex_w_hilo(ex_w_hilo_),
        .ex_aluop(ex_aluop_),
        .ex_mem_addr(ex_mem_addr_),
        .ex_regb(ex_regb_),

		.ex_cp0_reg_we(ex_cp0_reg_we_),
		.ex_cp0_reg_waddr(ex_cp0_reg_waddr_),
		.ex_cp0_reg_data(ex_cp0_reg_data_),	

        .ex_current_inst_addr(ex_current_inst_addr_),
        .ex_excepttype(ex_excepttype_),
        .ex_in_delay_slot(ex_is_in_delayslot_),

        .i_hilo(o_hilo),
        .i_cnt(o_cnt),
        //MEM
        .mem_wd(_mem_wd),
        .mem_wreg(_mem_wreg),
        .mem_wdata(_mem_wdata),

        .mem_hi(_mem_hi),
        .mem_lo(_mem_lo),
        .mem_w_hilo(_mem_w_hilo),
        
        .mem_aluop(_mem_aluop),
        .mem_mem_addr(_mem_mem_addr),
        .mem_regb(_mem_regb),

	
		.mem_cp0_reg_we(_mem_cp0_reg_we),
		.mem_cp0_reg_waddr(_mem_cp0_reg_waddr),
		.mem_cp0_reg_data(_mem_cp0_reg_data),

        .mem_current_inst_addr(_mem_current_inst_addr),
        .mem_excepttype(_mem_excepttype),
        .mem_is_in_delay_slot(_mem_is_in_delayslot),

        .o_hilo(i_hilo),
        .o_cnt(i_cnt)
    );

    MEM MEM0(
        .rst(rst),
        .wd(_mem_wd),
        .wreg(_mem_wreg),
        .wdata(_mem_wdata),
        
        .i_hi(_mem_hi),
        .i_lo(_mem_lo),
        .i_w_hilo(_mem_w_hilo),

        .i_aluop(_mem_aluop),
        .i_mem_addr(_mem_mem_addr),
        .i_regb(_mem_regb),
        .i_mem_data(i_ram_data),

        .excepttype(_mem_excepttype),
        .current_inst_addr(_mem_current_inst_addr),
        .is_in_dalay_slot(_mem_is_in_delayslot),

        .o_wd(mem_wd_),
        .o_wreg(mem_wreg_),
        .o_wdata(mem_wdata_),

        .cp0_status(cp0_status),
        .cp0_cause(cp0_cause),
        .cp0_epc(cp0_epc),

		.LLbit_i(LLbit_o),
		.wb_LLbit_we_i(wb_LLbit_we_i),
		.wb_LLbit_value_i(wb_LLbit_value_i),

        .wb_cp0_reg_data(_wb_cp0_reg_data),
        .wb_cp0_reg_we(_wb_cp0_reg_we),
        .wb_cp0_reg_waddr(_wb_cp0_reg_waddr),

		.cp0_reg_we(_mem_cp0_reg_we),
		.cp0_reg_waddr(_mem_cp0_reg_waddr),
		.cp0_reg_data(_mem_cp0_reg_data),

        .o_cp0_reg_we(mem_cp0_reg_we_),
		.o_cp0_reg_waddr(mem_cp0_reg_waddr_),
		.o_cp0_reg_data(mem_cp0_reg_data_),	

        //hi lo信息送回EX，防止数据相关
        .o_hi(mem_hi_),
        .o_lo(mem_lo_),
        .o_w_hilo(mem_w_hilo_),

        .o_mem_addr(o_ram_addr),
        .o_mem_ce(o_ram_ce),
        .o_mem_we(o_ram_we),
        .o_mem_data(o_ram_data),
        .o_mem_sel(o_ram_sel),
        
        .o_cp0_epc(latest_epc),
        .o_excepttype(mem_excepttype_),
        .o_current_inst_addr(mem_current_inst_addr_),
        .o_is_in_dalay_slot(mem_is_in_delayslot_),
        
        
        .LLbit_we_o(mem_LLbit_we_o),
        .LLbit_value_o(mem_LLbit_value_o)
    ); 

    MEM_WB MEM_WB0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        //MEM模块
        .mem_wd(mem_wd_),
        .mem_wreg(mem_wreg_),
        .mem_wdata(mem_wdata_),
        .mem_hi(mem_hi_),
        .mem_lo(mem_lo_),
        .mem_w_hilo(mem_w_hilo_),

        .mem_cp0_reg_we(mem_cp0_reg_we_),
		.mem_cp0_reg_waddr(mem_cp0_reg_waddr_),
		.mem_cp0_reg_data(mem_cp0_reg_data_),		
        
        
        .mem_LLbit_we(mem_LLbit_we_o),
        .mem_LLbit_value(mem_LLbit_value_o),    
        //WB回写
        .wb_wd(_wb_wd),
        .wb_wreg(_wb_wreg),
        .wb_wdata(_wb_wdata),
        //hi lo信息送回EX，防止数据相关
        .wb_hi(_wb_hi),
        .wb_lo(_wb_lo),
        .wb_w_hilo(_wb_w_hilo),

        .wb_cp0_reg_we(_wb_cp0_reg_we),
		.wb_cp0_reg_waddr(_wb_cp0_reg_waddr),
		.wb_cp0_reg_data(_wb_cp0_reg_data),
		
		.wb_LLbit_we(wb_LLbit_we_i),
        .wb_LLbit_value(wb_LLbit_value_i)
    );

    HILO HILO0(
        .clk(clk),
        .rst(rst),

        //写端口
        .we(_wb_w_hilo),
        .i_hi(_wb_hi),
        .i_lo(_wb_lo),

        //读端口
        .o_hi(hi),
        .o_lo(lo)
    );

    CTRL CTRL0(
        .rst(rst),

        .id_stall(stall_req_from_id),
        .ex_stall(stall_req_from_ex),

        .stall(stall),
        .flush(flush),
        .new_pc(new_pc),
        .cp0_epc(latest_epc),
        .excepttype(mem_excepttype_),

		.stallreq_from_if(stallreq_from_if),
		.stallreq_from_mem(stallreq_from_mem)
    );

    DIV DIV0(
		.clk(clk),
		.rst(rst),
	
		.signed_div(signed_div),
		.opdata1(div_opdata1),
		.opdata2(div_opdata2),
		.start(div_start),
		.annul(1'b0),
	
		.result(div_result),
		.ready(div_ready)
	);

	LLbit LLbit0(
		.clk(clk),
		.rst(rst),
	    .flush(flush),
		.LLbit_i(wb_LLbit_value_i),
		.we(wb_LLbit_we_i),
		.LLbit_o(LLbit_o)
	);

    CP0 CP0_0(
		.clk(clk),
		.rst(rst),
		
		.we(_wb_cp0_reg_we),
		.waddr(_wb_cp0_reg_waddr),
		.raddr(i_cp0_raddr),
		.data(_wb_cp0_reg_data),
		
		.excepttype(mem_excepttype_),
		.int(int),
		.current_inst_addr(mem_current_inst_addr_),
		.is_in_delay_slot(mem_is_in_delayslot_),
		
		.o_data(o_cp0_data),
		
		.o_count(cp0_count),
		.o_compare(cp0_compare),
		.o_status(cp0_status),
		.o_cause(cp0_cause),
		.o_epc(cp0_epc),
		.o_config(cp0_config),
		.o_prid(cp0_prid),
		
		.o_timer_int(timer_int)  			
	);
	
	wishbone_bus_if dwishbone_bus_if(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),

        .cpu_ce(o_ram_ce),
        .cpu_data(o_ram_data),
        .cpu_addr(o_ram_addr),
        .cpu_we(o_ram_we),
        .cpu_sel(o_ram_sel),
        .o_cpu_data(i_ram_data),

        .wishbone_data(dwishbone_data_i),
        .wishbone_ack(dwishbone_ack_i),
        .o_wishbone_addr(dwishbone_addr_o),
        .o_wishbone_data(dwishbone_data_o),
        .o_wishbone_we(dwishbone_we_o),
        .o_wishbone_sel(dwishbone_sel_o),
        .o_wishbone_stb(dwishbone_stb_o),
        .o_wishbone_cyc(dwishbone_cyc_o),

        .stallreq(stallreq_from_mem)	       
    );

    wishbone_bus_if iwishbone_bus_if(
        .clk(clk),
        .rst(rst),
        
        .stall(stall),
        .flush(flush),
        
        .cpu_ce(rom_ce_o),
        .cpu_data(32'h00000000),
        .cpu_addr(pc),
        .cpu_we(1'b0),
        .cpu_sel(4'b1111),
        .o_cpu_data(inst),

        .wishbone_data(iwishbone_data_i),
        .wishbone_ack(iwishbone_ack_i),
        .o_wishbone_addr(iwishbone_addr_o),
        .o_wishbone_data(iwishbone_data_o),
        .o_wishbone_we(iwishbone_we_o),
        .o_wishbone_sel(iwishbone_sel_o),
        .o_wishbone_stb(iwishbone_stb_o),
        .o_wishbone_cyc(iwishbone_cyc_o),

        .stallreq(stallreq_from_if)         
    );

endmodule
