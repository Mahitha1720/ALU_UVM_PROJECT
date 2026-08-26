class out_agent extends uvm_agent;
`uvm_component_utils(out_agent)

out_mon out_mon_h;
alu_config m_cfg;

function new(string name="out_agent",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
`uvm_fatal(get_type_name(),"Output_agt Getting Failed")

if(m_cfg.output_agent_is_active==UVM_PASSIVE)
begin
out_mon_h=out_mon::type_id::create("out_mon_h",this);
end
endfunction

 endclass

