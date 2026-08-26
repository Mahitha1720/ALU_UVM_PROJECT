class drv extends uvm_driver#(trans);
`uvm_component_utils(drv)

virtual alu_if.DRV vif;
alu_config m_cfg;
trans drv2dut;

function new(string name="drv",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
`uvm_fatal(get_type_name(),"Driver Getting Failed")
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
forever
begin
seq_item_port.get_next_item(req);
drive(req);
seq_item_port.item_done();
end
endtask

task drive(trans drv2dut);
begin
@(vif.drv_cb);
vif.drv_cb.CE   <= drv2dut.CE;
vif.drv_cb.MODE <= drv2dut.MODE;
vif.drv_cb.CMD  <= drv2dut.CMD;
vif.drv_cb.CIN <= drv2dut.CIN;

if(drv2dut.INP_VALID == 2'b01 || drv2dut.INP_VALID == 2'b10) begin
vif.drv_cb.INP_VALID <= drv2dut.INP_VALID;
if(drv2dut.INP_VALID == 2'b01) vif.drv_cb.OPA <= drv2dut.OPA;
else                            vif.drv_cb.OPB <= drv2dut.OPB;
@(vif.drv_cb);

vif.drv_cb.INP_VALID <= 2'b00;
repeat(drv2dut.wait_cycle) @(vif.drv_cb);

if(drv2dut.wait_cycle <= 16) begin
if(drv2dut.INP_VALID == 2'b01) begin
vif.drv_cb.OPB       <= drv2dut.OPB;
vif.drv_cb.INP_VALID <= 2'b10;
end else begin
vif.drv_cb.OPA       <= drv2dut.OPA;
vif.drv_cb.INP_VALID <= 2'b01;
end
@(vif.drv_cb);
vif.drv_cb.INP_VALID <= 2'b00;
end
end
else begin
vif.drv_cb.OPA       <= drv2dut.OPA;
vif.drv_cb.OPB       <= drv2dut.OPB;
vif.drv_cb.INP_VALID <= drv2dut.INP_VALID;
@(vif.drv_cb);
vif.drv_cb.INP_VALID <= 2'b00;
end

  if(drv2dut.CE && drv2dut.MODE == 1'b1 &&
   (drv2dut.CMD == 4'b1001 || drv2dut.CMD == 4'b1010)) begin
  @(vif.drv_cb);   
end

vif.drv_cb.CE        <= 1'b0;
vif.drv_cb.OPA       <= '0;
vif.drv_cb.OPB       <= '0;
vif.drv_cb.INP_VALID <= 2'b00;
@(vif.drv_cb);

end
endtask

endclass

