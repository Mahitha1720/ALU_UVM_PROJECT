`include "alu_rtl.sv"

module top();
import uvm_pkg::*;
import test_pkg::*;

bit clk, rst;

alu_if DUV_IF(clk,rst);

ALU_DESIGN DUV (
.OPA (DUV_IF.OPA),
.OPB(DUV_IF.OPB),
.CLK (clk),
.RST (DUV_IF.rst),
.CE  (DUV_IF.CE),
.MODE (DUV_IF.MODE),
.CIN (DUV_IF.CIN),
.CMD(DUV_IF.CMD),
.INP_VALID (DUV_IF.INP_VALID),
.RES(DUV_IF.RES),
.COUT(DUV_IF.COUT),
.OFLOW (DUV_IF.OFLOW),
.G (DUV_IF.G),
.E (DUV_IF.E),
.L  (DUV_IF.L),
.ERR (DUV_IF.ERR));

always @(posedge clk)
begin
$display("DUT @%0t OPA=%0h OPB=%0h CMD=%0h MODE=%0b CE=%0b INP_VALID=%0b RES=%0h COUT=%0b ERR=%0b",
$time,
DUV_IF.OPA,
DUV_IF.OPB,
DUV_IF.CMD,
DUV_IF.MODE,
DUV_IF.CE,
DUV_IF.INP_VALID,
DUV_IF.RES,
DUV_IF.COUT,
DUV_IF.ERR);
end

  initial begin
uvm_config_db#(virtual alu_if)::set(null, "*", "alu_if", DUV_IF);
$dumpfile("waves.fsdb");
$dumpvars;

run_test();
end

initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

initial begin
rst = 1'b1;
repeat (3) @(posedge clk);
rst = 1'b0;
end

endmodule

