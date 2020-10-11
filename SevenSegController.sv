`default_nettype none
module BCDtoSevenSegment 
    (input logic [3:0] bcd,
    output logic [6:0] segment);

    always_comb
        case (bcd)
            4'b0000: segment = 7'b100_0000; //0
            4'b0001: segment = 7'b111_1001; //1
            4'b0010: segment = 7'b010_0100; //2 
            4'b0011: segment = 7'b011_0000; //3
            4'b0100: segment = 7'b001_1001; //4
            4'b0101: segment = 7'b001_0010; //5
            4'b0110: segment = 7'b000_0010; //6
            4'b0111: segment = 7'b111_1000; //7
            4'b1000: segment = 7'b000_0000; //8
            4'b1001: segment = 7'b001_0000; //9
            default: segment = 7'b111_1111; //all off
    endcase
endmodule: BCDtoSevenSegment


//testbench for BCDtoSevenSegment
module BCDtoSevenSegment_test();
    logic [3:0] bcd;
    logic [6:0] segment;

    BCDtoSevenSegment bss(.bcd(bcd), .segment(segment));

   initial begin
   $monitor ($time,,
            "bcd = %b, sevenSegment = %b",
            bcd, segment);

        bcd = 4'b0000;
    #10 bcd = 4'b0100;
    #10 bcd = 4'b1001;
    #10 bcd = 4'b1111;
    #10 bcd = 4'b0011;

   end
endmodule : BCDtoSevenSegment_test



module SevenSegmentDigit 
    (input logic [3:0] bcd,
    output logic [6:0] segment, 
    input logic blank);

    logic [6:0] decoded;

    BCDtoSevenSegment b2ss(.bcd(bcd), .segment(decoded));
    
    always_comb begin
    if(blank)
        segment = 7'b111_1111;
    else
        segment = decoded;
    end
endmodule: SevenSegmentDigit



module SevenSegmentControl
    (output logic [6:0] HEX7, HEX6, HEX5, HEX4,
    output logic [6:0] HEX3, HEX2, HEX1, HEX0, 
    input logic [3:0] BCD7, BCD6, BCD5, BCD4, 
    input logic [3:0] BCD3, BCD2, BCD1, BCD0, 
    input logic [7:0] turn_on);

    SevenSegmentDigit(.bcd(BCD0), .blank(turn_on[0]), .segment(HEX0));
    SevenSegmentDigit(.bcd(BCD1), .blank(turn_on[1]), .segment(HEX1));
    SevenSegmentDigit(.bcd(BCD2), .blank(turn_on[2]), .segment(HEX2));
    SevenSegmentDigit(.bcd(BCD3), .blank(turn_on[3]), .segment(HEX3));
    SevenSegmentDigit(.bcd(BCD4), .blank(turn_on[4]), .segment(HEX4));
    SevenSegmentDigit(.bcd(BCD5), .blank(turn_on[5]), .segment(HEX5));
    SevenSegmentDigit(.bcd(BCD6), .blank(turn_on[6]), .segment(HEX6));
    SevenSegmentDigit(.bcd(BCD7), .blank(turn_on[7]), .segment(HEX7));
endmodule: SevenSegmentControl


//top module
module ChipInterface
    (output logic [6:0] HEX7, HEX6, HEX5, HEX4, 
                        HEX3, HEX2, HEX1, HEX0,
    input logic [17:0] SW, 
    input logic [3:0] KEY);
    
    logic [3:0] t0, t1, t2, t3, t4, t5, t6, t7;

    SevenSegmentControl ssc(.HEX7(HEX7), 
                            .HEX6(HEX6),
                            .HEX5(HEX5), 
                            .HEX4(HEX4),
                            .HEX3(HEX3), 
                            .HEX2(HEX2),
                            .HEX1(HEX1), 
                            .HEX0(HEX0),
                            .BCD7(t7), 
                            .BCD6(t6), 
                            .BCD5(t5), 
                            .BCD4(t4),
                            .BCD3(t3), 
                            .BCD2(t2),
                            .BCD1(t1),
                            .BCD0(t0),
                            .turn_on(SW[17:10]));

    assign t0 = (~KEY[2:0] == 3'd0) ? SW[3:0] : SW[7:4];
    assign t1 = (~KEY[2:0] == 3'd1) ? SW[3:0] : SW[7:4];
    assign t2 = (~KEY[2:0] == 3'd2) ? SW[3:0] : SW[7:4];
    assign t3 = (~KEY[2:0] == 3'd3) ? SW[3:0] : SW[7:4];
    assign t4 = (~KEY[2:0] == 3'd4) ? SW[3:0] : SW[7:4];
    assign t5 = (~KEY[2:0] == 3'd5) ? SW[3:0] : SW[7:4];
    assign t6 = (~KEY[2:0] == 3'd6) ? SW[3:0] : SW[7:4];
    assign t7 = (~KEY[2:0] == 3'd7) ? SW[3:0] : SW[7:4];
endmodule: ChipInterface


