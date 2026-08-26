class env extends uvm_env;
`uvm_component_utils(env)

in_agent in_agt_h;
out_agent out_agt_h;
scoreboard scb_h;
subscriber sub_h;

alu_config m_cfg;

function new(string name="env", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
`uvm_fatal(get_type_name(),"Output agent getting Failed")

in_agt_h= in_agent::type_id::create("in_agt_h", this);
out_agt_h=out_agent::type_id::create("out_agt_h",this);
scb_h=scoreboard::type_id::create("scb_h",this);
sub_h= subscriber::type_id::create("sub_h", this);
endfunction

function void connect_phase(uvm_phase phase);

in_agt_h.in_mon_h.in_mon_port.connect(scb_h.in_mon_fifo.analysis_export);

out_agt_h.out_mon_h.out_mon_port.connect(scb_h.out_mon_fifo.analysis_export);

in_agt_h.in_mon_h.in_mon_port.connect(sub_h.analysis_export);

endfunction

endclass
