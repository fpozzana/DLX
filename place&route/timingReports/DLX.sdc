###################################################################

# Created by write_sdc on Wed Oct 16 14:00:33 2019

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
set_max_delay 31.25  -from [list [get_ports clk] [get_ports reset]]  -to [list [get_ports {npc_out_bpu[31]}] [get_ports {npc_out_bpu[30]}]         \
[get_ports {npc_out_bpu[29]}] [get_ports {npc_out_bpu[28]}] [get_ports         \
{npc_out_bpu[27]}] [get_ports {npc_out_bpu[26]}] [get_ports {npc_out_bpu[25]}] \
[get_ports {npc_out_bpu[24]}] [get_ports {npc_out_bpu[23]}] [get_ports         \
{npc_out_bpu[22]}] [get_ports {npc_out_bpu[21]}] [get_ports {npc_out_bpu[20]}] \
[get_ports {npc_out_bpu[19]}] [get_ports {npc_out_bpu[18]}] [get_ports         \
{npc_out_bpu[17]}] [get_ports {npc_out_bpu[16]}] [get_ports {npc_out_bpu[15]}] \
[get_ports {npc_out_bpu[14]}] [get_ports {npc_out_bpu[13]}] [get_ports         \
{npc_out_bpu[12]}] [get_ports {npc_out_bpu[11]}] [get_ports {npc_out_bpu[10]}] \
[get_ports {npc_out_bpu[9]}] [get_ports {npc_out_bpu[8]}] [get_ports           \
{npc_out_bpu[7]}] [get_ports {npc_out_bpu[6]}] [get_ports {npc_out_bpu[5]}]    \
[get_ports {npc_out_bpu[4]}] [get_ports {npc_out_bpu[3]}] [get_ports           \
{npc_out_bpu[2]}] [get_ports {npc_out_bpu[1]}] [get_ports {npc_out_bpu[0]}]    \
[get_ports {npc_out_if[31]}] [get_ports {npc_out_if[30]}] [get_ports           \
{npc_out_if[29]}] [get_ports {npc_out_if[28]}] [get_ports {npc_out_if[27]}]    \
[get_ports {npc_out_if[26]}] [get_ports {npc_out_if[25]}] [get_ports           \
{npc_out_if[24]}] [get_ports {npc_out_if[23]}] [get_ports {npc_out_if[22]}]    \
[get_ports {npc_out_if[21]}] [get_ports {npc_out_if[20]}] [get_ports           \
{npc_out_if[19]}] [get_ports {npc_out_if[18]}] [get_ports {npc_out_if[17]}]    \
[get_ports {npc_out_if[16]}] [get_ports {npc_out_if[15]}] [get_ports           \
{npc_out_if[14]}] [get_ports {npc_out_if[13]}] [get_ports {npc_out_if[12]}]    \
[get_ports {npc_out_if[11]}] [get_ports {npc_out_if[10]}] [get_ports           \
{npc_out_if[9]}] [get_ports {npc_out_if[8]}] [get_ports {npc_out_if[7]}]       \
[get_ports {npc_out_if[6]}] [get_ports {npc_out_if[5]}] [get_ports             \
{npc_out_if[4]}] [get_ports {npc_out_if[3]}] [get_ports {npc_out_if[2]}]       \
[get_ports {npc_out_if[1]}] [get_ports {npc_out_if[0]}] [get_ports             \
{ir_out[31]}] [get_ports {ir_out[30]}] [get_ports {ir_out[29]}] [get_ports     \
{ir_out[28]}] [get_ports {ir_out[27]}] [get_ports {ir_out[26]}] [get_ports     \
{ir_out[25]}] [get_ports {ir_out[24]}] [get_ports {ir_out[23]}] [get_ports     \
{ir_out[22]}] [get_ports {ir_out[21]}] [get_ports {ir_out[20]}] [get_ports     \
{ir_out[19]}] [get_ports {ir_out[18]}] [get_ports {ir_out[17]}] [get_ports     \
{ir_out[16]}] [get_ports {ir_out[15]}] [get_ports {ir_out[14]}] [get_ports     \
{ir_out[13]}] [get_ports {ir_out[12]}] [get_ports {ir_out[11]}] [get_ports     \
{ir_out[10]}] [get_ports {ir_out[9]}] [get_ports {ir_out[8]}] [get_ports       \
{ir_out[7]}] [get_ports {ir_out[6]}] [get_ports {ir_out[5]}] [get_ports        \
{ir_out[4]}] [get_ports {ir_out[3]}] [get_ports {ir_out[2]}] [get_ports        \
{ir_out[1]}] [get_ports {ir_out[0]}] [get_ports {rd_out_id[4]}] [get_ports     \
{rd_out_id[3]}] [get_ports {rd_out_id[2]}] [get_ports {rd_out_id[1]}]          \
[get_ports {rd_out_id[0]}] [get_ports {npc_out_id[31]}] [get_ports             \
{npc_out_id[30]}] [get_ports {npc_out_id[29]}] [get_ports {npc_out_id[28]}]    \
[get_ports {npc_out_id[27]}] [get_ports {npc_out_id[26]}] [get_ports           \
{npc_out_id[25]}] [get_ports {npc_out_id[24]}] [get_ports {npc_out_id[23]}]    \
[get_ports {npc_out_id[22]}] [get_ports {npc_out_id[21]}] [get_ports           \
{npc_out_id[20]}] [get_ports {npc_out_id[19]}] [get_ports {npc_out_id[18]}]    \
[get_ports {npc_out_id[17]}] [get_ports {npc_out_id[16]}] [get_ports           \
{npc_out_id[15]}] [get_ports {npc_out_id[14]}] [get_ports {npc_out_id[13]}]    \
[get_ports {npc_out_id[12]}] [get_ports {npc_out_id[11]}] [get_ports           \
{npc_out_id[10]}] [get_ports {npc_out_id[9]}] [get_ports {npc_out_id[8]}]      \
[get_ports {npc_out_id[7]}] [get_ports {npc_out_id[6]}] [get_ports             \
{npc_out_id[5]}] [get_ports {npc_out_id[4]}] [get_ports {npc_out_id[3]}]       \
[get_ports {npc_out_id[2]}] [get_ports {npc_out_id[1]}] [get_ports             \
{npc_out_id[0]}] [get_ports {a_reg_out[31]}] [get_ports {a_reg_out[30]}]       \
[get_ports {a_reg_out[29]}] [get_ports {a_reg_out[28]}] [get_ports             \
{a_reg_out[27]}] [get_ports {a_reg_out[26]}] [get_ports {a_reg_out[25]}]       \
[get_ports {a_reg_out[24]}] [get_ports {a_reg_out[23]}] [get_ports             \
{a_reg_out[22]}] [get_ports {a_reg_out[21]}] [get_ports {a_reg_out[20]}]       \
[get_ports {a_reg_out[19]}] [get_ports {a_reg_out[18]}] [get_ports             \
{a_reg_out[17]}] [get_ports {a_reg_out[16]}] [get_ports {a_reg_out[15]}]       \
[get_ports {a_reg_out[14]}] [get_ports {a_reg_out[13]}] [get_ports             \
{a_reg_out[12]}] [get_ports {a_reg_out[11]}] [get_ports {a_reg_out[10]}]       \
[get_ports {a_reg_out[9]}] [get_ports {a_reg_out[8]}] [get_ports               \
{a_reg_out[7]}] [get_ports {a_reg_out[6]}] [get_ports {a_reg_out[5]}]          \
[get_ports {a_reg_out[4]}] [get_ports {a_reg_out[3]}] [get_ports               \
{a_reg_out[2]}] [get_ports {a_reg_out[1]}] [get_ports {a_reg_out[0]}]          \
[get_ports {b_reg_out[31]}] [get_ports {b_reg_out[30]}] [get_ports             \
{b_reg_out[29]}] [get_ports {b_reg_out[28]}] [get_ports {b_reg_out[27]}]       \
[get_ports {b_reg_out[26]}] [get_ports {b_reg_out[25]}] [get_ports             \
{b_reg_out[24]}] [get_ports {b_reg_out[23]}] [get_ports {b_reg_out[22]}]       \
[get_ports {b_reg_out[21]}] [get_ports {b_reg_out[20]}] [get_ports             \
{b_reg_out[19]}] [get_ports {b_reg_out[18]}] [get_ports {b_reg_out[17]}]       \
[get_ports {b_reg_out[16]}] [get_ports {b_reg_out[15]}] [get_ports             \
{b_reg_out[14]}] [get_ports {b_reg_out[13]}] [get_ports {b_reg_out[12]}]       \
[get_ports {b_reg_out[11]}] [get_ports {b_reg_out[10]}] [get_ports             \
{b_reg_out[9]}] [get_ports {b_reg_out[8]}] [get_ports {b_reg_out[7]}]          \
[get_ports {b_reg_out[6]}] [get_ports {b_reg_out[5]}] [get_ports               \
{b_reg_out[4]}] [get_ports {b_reg_out[3]}] [get_ports {b_reg_out[2]}]          \
[get_ports {b_reg_out[1]}] [get_ports {b_reg_out[0]}] [get_ports               \
{imm_reg_out[31]}] [get_ports {imm_reg_out[30]}] [get_ports {imm_reg_out[29]}] \
[get_ports {imm_reg_out[28]}] [get_ports {imm_reg_out[27]}] [get_ports         \
{imm_reg_out[26]}] [get_ports {imm_reg_out[25]}] [get_ports {imm_reg_out[24]}] \
[get_ports {imm_reg_out[23]}] [get_ports {imm_reg_out[22]}] [get_ports         \
{imm_reg_out[21]}] [get_ports {imm_reg_out[20]}] [get_ports {imm_reg_out[19]}] \
[get_ports {imm_reg_out[18]}] [get_ports {imm_reg_out[17]}] [get_ports         \
{imm_reg_out[16]}] [get_ports {imm_reg_out[15]}] [get_ports {imm_reg_out[14]}] \
[get_ports {imm_reg_out[13]}] [get_ports {imm_reg_out[12]}] [get_ports         \
{imm_reg_out[11]}] [get_ports {imm_reg_out[10]}] [get_ports {imm_reg_out[9]}]  \
[get_ports {imm_reg_out[8]}] [get_ports {imm_reg_out[7]}] [get_ports           \
{imm_reg_out[6]}] [get_ports {imm_reg_out[5]}] [get_ports {imm_reg_out[4]}]    \
[get_ports {imm_reg_out[3]}] [get_ports {imm_reg_out[2]}] [get_ports           \
{imm_reg_out[1]}] [get_ports {imm_reg_out[0]}] [get_ports {alu_out[31]}]       \
[get_ports {alu_out[30]}] [get_ports {alu_out[29]}] [get_ports {alu_out[28]}]  \
[get_ports {alu_out[27]}] [get_ports {alu_out[26]}] [get_ports {alu_out[25]}]  \
[get_ports {alu_out[24]}] [get_ports {alu_out[23]}] [get_ports {alu_out[22]}]  \
[get_ports {alu_out[21]}] [get_ports {alu_out[20]}] [get_ports {alu_out[19]}]  \
[get_ports {alu_out[18]}] [get_ports {alu_out[17]}] [get_ports {alu_out[16]}]  \
[get_ports {alu_out[15]}] [get_ports {alu_out[14]}] [get_ports {alu_out[13]}]  \
[get_ports {alu_out[12]}] [get_ports {alu_out[11]}] [get_ports {alu_out[10]}]  \
[get_ports {alu_out[9]}] [get_ports {alu_out[8]}] [get_ports {alu_out[7]}]     \
[get_ports {alu_out[6]}] [get_ports {alu_out[5]}] [get_ports {alu_out[4]}]     \
[get_ports {alu_out[3]}] [get_ports {alu_out[2]}] [get_ports {alu_out[1]}]     \
[get_ports {alu_out[0]}] [get_ports {rd_out_ex[4]}] [get_ports {rd_out_ex[3]}] \
[get_ports {rd_out_ex[2]}] [get_ports {rd_out_ex[1]}] [get_ports               \
{rd_out_ex[0]}] [get_ports {b_reg_out_ex[31]}] [get_ports {b_reg_out_ex[30]}]  \
[get_ports {b_reg_out_ex[29]}] [get_ports {b_reg_out_ex[28]}] [get_ports       \
{b_reg_out_ex[27]}] [get_ports {b_reg_out_ex[26]}] [get_ports                  \
{b_reg_out_ex[25]}] [get_ports {b_reg_out_ex[24]}] [get_ports                  \
{b_reg_out_ex[23]}] [get_ports {b_reg_out_ex[22]}] [get_ports                  \
{b_reg_out_ex[21]}] [get_ports {b_reg_out_ex[20]}] [get_ports                  \
{b_reg_out_ex[19]}] [get_ports {b_reg_out_ex[18]}] [get_ports                  \
{b_reg_out_ex[17]}] [get_ports {b_reg_out_ex[16]}] [get_ports                  \
{b_reg_out_ex[15]}] [get_ports {b_reg_out_ex[14]}] [get_ports                  \
{b_reg_out_ex[13]}] [get_ports {b_reg_out_ex[12]}] [get_ports                  \
{b_reg_out_ex[11]}] [get_ports {b_reg_out_ex[10]}] [get_ports                  \
{b_reg_out_ex[9]}] [get_ports {b_reg_out_ex[8]}] [get_ports {b_reg_out_ex[7]}] \
[get_ports {b_reg_out_ex[6]}] [get_ports {b_reg_out_ex[5]}] [get_ports         \
{b_reg_out_ex[4]}] [get_ports {b_reg_out_ex[3]}] [get_ports {b_reg_out_ex[2]}] \
[get_ports {b_reg_out_ex[1]}] [get_ports {b_reg_out_ex[0]}] [get_ports         \
{rd_out_mem[4]}] [get_ports {rd_out_mem[3]}] [get_ports {rd_out_mem[2]}]       \
[get_ports {rd_out_mem[1]}] [get_ports {rd_out_mem[0]}] [get_ports             \
{memory_stage_out[31]}] [get_ports {memory_stage_out[30]}] [get_ports          \
{memory_stage_out[29]}] [get_ports {memory_stage_out[28]}] [get_ports          \
{memory_stage_out[27]}] [get_ports {memory_stage_out[26]}] [get_ports          \
{memory_stage_out[25]}] [get_ports {memory_stage_out[24]}] [get_ports          \
{memory_stage_out[23]}] [get_ports {memory_stage_out[22]}] [get_ports          \
{memory_stage_out[21]}] [get_ports {memory_stage_out[20]}] [get_ports          \
{memory_stage_out[19]}] [get_ports {memory_stage_out[18]}] [get_ports          \
{memory_stage_out[17]}] [get_ports {memory_stage_out[16]}] [get_ports          \
{memory_stage_out[15]}] [get_ports {memory_stage_out[14]}] [get_ports          \
{memory_stage_out[13]}] [get_ports {memory_stage_out[12]}] [get_ports          \
{memory_stage_out[11]}] [get_ports {memory_stage_out[10]}] [get_ports          \
{memory_stage_out[9]}] [get_ports {memory_stage_out[8]}] [get_ports            \
{memory_stage_out[7]}] [get_ports {memory_stage_out[6]}] [get_ports            \
{memory_stage_out[5]}] [get_ports {memory_stage_out[4]}] [get_ports            \
{memory_stage_out[3]}] [get_ports {memory_stage_out[2]}] [get_ports            \
{memory_stage_out[1]}] [get_ports {memory_stage_out[0]}] [get_ports            \
{alu_out_mem[31]}] [get_ports {alu_out_mem[30]}] [get_ports {alu_out_mem[29]}] \
[get_ports {alu_out_mem[28]}] [get_ports {alu_out_mem[27]}] [get_ports         \
{alu_out_mem[26]}] [get_ports {alu_out_mem[25]}] [get_ports {alu_out_mem[24]}] \
[get_ports {alu_out_mem[23]}] [get_ports {alu_out_mem[22]}] [get_ports         \
{alu_out_mem[21]}] [get_ports {alu_out_mem[20]}] [get_ports {alu_out_mem[19]}] \
[get_ports {alu_out_mem[18]}] [get_ports {alu_out_mem[17]}] [get_ports         \
{alu_out_mem[16]}] [get_ports {alu_out_mem[15]}] [get_ports {alu_out_mem[14]}] \
[get_ports {alu_out_mem[13]}] [get_ports {alu_out_mem[12]}] [get_ports         \
{alu_out_mem[11]}] [get_ports {alu_out_mem[10]}] [get_ports {alu_out_mem[9]}]  \
[get_ports {alu_out_mem[8]}] [get_ports {alu_out_mem[7]}] [get_ports           \
{alu_out_mem[6]}] [get_ports {alu_out_mem[5]}] [get_ports {alu_out_mem[4]}]    \
[get_ports {alu_out_mem[3]}] [get_ports {alu_out_mem[2]}] [get_ports           \
{alu_out_mem[1]}] [get_ports {alu_out_mem[0]}] [get_ports {rd_out_wb[4]}]      \
[get_ports {rd_out_wb[3]}] [get_ports {rd_out_wb[2]}] [get_ports               \
{rd_out_wb[1]}] [get_ports {rd_out_wb[0]}] [get_ports {wb_stage_out[31]}]      \
[get_ports {wb_stage_out[30]}] [get_ports {wb_stage_out[29]}] [get_ports       \
{wb_stage_out[28]}] [get_ports {wb_stage_out[27]}] [get_ports                  \
{wb_stage_out[26]}] [get_ports {wb_stage_out[25]}] [get_ports                  \
{wb_stage_out[24]}] [get_ports {wb_stage_out[23]}] [get_ports                  \
{wb_stage_out[22]}] [get_ports {wb_stage_out[21]}] [get_ports                  \
{wb_stage_out[20]}] [get_ports {wb_stage_out[19]}] [get_ports                  \
{wb_stage_out[18]}] [get_ports {wb_stage_out[17]}] [get_ports                  \
{wb_stage_out[16]}] [get_ports {wb_stage_out[15]}] [get_ports                  \
{wb_stage_out[14]}] [get_ports {wb_stage_out[13]}] [get_ports                  \
{wb_stage_out[12]}] [get_ports {wb_stage_out[11]}] [get_ports                  \
{wb_stage_out[10]}] [get_ports {wb_stage_out[9]}] [get_ports                   \
{wb_stage_out[8]}] [get_ports {wb_stage_out[7]}] [get_ports {wb_stage_out[6]}] \
[get_ports {wb_stage_out[5]}] [get_ports {wb_stage_out[4]}] [get_ports         \
{wb_stage_out[3]}] [get_ports {wb_stage_out[2]}] [get_ports {wb_stage_out[1]}] \
[get_ports {wb_stage_out[0]}] [get_ports address_error] [get_ports             \
MUXA_CONTROL] [get_ports MUXB_CONTROL] [get_ports {ALU_OPCODE[3]}] [get_ports  \
{ALU_OPCODE[2]}] [get_ports {ALU_OPCODE[1]}] [get_ports {ALU_OPCODE[0]}]       \
[get_ports DRAM_WE] [get_ports DRAM_RE] [get_ports WB_MUX_SEL] [get_ports      \
JAL_SEL] [get_ports RF_WE] [get_ports alu_forwarding_one] [get_ports           \
mem_forwarding_one] [get_ports alu_forwarding_two] [get_ports                  \
mem_forwarding_two] [get_ports {alu_forwarding_value[31]}] [get_ports          \
{alu_forwarding_value[30]}] [get_ports {alu_forwarding_value[29]}] [get_ports  \
{alu_forwarding_value[28]}] [get_ports {alu_forwarding_value[27]}] [get_ports  \
{alu_forwarding_value[26]}] [get_ports {alu_forwarding_value[25]}] [get_ports  \
{alu_forwarding_value[24]}] [get_ports {alu_forwarding_value[23]}] [get_ports  \
{alu_forwarding_value[22]}] [get_ports {alu_forwarding_value[21]}] [get_ports  \
{alu_forwarding_value[20]}] [get_ports {alu_forwarding_value[19]}] [get_ports  \
{alu_forwarding_value[18]}] [get_ports {alu_forwarding_value[17]}] [get_ports  \
{alu_forwarding_value[16]}] [get_ports {alu_forwarding_value[15]}] [get_ports  \
{alu_forwarding_value[14]}] [get_ports {alu_forwarding_value[13]}] [get_ports  \
{alu_forwarding_value[12]}] [get_ports {alu_forwarding_value[11]}] [get_ports  \
{alu_forwarding_value[10]}] [get_ports {alu_forwarding_value[9]}] [get_ports   \
{alu_forwarding_value[8]}] [get_ports {alu_forwarding_value[7]}] [get_ports    \
{alu_forwarding_value[6]}] [get_ports {alu_forwarding_value[5]}] [get_ports    \
{alu_forwarding_value[4]}] [get_ports {alu_forwarding_value[3]}] [get_ports    \
{alu_forwarding_value[2]}] [get_ports {alu_forwarding_value[1]}] [get_ports    \
{alu_forwarding_value[0]}] [get_ports {mem_forwarding_value[31]}] [get_ports   \
{mem_forwarding_value[30]}] [get_ports {mem_forwarding_value[29]}] [get_ports  \
{mem_forwarding_value[28]}] [get_ports {mem_forwarding_value[27]}] [get_ports  \
{mem_forwarding_value[26]}] [get_ports {mem_forwarding_value[25]}] [get_ports  \
{mem_forwarding_value[24]}] [get_ports {mem_forwarding_value[23]}] [get_ports  \
{mem_forwarding_value[22]}] [get_ports {mem_forwarding_value[21]}] [get_ports  \
{mem_forwarding_value[20]}] [get_ports {mem_forwarding_value[19]}] [get_ports  \
{mem_forwarding_value[18]}] [get_ports {mem_forwarding_value[17]}] [get_ports  \
{mem_forwarding_value[16]}] [get_ports {mem_forwarding_value[15]}] [get_ports  \
{mem_forwarding_value[14]}] [get_ports {mem_forwarding_value[13]}] [get_ports  \
{mem_forwarding_value[12]}] [get_ports {mem_forwarding_value[11]}] [get_ports  \
{mem_forwarding_value[10]}] [get_ports {mem_forwarding_value[9]}] [get_ports   \
{mem_forwarding_value[8]}] [get_ports {mem_forwarding_value[7]}] [get_ports    \
{mem_forwarding_value[6]}] [get_ports {mem_forwarding_value[5]}] [get_ports    \
{mem_forwarding_value[4]}] [get_ports {mem_forwarding_value[3]}] [get_ports    \
{mem_forwarding_value[2]}] [get_ports {mem_forwarding_value[1]}] [get_ports    \
{mem_forwarding_value[0]}]]
