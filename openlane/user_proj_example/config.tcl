# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

proc listFromFile {filename} {
    set f [open $filename r]
    set data [split [string trim [read $f]]]
    close $f
    return $data
}

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_proj_example

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v \
	$script_dir/../../verilog/rtl/aes.v \
	$script_dir/../../verilog/rtl/aes_core.v \
	$script_dir/../../verilog/rtl/aes_decipher_block.v \
	$script_dir/../../verilog/rtl/aes_encipher_block.v \
	$script_dir/../../verilog/rtl/aes_inv_sbox.v \
	$script_dir/../../verilog/rtl/aes_key_mem.v \
	$script_dir/../../verilog/rtl/aes_sbox.v"

set ::env(DESIGN_IS_CORE) 0

set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "clk"
set ::env(CLOCK_PERIOD) "30"

set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
# 
# set ::env(GLB_RT_MAXLAYER) 5

set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]


##################################################################
# Flow Control
##################################################################
set ::env(RUN_ROUTING_DETAILED) 1
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1
set ::env(LEC_ENABLE) 0


##################################################################
# Synthesis
##################################################################
set ::env(SYNTH_STRATEGY) {AREA 1}
set ::env(SYNTH_MAX_FANOUT) 3

##################################################################
# Floorplanning
##################################################################
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1800 1600"
set ::env(FP_CORE_UTIL) 18
set ::env(DESIGN_IS_CORE) 0
set ::env(FP_PDN_VPITCH) 100
# decrease li density, increase li clear area density, by using ef decap cell
set ::env(DECAP_CELL) "\
	sky130_fd_sc_hd__decap_3 \
	sky130_fd_sc_hd__decap_4 \
	sky130_fd_sc_hd__decap_6 \
	sky130_fd_sc_hd__decap_8 \
	sky130_fd_sc_hd__decap_12" 

##################################################################
# Placement
##################################################################
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) 0.18
set ::env(PL_TIME_DRIVEN) 0
set ::env(PL_ROUTABILITY_DRIVEN) 1
set ::env(PL_MAX_DISPLACEMENT_X) 600
set ::env(PL_MAX_DISPLACEMENT_Y) 400
set ::env(CELL_PAD) 8
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 1
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 1
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) 30
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT) 70
set ::env(PL_RESIZER_ALLOW_SETUP_VIOS) 1
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.2
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) 125

##################################################################
# CTS
##################################################################
set ::env(CTS_TARGET_SKEW) 150
set ::env(CTS_TOLERANCE) 25
set ::env(CTS_CLK_BUFFER_LIST) "sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8"
set ::env(SYNTH_MIN_BUF_PORT) {sky130_fd_sc_hd__buf_4 A X}
set ::env(DONT_USE_CELLS) "sky130_fd_sc_hd__buf_1 \
                           sky130_fd_sc_hd__buf_2 \
                           sky130_fd_sc_hd__buf_12 \
						   sky130_fd_sc_hd__clkbuf_1 \
						   sky130_fd_sc_hd__clkbuf_2 \
						   [listFromFile $::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/drc_exclude.cells]"
set ::env(CTS_SINK_CLUSTERING_SIZE) "16"
set ::env(CLOCK_BUFFER_FANOUT) "6"
set ::env(CTS_CLK_MAX_WIRE_LENGTH) 300

##################################################################
# Optimization
##################################################################


##################################################################
# Global Routing
##################################################################
set ::env(GLB_RT_ANT_ITERS) 15
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 15
set ::env(GLOBAL_ROUTER) fastroute
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) 1
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) 0.4
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) 75

##################################################################
# Antenna Diodes Insertion
##################################################################
set ::env(DIODE_PADDING) 2
set ::env(DIODE_INSERTION_STRATEGY) 3

##################################################################
# LEC
##################################################################

##################################################################
# Detailed Routing
##################################################################
set ::env(DRT_OPT_ITERS) 45
set ::env(ROUTING_CORES) 8
set ::env(DETAILED_ROUTER) tritonroute