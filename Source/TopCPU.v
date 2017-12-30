`ifndef _RESICV_MIN_SOPC
`define _RESICV_MIN_SOPC
`timescale 1ns/1ps


`include "Defines.vh"
`include "IDInstDef.vh"

module TopCPU(
	input wire EXclk,
	input wire button,
	output wire Tx,
	input wire Rx
);

// ================== rst & clk =========================

reg rst;
reg rst_delay;

wire clk;
clk_wiz_0 clk0(EXclk, clk);

always @(posedge clk or posedge button)
begin
	if (button)
	begin
		rst			<=	1'b1;
		rst_delay	<=	1'b1;
	end
	else 
	begin
		rst_delay	<=	1'b0;
		rst			<=	rst_delay;
	end
end

// ================== uart =============================
wire 		UART_send_flag;
wire [7:0]	UART_send_data;
wire 		UART_recv_flag;
wire [7:0]	UART_recv_data;
wire		UART_sendable;
wire		UART_receivable;
uart_comm #(.BAUDRATE(5000000/*115200*/), .CLOCKRATE(66667000)) UART(
		clk, rst,
		UART_send_flag, UART_send_data,
		UART_recv_flag, UART_recv_data,
		UART_sendable, UART_receivable,
		Tx, Rx);

localparam CHANNEL_BIT = 1;
localparam MESSAGE_BIT = 72;
localparam CHANNEL = 1 << CHANNEL_BIT;


wire 					COMM_read_flag[CHANNEL-1:0];
wire [MESSAGE_BIT-1:0]	COMM_read_data[CHANNEL-1:0];
wire [4:0]				COMM_read_length[CHANNEL-1:0];
wire 					COMM_write_flag[CHANNEL-1:0];
wire [MESSAGE_BIT-1:0]	COMM_write_data[CHANNEL-1:0];
wire [4:0]				COMM_write_length[CHANNEL-1:0];
wire					COMM_readable[CHANNEL-1:0];
wire					COMM_writable[CHANNEL-1:0];


multchan_comm #(.MESSAGE_BIT(MESSAGE_BIT), .CHANNEL_BIT(CHANNEL_BIT)) COMM(
	clk, rst,
	UART_send_flag, UART_send_data,
	UART_recv_flag, UART_recv_data,
	UART_sendable, UART_receivable,
	{COMM_read_flag[1], COMM_read_flag[0]},
	{COMM_read_length[1], COMM_read_data[1], COMM_read_length[0], COMM_read_data[0]},
	{COMM_write_flag[1], COMM_write_flag[0]},
	{COMM_write_length[1], COMM_write_data[1], COMM_write_length[0], COMM_write_data[0]},
	{COMM_readable[1], COMM_readable[0]},
	{COMM_writable[1], COMM_writable[0]});


// ================== memory controller ========================

wire [2*2-1:0]	mem_rw_flag;
wire [2*32-1:0]	mem_addr;
wire [2*32-1:0]	mem_read_data;
wire [2*32-1:0]	mem_write_data;
wire [2*4-1:0]	mem_write_mask;
wire [1:0]		mem_busy;
wire [1:0]		mem_done;

memory_controller MEM_CTRL(
		clk, rst,
		COMM_write_flag[0], COMM_write_data[0], COMM_write_length[0],
		COMM_read_flag[0], COMM_read_data[0], COMM_read_length[0],
		COMM_writable[0], COMM_readable[0],
		mem_rw_flag, mem_addr,
		mem_read_data, mem_write_data, mem_write_mask,
		mem_busy, mem_done);

// ================== cpu =======================================


cpu cpu0(
	.clk(clk),
	.rst(rst),

	.mem_rw_flag_o(mem_rw_flag),
	.mem_addr_o(mem_addr),
	.mem_r_data_i(mem_r_data),
	.mem_w_data_o(mem_w_data),
	.mem_w_mask_o(mem_w_mask),
	.mem_busy_i(mem_busy),
	.mem_done_i(mem_done)
);



endmodule

`endif