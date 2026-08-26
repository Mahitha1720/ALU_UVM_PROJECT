`include "defines.svh"

class trans extends uvm_sequence_item;
`uvm_object_utils(trans)

bit rst;
rand bit[`DW-1:0]OPA;
rand bit[`DW-1:0]OPB;
rand bit[1:0]INP_VALID;
rand bit[`CW-1:0]CMD;
rand bit [4:0] wait_cycle;
rand bit MODE,CIN,CE;
logic [`DW*2-1:0]RES;
logic ERR,OFLOW,COUT,G,E,L;


 constraint c0{CE ==1;}
 constraint c1{OPA inside {[1:255]};}
 constraint c2{OPB inside {[1:255]};}
 constraint c3{INP_VALID dist {2'b00 :=5, 2'b01 :=5, 2'b10 :=5, 2'b11 :=500};}
 constraint c4{MODE dist{1'b1:=5,1'b0:=5};}
 constraint c5{if(MODE==1)
                CMD<11;
                else
                CMD<14;}
//constraint c5{CMD dist{4'b1001:=10};}
constraint c6{CIN dist{1:=5,0:=5};}
constraint c7{wait_cycle inside {[0:16]};}

 function new(string name="trans");
super.new(name);
 endfunction

 endclass

