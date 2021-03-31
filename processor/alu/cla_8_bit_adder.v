module cla_8_bit_adder(sum, big_P, big_G, A, B, cin);

    input [7:0] A, B;
    input cin;
    output [7:0] sum;
    output big_P, big_G;
    wire [7:0] p, g, pc,c;
    wire big_G_parts[7:0];

    assign c[0] = cin;

    and g_values0(g[0], A[0], B[0]);
    and g_values1(g[1], A[1], B[1]);
    and g_values2(g[2], A[2], B[2]);
    and g_values3(g[3], A[3], B[3]);
    and g_values4(g[4], A[4], B[4]);
    and g_values5(g[5], A[5], B[5]);
    and g_values6(g[6], A[6], B[6]);
    and g_values7(g[7], A[7], B[7]);

    or p_values0(p[0], A[0], B[0]);
    or p_values1(p[1], A[1], B[1]);
    or p_values2(p[2], A[2], B[2]);
    or p_values3(p[3], A[3], B[3]);
    or p_values4(p[4], A[4], B[4]);
    or p_values5(p[5], A[5], B[5]);
    or p_values6(p[6], A[6], B[6]);
    or p_values7(p[7], A[7], B[7]);

    and pc_values0(pc[0], p[0], c[0]);
    and pc_values1(pc[1], p[1], c[1]);
    and pc_values2(pc[2], p[2], c[2]);
    and pc_values3(pc[3], p[3], c[3]);
    and pc_values4(pc[4], p[4], c[4]);
    and pc_values5(pc[5], p[5], c[5]);
    and pc_values6(pc[6], p[6], c[6]);
    and pc_values7(pc[7], p[7], c[7]);

    or c_values0(c[1], g[0], pc[0]);
    or c_values1(c[2], g[1], pc[1]);
    or c_values2(c[3], g[2], pc[2]);
    or c_values3(c[4], g[3], pc[3]);
    or c_values4(c[5], g[4], pc[4]);
    or c_values5(c[6], g[5], pc[5]);
    or c_values6(c[7], g[6], pc[6]);
    
    xor sum_calc0(sum[0], A[0], B[0], c[0]);
    xor sum_calc1(sum[1], A[1], B[1], c[1]);
    xor sum_calc2(sum[2], A[2], B[2], c[2]);
    xor sum_calc3(sum[3], A[3], B[3], c[3]);
    xor sum_calc4(sum[4], A[4], B[4], c[4]);
    xor sum_calc5(sum[5], A[5], B[5], c[5]);
    xor sum_calc6(sum[6], A[6], B[6], c[6]);
    xor sum_calc7(sum[7], A[7], B[7], c[7]);

    and bigGValues1(big_G_parts[6],p[7], g[6]);
    and bigGValues2(big_G_parts[5],p[7], p[6], g[5]);
    and bigGValues3(big_G_parts[4],p[7], p[6], p[5], g[4]);
    and bigGValues4(big_G_parts[3],p[7], p[6], p[5], p[4], g[3]);
    and bigGValues5(big_G_parts[2],p[7], p[6], p[5], p[4], p[3], g[2]);
    and bigGValues6(big_G_parts[1],p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and bigGValues7(big_G_parts[0],p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);

    or big_G_calc(big_G, g[7],big_G_parts[6],big_G_parts[5],big_G_parts[4],big_G_parts[3],big_G_parts[2],big_G_parts[1],big_G_parts[0]);

        
    and big_P_calc(big_P, p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);
        


endmodule