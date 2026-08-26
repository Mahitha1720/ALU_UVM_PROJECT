class out_mon extends uvm_monitor;
`uvm_component_utils(out_mon)

uvm_analysis_port#(trans) out_mon_port;

virtual alu_if.OUT_MON vif;
alu_config m_cfg;
trans dut2mon;

function new(string name="out_mon", uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
    `uvm_fatal(get_type_name(),"Output Monitor Getting Failed")
  out_mon_port = new("out_mon_port",this);
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
  collect_output_monitor();
endtask

  virtual task collect_output_monitor();
  wait(!vif.rst);
  forever begin
    @(vif.out_mon_cb);

    dut2mon = trans::type_id::create("dut2mon");

    dut2mon.OPA       = vif.out_mon_cb.OPA;
    dut2mon.OPB       = vif.out_mon_cb.OPB;
    dut2mon.CMD       = vif.out_mon_cb.CMD;
    dut2mon.CE        = vif.out_mon_cb.CE;
    dut2mon.INP_VALID = vif.out_mon_cb.INP_VALID;
    dut2mon.MODE      = vif.out_mon_cb.MODE;
    dut2mon.RES       = vif.out_mon_cb.RES;
    dut2mon.ERR       = vif.out_mon_cb.ERR;
    dut2mon.COUT      = vif.out_mon_cb.COUT;
    dut2mon.OFLOW     = vif.out_mon_cb.OFLOW;
    dut2mon.G         = vif.out_mon_cb.G;
    dut2mon.E         = vif.out_mon_cb.E;
    dut2mon.L         = vif.out_mon_cb.L;

    if((dut2mon.MODE==1) && ((dut2mon.CMD==4'b0010) || (dut2mon.CMD==4'b0011)))
      dut2mon.CIN = vif.out_mon_cb.CIN;

    out_mon_port.write(dut2mon);

    $display("OUT_MON @%0t CMD=%0h MODE=%0b CE=%0b INP_VALID=%0b OPA=%0h OPB=%0h RES=%0h ERR=%0b",
              $time, dut2mon.CMD, dut2mon.MODE, dut2mon.CE, dut2mon.INP_VALID,
              dut2mon.OPA, dut2mon.OPB, dut2mon.RES, dut2mon.ERR);
  end
endtask

endclass

