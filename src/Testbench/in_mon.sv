class in_mon extends uvm_monitor;
`uvm_component_utils(in_mon)

uvm_analysis_port#(trans) in_mon_port;

virtual alu_if.IN_MON vif;
alu_config m_cfg;
trans drv2mon;

function new(string name="in_mon", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
  
if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
`uvm_fatal(get_type_name(),"Input Monitor Getting Failed")
in_mon_port = new("in_mon_port",this);
vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
forever begin
collect_input_monitor();
in_mon_port.write(drv2mon);
end
endtask

task collect_input_monitor();
@(vif.in_mon_cb);

drv2mon = trans::type_id::create("drv2mon");
drv2mon.OPA = vif.in_mon_cb.OPA;
drv2mon.OPB = vif.in_mon_cb.OPB;
drv2mon.CMD = vif.in_mon_cb.CMD;
drv2mon.CE = vif.in_mon_cb.CE;
drv2mon.INP_VALID = vif.in_mon_cb.INP_VALID;
drv2mon.MODE = vif.in_mon_cb.MODE;
drv2mon.rst = vif.rst;
drv2mon.CIN = vif.in_mon_cb.CIN;

endtask
endclass
