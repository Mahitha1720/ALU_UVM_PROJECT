class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

uvm_tlm_analysis_fifo #(trans) in_mon_fifo;
uvm_tlm_analysis_fifo #(trans) out_mon_fifo;

trans inp_mon_xn;
trans out_mon_xn;

bit [`DW-1:0] oprd1;
bit [`DW-1:0] oprd2;
bit [`CW-1:0] cmd_reg;
bit mode_reg;
bit cin_reg;
bit opa_valid;
bit opb_valid;
int wait_cnt;

bit [`DW*2-1:0] exp_res;
bit exp_cout, exp_oflow, exp_g, exp_e, exp_l, exp_err;

localparam WAIT_TIMEOUT = 16;
localparam BASE_LATENCY = 1;
localparam MUL_LATENCY  = 3;
localparam MAX_LATENCY  = 3;

typedef struct packed {
  bit             valid;
  bit [`DW*2-1:0] res;
  bit             cout, oflow, g, e, l, err;
} res_t;

res_t pipe[MAX_LATENCY];

int pass_cnt;
int fail_cnt;
int total_cnt;


function new(string name="scoreboard", uvm_component parent);
  super.new(name,parent);
  in_mon_fifo  = new("in_mon_fifo",this);
  out_mon_fifo = new("out_mon_fifo",this);
endfunction

  task run_phase(uvm_phase phase);
  forever begin
    in_mon_fifo.get(inp_mon_xn);
    out_mon_fifo.get(out_mon_xn);
    ref_model(inp_mon_xn);
    check_Data(out_mon_xn);
  end
endtask


task ref_model(trans t);

  if(t.rst) begin
    oprd1 = 0; oprd2 = 0;
    cmd_reg = 0; mode_reg = 0; cin_reg = 0;
    opa_valid = 0; opb_valid = 0; wait_cnt = 0;
    foreach(pipe[i]) pipe[i] = '0;
    exp_res = 0; exp_cout = 0; exp_oflow = 0;
    exp_g = 0; exp_e = 0; exp_l = 0; exp_err = 0;
  end
  else if(t.CE) begin
    advance_pipe();
    capture_and_schedule(t);
  end

  drive_outputs(t);

endtask


task advance_pipe();
  if(pipe[0].valid) begin
    exp_res   = pipe[0].res;
    exp_cout  = pipe[0].cout;
    exp_oflow = pipe[0].oflow;
    exp_g     = pipe[0].g;
    exp_e     = pipe[0].e;
    exp_l     = pipe[0].l;
    exp_err   = pipe[0].err;
  end
  for(int i = 0; i < MAX_LATENCY-1; i++) pipe[i] = pipe[i+1];
  pipe[MAX_LATENCY-1] = '0;
endtask

  task capture_and_schedule(trans t);

  bit new_capture;
  res_t r;
  int slot;

  new_capture = 0;

  case(t.INP_VALID)
    2'b01: begin
      oprd1 = t.OPA; opa_valid = 1;
      cmd_reg = t.CMD; mode_reg = t.MODE; cin_reg = t.CIN;
      new_capture = 1;
    end
    2'b10: begin
      oprd2 = t.OPB; opb_valid = 1;
      cmd_reg = t.CMD; mode_reg = t.MODE; cin_reg = t.CIN;
      new_capture = 1;
    end
    2'b11: begin
      oprd1 = t.OPA; oprd2 = t.OPB;
      opa_valid = 1; opb_valid = 1;
      cmd_reg = t.CMD; mode_reg = t.MODE; cin_reg = t.CIN;
      new_capture = 1;
    end
    2'b00: begin
      opa_valid = 0; opb_valid = 0; wait_cnt = 0;
    end
  endcase

  if(opa_valid && opb_valid) begin
    wait_cnt = 0;

    if(new_capture) begin
      r = compute_alu(oprd1, oprd2, cmd_reg, mode_reg, cin_reg);
      slot = (mode_reg && (cmd_reg==4'b1001 || cmd_reg==4'b1010)) ?
             MUL_LATENCY-1 : BASE_LATENCY-1;
      pipe[slot] = r;
    end
  end
  else if(opa_valid || opb_valid) begin
    if(!new_capture) begin
      wait_cnt++;
      if(wait_cnt >= WAIT_TIMEOUT) begin
        exp_res=0; exp_cout=0; exp_oflow=0; exp_g=0; exp_e=0; exp_l=0; exp_err=1;
        opa_valid = 0; opb_valid = 0; wait_cnt = 0;
      end
    end
  end
  else begin
    wait_cnt = 0;
  end

endtask

  function res_t compute_alu(bit [`DW-1:0] a, bit [`DW-1:0] b,
                            bit [`CW-1:0] cmd, bit mode, bit cin);
  res_t r;
  bit [`DW+1:0] add_tmp, sub_tmp;
  bit [`DW-1:0] t1, t2, OPA_1, OPB_1;

  r = '0;
  r.valid = 1;

  if(mode) begin
    case(cmd)
      4'b0000: begin add_tmp = {2'b00,a}+{2'b00,b}; r.res=add_tmp; r.cout=add_tmp[`DW]; end
      4'b0001: begin sub_tmp = {2'b00,a}-{2'b00,b}; r.res=sub_tmp; r.oflow=(a<b); end
      4'b0010: begin add_tmp = {2'b00,a}+{2'b00,b}+cin; r.res=add_tmp; r.cout=add_tmp[`DW]; end
      4'b0011: begin sub_tmp = {2'b00,a}-{2'b00,b}-cin; r.res=sub_tmp; r.oflow=(a<b); end
      4'b0100: r.res = a + 1;
      4'b0101: r.res = a - 1;
      4'b0110: r.res = b + 1;
      4'b0111: r.res = b - 1;
      4'b1000: begin r.g=(a>b); r.e=(a==b); r.l=(a<b); end
      4'b1001: begin t1=a+1; t2=b+1; r.res = t1*t2; end
      4'b1010: begin t1=a<<1; t2=b;   r.res = t1*t2; end
    endcase
  end
  else begin
    case(cmd)
      4'b0000: r.res = a & b;
      4'b0001: r.res = ~(a & b);
      4'b0010: r.res = a | b;
      4'b0011: r.res = ~(a | b);
      4'b0100: r.res = a ^ b;
      4'b0101: r.res = ~(a ^ b);
      4'b0110: r.res = ~a;
      4'b0111: r.res = ~b;
      4'b1000: r.res = a >> 1;
      4'b1001: r.res = a << 1;
      4'b1010: r.res = b >> 1;
      4'b1011: r.res = b << 1;
      4'b1100: begin
        OPA_1 = b[0] ? {a[6:0],a[7]} : a;
        OPB_1 = b[1] ? {OPA_1[5:0],OPA_1[7:6]} : OPA_1;
        r.res = b[2] ? {OPB_1[3:0],OPB_1[7:4]} : OPB_1;
        if(b[7:4] != 0) r.err = 1;
      end
       4'b1101: begin
        OPA_1 = b[0] ? {a[0],a[7:1]} : a;
        OPB_1 = b[1] ? {OPA_1[1:0],OPA_1[7:2]} : OPA_1;
        r.res = b[2] ? {OPB_1[3:0],OPB_1[7:4]} : OPB_1;
        if(b[7:4] != 0) r.err = 1;
      end
    endcase
  end

  return r;
endfunction


task drive_outputs(trans t);
  t.RES = exp_res; t.COUT = exp_cout; t.OFLOW = exp_oflow;
  t.G = exp_g; t.E = exp_e; t.L = exp_l; t.ERR = exp_err;
endtask


task check_Data(trans ch);
  bit mismatch;
  mismatch = 0;
  total_cnt++;

  if(inp_mon_xn.RES   !== ch.RES)   mismatch = 1;
  if(inp_mon_xn.ERR   !== ch.ERR)   mismatch = 1;
  if(inp_mon_xn.COUT  !== ch.COUT)  mismatch = 1;
  if(inp_mon_xn.OFLOW !== ch.OFLOW) mismatch = 1;
  if(inp_mon_xn.G     !== ch.G)     mismatch = 1;
  if(inp_mon_xn.L     !== ch.L)     mismatch = 1;
  if(inp_mon_xn.E     !== ch.E)     mismatch = 1;

  if(mismatch) begin
    fail_cnt++;
    $display("\n============================================================");
    $display("FAIL @ %0t TXN=%0d MODE=%0b CMD=%0h CE=%0b CIN=%0b INP_VALID=%0b OPA=%0h OPB=%0h WAIT=%0d",$time,total_cnt,inp_mon_xn.MODE,inp_mon_xn.CMD,inp_mon_xn.CE,inp_mon_xn.CIN,inp_mon_xn.INP_VALID,inp_mon_xn.OPA,inp_mon_xn.OPB,inp_mon_xn.wait_cycle);
    $display("EXP: RES=%0h ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b",inp_mon_xn.RES,inp_mon_xn.ERR,inp_mon_xn.COUT,inp_mon_xn.OFLOW,inp_mon_xn.G,inp_mon_xn.E,inp_mon_xn.L);
    $display("ACT: RES=%0h ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b",ch.RES,ch.ERR,ch.COUT,ch.OFLOW,ch.G,ch.E,ch.L);
    $display("============================================================\n");
    `uvm_error(get_type_name(),"Scoreboard Comparison Failed")
  end
else begin
    pass_cnt++;
    $display("\nPASS @ %0t TXN=%0d MODE=%0b CMD=%0h CE=%0b CIN=%0b INP_VALID=%0b OPA=%0h OPB=%0h WAIT=%0d RES=%0h ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b",$time,total_cnt,inp_mon_xn.MODE,inp_mon_xn.CMD,inp_mon_xn.CE,inp_mon_xn.CIN,inp_mon_xn.INP_VALID,inp_mon_xn.OPA,inp_mon_xn.OPB,inp_mon_xn.wait_cycle,ch.RES,ch.ERR,ch.COUT,ch.OFLOW,ch.G,ch.E,ch.L);
  end
endtask


function void report_phase(uvm_phase phase);
  $display("\n============================================================");
  $display("SCOREBOARD SUMMARY: total=%0d pass=%0d fail=%0d", total_cnt, pass_cnt, fail_cnt);
  $display("============================================================\n");
  `uvm_info(get_type_name(), $sformatf("SCOREBOARD SUMMARY: total=%0d pass=%0d fail=%0d",total_cnt,pass_cnt,fail_cnt), UVM_NONE)
endfunction

endclass



