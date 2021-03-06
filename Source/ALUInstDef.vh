`define AluOpBus		5:0
`define AluOutSelBus	2:0

// ============= ALU related =======================
// AluOp

// CAN BE OPTIMIZED TO SHORTER SIZE!!!!!!

`define EX_ADD_OP		5'h1 // Add and sub Overflows are ignored
`define EX_SUB_OP 		5'h2
`define EX_SLT_OP		5'h3
`define EX_SLTU_OP		5'h4 // compares the values as unsigned numbers (i.e., the immediate is rst sign-extended XLEN bits then treated as an unsigned number).
`define EX_XOR_OP		5'h5
`define EX_OR_OP 		5'h6
`define EX_AND_OP		5'h7
`define EX_SLL_OP		5'h8 // Shift value in rs1 by the shift amoount in rs2[4:0]
`define EX_SRL_OP		5'h9
`define EX_SRA_OP		5'ha
`define EX_AUIPC_OP		5'hb

`define EX_JAL_OP 		5'hc
`define EX_JALR_OP		5'hd
`define EX_BEQ_OP 		5'he
`define EX_BNE_OP 		5'hf
`define EX_BLT_OP 		5'h10
`define EX_BGE_OP 		5'h11
`define EX_BLTU_OP		5'h12
`define EX_BGEU_OP		5'h13

`define EX_LB_OP 		5'h14
`define EX_LH_OP 		5'h15
`define EX_LW_OP 		5'h16
`define EX_LBU_OP		5'h17
`define EX_LHU_OP		5'h18

`define EX_SB_OP		5'h19
`define EX_SH_OP		5'h1a
`define EX_SW_OP		5'h1b

`define EX_NOP_OP		5'h0
`define ME_NOP_OP		5'h0

// AluSel
`define EX_RES_LOGIC	3'b001
`define EX_RES_SHIFT	3'b010
`define EX_RES_ARITH	3'b011
`define EX_RES_J_B  	3'b100
`define	EX_RES_LD_ST	3'b101
`define EX_RES_NOP		3'b000