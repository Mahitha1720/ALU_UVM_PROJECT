class test extends uvm_test;
`uvm_component_utils(test)
env env_h;
alu_config m_cfg;

function new(string name="test", uvm_component parent);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
m_cfg= alu_config::type_id::create("m_cfg");

if(!uvm_config_db#(virtual alu_if)::get(this,"","alu_if", m_cfg.vif))
`uvm_fatal(get_type_name(), "Test is failing")
m_cfg.input_agent_is_active= UVM_ACTIVE;
m_cfg.output_agent_is_active=UVM_PASSIVE;

uvm_config_db#(alu_config)::set(this,"*","alu_config",m_cfg);
//set and get in build_phase of the test

env_h= env::type_id::create("env_h",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
uvm_top.print_topology();

endfunction

endclass

class test_add extends test;
`uvm_component_utils(test_add)

seq_add s2;

function new(string name="test_add", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s2= seq_add::type_id::create("s2");
s2.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass





class test_sub extends test;
`uvm_component_utils(test_sub)

seq_sub s3;

function new(string name="test_sub", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s3= seq_sub::type_id::create("s3");
s3.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass

class test_add_cin extends test;
`uvm_component_utils(test_add_cin)

seq_add_cin s4;

function new(string name="test_add_cin", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s4= seq_add_cin::type_id::create("s4");
s4.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass





class test_sub_cin extends test;
`uvm_component_utils(test_sub_cin)

seq_sub_cin s5;

function new(string name="test_sub_cin", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s5= seq_sub_cin::type_id::create("s5");
s5.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass

class test_inc_dec extends test;
`uvm_component_utils(test_inc_dec)

seq_inc_dec s6;

function new(string name="test_inc_dec", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s6= seq_inc_dec::type_id::create("s6");
s6.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass




class test_comp extends test;
`uvm_component_utils(test_comp)

seq_comp s7;

function new(string name="test_comp", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s7= seq_comp::type_id::create("s7");
s7.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass


class test_mul_inc extends test;
`uvm_component_utils(test_mul_inc)

seq_mul_inc s8;

function new(string name="test_mul_inc", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s8= seq_mul_inc::type_id::create("s8");
s8.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass



class test_mul_shl extends test;
`uvm_component_utils(test_mul_shl)

seq_mul_shl s9;

function new(string name="test_mul_shl", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s9= seq_mul_shl::type_id::create("s9");
s9.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass

class test_logical extends test;
`uvm_component_utils(test_logical)

seq_mul_shl s9;

function new(string name="test_mul_shl", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s9= seq_mul_shl::type_id::create("s9");
s9.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass




class test_wait extends test;
`uvm_component_utils(test_wait)

seq_wait s10;

function new(string name="test_wait", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s10= seq_wait::type_id::create("s9");
s10.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass

class test_err1 extends test;
`uvm_component_utils(test_err1)

seq_timeout e1;

function new(string name="test_err1", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
e1= seq_timeout::type_id::create("e1");
e1.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask
endclass



class test_timing extends test;
`uvm_component_utils(test_timing)
seq_timing s5;

function new(string name="test_timing", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
s5 = seq_timing::type_id::create("s5");
s5.start(env_h.in_agt_h.seqr_h);
#50;
phase.drop_objection(this);
endtask
endclass

class test_err2 extends test;
`uvm_component_utils(test_err2)

err_seq e2;

function new(string name="test_err2", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
e2= err_seq::type_id::create("e2");
e2.start(env_h.in_agt_h.seqr_h);
#100;
phase.drop_objection(this);
endtask

endclass

class test_timing2 extends test;
`uvm_component_utils(test_timing2)

seq_timing2 st2;
virtual alu_if vif;

function new(string name="test_timing2", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual alu_if)::get(this,"","alu_if",vif))
`uvm_fatal("NOVIF","virtual interface not found")
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);

@(negedge vif.rst);
@(posedge vif.clk);

st2 = seq_timing2::type_id::create("st2");
st2.start(env_h.in_agt_h.seqr_h);

#50;

phase.drop_objection(this);
endtask
endclass




