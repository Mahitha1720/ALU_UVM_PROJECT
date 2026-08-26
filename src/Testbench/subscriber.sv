class subscriber extends uvm_subscriber #(trans);

`uvm_component_utils(subscriber)

trans tr;

covergroup in_cg;

c1: coverpoint tr.OPA
{
bins opa = {[1:500]};
}

c2: coverpoint tr.OPB
{
bins opb = {[1:500]};
}

c3: coverpoint tr.CIN
{
bins cin[] = {0,1};
}

c4: coverpoint tr.INP_VALID {
bins invalid = {0};
bins opa_valid = {1};
bins opb_valid = {2};
bins both_valid = {3};
}

c5: coverpoint tr.MODE {
bins logical = {0};
bins arithmetic = {1};
}

c6: coverpoint tr.CE
{
bins ce[] = {0,1};
}

c7: coverpoint tr.CMD {
bins ADD      = {4'h0};
bins SUB      = {4'h1};
bins ADD_CIN  = {4'h2};
bins SUB_CIN  = {4'h3};
bins INC_A    = {4'h4};
bins DEC_A    = {4'h5};
bins INC_B    = {4'h6};
bins DEC_B    = {4'h7};
bins CMP      = {4'h8};
bins CMD9     = {4'h9};
bins CMD10    = {4'hA};
bins reserved = {[4'hB:4'hF]};
}

c8: cross c7,c4;
c9: cross c7,c6;
c10: cross c5,c6;
endgroup


function new(string name,uvm_component parent);
super.new(name,parent);
in_cg = new();
endfunction


function void write(trans t);
tr = t;
in_cg.sample();
endfunction

endclass

