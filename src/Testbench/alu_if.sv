`include "defines.svh"

interface alu_if(input bit clk, input bit rst);

logic[`DW-1:0]OPA;
logic[`DW-1:0]OPB;
logic[1:0]INP_VALID;
logic MODE,CE,CIN;
logic[`CW-1:0]CMD;
logic [4:0] wait_cycle;
logic[`DW*2-1:0]RES;
logic ERR,OFLOW,COUT,G,E,L;

clocking drv_cb@(posedge clk);
        default input #1 output #1;
        output OPA;
        output OPB;
        output INP_VALID;
        output CMD;
        output MODE,CIN,CE;
endclocking

clocking in_mon_cb@(posedge clk);
        default input #1 output #1;
        input OPA;
        input OPB;
        input INP_VALID;
        input CMD;
        input MODE;
        input CIN;
        input CE;
endclocking

  clocking out_mon_cb@(posedge clk);
        default input #1 output #1;
        input OPA;
        input OPB;
        input INP_VALID;
        input CMD;
        input MODE;
        input CIN;
        input CE;
        input ERR;
        input RES;
        input OFLOW;
        input COUT;
        input G;
        input E;
        input L;
endclocking

modport DRV(input clk, rst, clocking drv_cb);
modport IN_MON(input clk, rst, clocking in_mon_cb);
modport OUT_MON(input clk, rst, clocking out_mon_cb);

endinterface


