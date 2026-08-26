//1
class seq extends uvm_sequence #(trans);
`uvm_object_utils(seq)

function new(string name="seq");
super.new(name);
endfunction

task body();
req=trans::type_id::create("req");
repeat(1000)
begin
start_item(req);
assert(req.randomize());
finish_item(req);
end
endtask
endclass


//2
class seq_add extends uvm_sequence #(trans);
`uvm_object_utils(seq_add)

function new(string name="seq_add");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==4'b0000;});
finish_item(req);
end
endtask
endclass

//3
class seq_sub extends uvm_sequence #(trans);
`uvm_object_utils(seq_sub)

function new(string name="seq_sub");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1; CMD==4'b0001;});
finish_item(req);
end
endtask
endclass


//4
class seq_add_cin extends uvm_sequence #(trans);
`uvm_object_utils(seq_add_cin)

function new(string name="seq_add_cin");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==2; CIN==1;});
finish_item(req);
end
endtask
endclass

//5
class seq_sub_cin extends uvm_sequence #(trans);
`uvm_object_utils(seq_sub_cin)

function new(string name="seq_sub_cin");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==3; CIN==1;});
finish_item(req);
end
endtask
endclass




//6
class seq_inc_dec extends uvm_sequence #(trans);
`uvm_object_utils(seq_inc_dec)

function new(string name="seq_inc_dec");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD inside {[4:7]};});
finish_item(req);
end
endtask
endclass

//7
class seq_comp extends uvm_sequence #(trans);
`uvm_object_utils(seq_comp)

function new(string name="seq_comp");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==8;});
finish_item(req);
end
endtask
endclass



//8
class seq_mul_inc extends uvm_sequence #(trans);
`uvm_object_utils(seq_mul_inc)

function new(string name="seq_mul_inc");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==9;});
finish_item(req);
end
endtask
endclass

//9
class seq_mul_shl extends uvm_sequence #(trans);
`uvm_object_utils(seq_mul_shl)

function new(string name="seq_mul_shl");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b1;CE==1;CMD==10;});
finish_item(req);
end
endtask
endclass



//10
class seq_logical extends uvm_sequence #(trans);
`uvm_object_utils(seq_logical)

function new(string name="seq_logical");
super.new(name);
endfunction

task body();
req = trans::type_id::create("req");
repeat(50)
begin
for(int i=0; i<14; i++) begin
start_item(req);
assert(req.randomize() with { MODE==0;CE==1; CMD==i;});
finish_item(req);
end
end
endtask
endclass


//11
class seq_wait extends uvm_sequence #(trans);
`uvm_object_utils(seq_wait)
function new(string name="seq_wait"); super.new(name); endfunction
task body();
  req = trans::type_id::create("req");
  repeat(50) begin
    start_item(req);
    assert(req.randomize() with {
      wait_cycle == 10;CE==1;
      INP_VALID inside {2'b01, 2'b10};
    });
    finish_item(req);
  end
endtask
endclass



//12
class seq_timeout extends uvm_sequence #(trans);
`uvm_object_utils(seq_timeout)

function new(string name="seq_timeout");
super.new(name);
endfunction

task body();
req= trans::type_id::create("req");
repeat(50)
begin
start_item(req);
req.c7.constraint_mode(0);
assert(req.randomize() with {wait_cycle==17;CE==1; INP_VALID inside {2'b01,2'b10};});
finish_item(req);
end
endtask
endclass

//13
class err_seq extends uvm_sequence #(trans);
`uvm_object_utils(err_seq)

 function new(string name="err_seq");
super.new(name);
 endfunction

task body();
req=trans::type_id::create("req");
repeat(50)
begin
start_item(req);
assert(req.randomize() with {MODE==1'b0;CE==1;CMD==4'b1100;OPA=='d100;OPB=='b10000001;});
finish_item(req);
end
endtask
endclass



//14
class seq_equal extends uvm_sequence #(trans);
  `uvm_object_utils(seq_equal)
  function new(string name="seq_equal");
    super.new(name);
  endfunction
  task body();
    repeat(5) begin
      req = trans::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {MODE==1; CMD==4'b1000; OPA==OPB; CE==1; INP_VALID==2'b11;});
      finish_item(req);
    end
  endtask
endclass


//15
class seq_timing extends uvm_sequence #(trans);
`uvm_object_utils(seq_timing)

function new(string name="seq_timing");
super.new(name);
endfunction

task body();
req = trans::type_id::create("req");
start_item(req);
assert(req.randomize() with {INP_VALID==2'b01; CE==1;});
finish_item(req);

repeat(18) begin
req = trans::type_id::create("req");
start_item(req);
assert(req.randomize() with {INP_VALID==2'b00; CE==1;});
finish_item(req);
end

req = trans::type_id::create("req");
start_item(req);
assert(req.randomize() with {INP_VALID==2'b10; CE==1;});
finish_item(req);

repeat(18) begin
req = trans::type_id::create("req");
start_item(req);
assert(req.randomize() with {INP_VALID==2'b00; CE==1;});
finish_item(req);
end
endtask
endclass



