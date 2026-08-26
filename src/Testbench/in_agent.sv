class in_agent extends uvm_agent;
`uvm_component_utils(in_agent)

drv drv_h;
in_mon in_mon_h;
seqr seqr_h;
alu_config m_cfg;

function new(string name="input_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
`uvm_fatal(get_type_name(),"Input_agt Getting Failed")

in_mon_h=in_mon::type_id::create("in_mon_h",this);

if(m_cfg.input_agent_is_active==UVM_ACTIVE)
begin
drv_h= drv::type_id::create("dr_h",this);
seqr_h=seqr::type_id::create("seqr_h",this);
end
endfunction

function void connect_phase(uvm_phase phase);
if(m_cfg.input_agent_is_active==UVM_ACTIVE)
begin
drv_h.seq_item_port.connect(seqr_h.seq_item_export);
end
endfunction

endclass

