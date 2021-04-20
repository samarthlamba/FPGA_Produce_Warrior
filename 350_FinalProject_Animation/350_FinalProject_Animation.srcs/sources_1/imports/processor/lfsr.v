module lfsr(out, clk);
    input clk;
    integer data_file; // file handler
    integer scan_file; // file handler
    reg signed [21:0] captured_data;
    output reg [7:0] out;
    `define NULL 0    
    
    initial begin 
      data_file = $fopen("C:/Users/samar/Desktop/Semester 6/ECE350Labs/ECE350_Final_Project/350_FinalProject_Animation/350_FinalProject_Animation.srcs/sources_1/imports/processor/randomFile.txt", "r");
      if (data_file == `NULL) begin
        $display("data_file handle was NULL"); 
        $finish;
      end
    end
    
    always @(posedge clk) begin
      scan_file = $fscanf(data_file, "%d\n", captured_data); 
      if (!$feof(data_file)) begin
        //use captured_data as you would any other wire or reg value;
           out <= captured_data[7:0];
           $display("data_file handle was here"); 
      end
    end

endmodule