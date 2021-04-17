module refcount(input refclk, output reg[1:0] refcounts = 0);


always@(posedge refclk) refcounts <= refcounts + 1;


endmodule