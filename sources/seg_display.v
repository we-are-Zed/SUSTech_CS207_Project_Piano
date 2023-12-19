module seg_display(
    input clk, rst_n,
    input[3:0] p0, p1, p2, p3, p4, p5, p6, p7,
    output reg [7:0] seg_en,
    output [7:0] seg_out0, seg_out1
    );

    reg clkout;
    reg[31:0] cnt;
    reg[3:0] scan_cnt, seg_in0, seg_in1;
    parameter period = 200000;

    light_7seg light_seg0(.seg_in(seg_in0), .seg_out(seg_out0));
    light_7seg light_seg1(.seg_in(seg_in1), .seg_out(seg_out1));

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            clkout <= 0;
            cnt <= 0;
        end
        else begin
            if (cnt == (period >> 1) - 1) begin
                clkout <= ~clkout;
                cnt <= 32'd0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(posedge clkout, negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 0;
        end else begin
            if (scan_cnt == 3'd7) begin
                scan_cnt <= 0;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end

    always @(scan_cnt) begin
        case (scan_cnt)
            3'b000: begin seg_en <= 8'b00000001; seg_in0 <= p0; seg_in1 <= p0; end
            3'b001: begin seg_en <= 8'b00000010; seg_in0 <= p1; seg_in1 <= p1; end
            3'b010: begin seg_en <= 8'b00000100; seg_in0 <= p2; seg_in1 <= p2; end
            3'b011: begin seg_en <= 8'b00001000; seg_in0 <= p3; seg_in1 <= p3; end
            3'b100: begin seg_en <= 8'b00010000; seg_in0 <= p4; seg_in1 <= p4; end
            3'b101: begin seg_en <= 8'b00100000; seg_in0 <= p5; seg_in1 <= p5; end
            3'b110: begin seg_en <= 8'b01000000; seg_in0 <= p6; seg_in1 <= p6; end
            3'b111: begin seg_en <= 8'b10000000; seg_in0 <= p7; seg_in1 <= p7; end
            default: seg_en <= 8'b00000000;
        endcase
    end
endmodule