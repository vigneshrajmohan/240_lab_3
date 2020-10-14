`default_nettype none

module isWrong
  (input logic [3:0] X, Y,
   input logic [1:0] BigLeft,
   input logic ScoreThis, Big,
   output logic SomethingIsWrong);

  logic XInvalid, YInvalid, BigLeftInvalid, BigInvalid;

  always_comb
    unique case (X [3:0])
    4'b1111: XInvalid = 1'b1;
    4'b1110: XInvalid = 1'b1;
    4'b1101: XInvalid = 1'b1;
    4'b1100: XInvalid = 1'b1;
    4'b1011: XInvalid = 1'b1;
    4'b0000: XInvalid = 1'b1;
    default: XInvalid = 1'b0;
  endcase

  always_comb
    unique case (Y [3:0])
    4'b1111: YInvalid = 1'b1;
    4'b1110: YInvalid = 1'b1;
    4'b1101: YInvalid = 1'b1;
    4'b1100: YInvalid = 1'b1;
    4'b1011: YInvalid = 1'b1;
    4'b0000: YInvalid = 1'b1;
    default: YInvalid = 1'b0;
  endcase

assign BigLeftInvalid = BigLeft[1:0] == 2'b11;

assign BigInvalid = Big && BigLeft[1:0] == 2'b00;

assign SomethingIsWrong = ScoreThis && (XInvalid || YInvalid ||
                          BigLeftInvalid || BigInvalid);

endmodule: isWrong

module isWrongTester ();
  logic [3:0] X, Y;
  logic [1:0] BigLeft;
  logic Big, ScoreThis, SomethingIsWrong;

  isWrong dut(.*);

  initial begin
    $monitor ($time, " X = %b, Y = %b, BigLeft = %b, Big = %b, ScoreThis = %b \
              SomethingIsWrong = %b", X, Y, BigLeft, Big, ScoreThis, SomethingIsWrong);
    X = 4'b0001;
    Y = 4'b0001;
    BigLeft = 2'b01;
    Big = 1'b0;
    ScoreThis = 1'b1; //0
    #10 X = 4'b0000;  //1
    #10 X = 4'b1010;  //0
    #10 X = 4'b1111;  //1
    #10 X = 4'b0011; 
    Y = 4'b0000;      //1
    #10 Y = 4'b1010;  //0
    #10 Y = 4'b1111;  //1
    #10 Y = 4'b0011;  
    BigLeft = 2'b11;  //1
    #10 BigLeft = 2'b00; 
    Big = 1'b1;       //1
    #10 BigLeft = 2'b01; //0
    #10 ScoreThis = 1'b0; 
    BigLeft = 2'b00;  //0
    #10 Big = 1'b0;   
    BigLeft = 2'b11;  //0
    #10 BigLeft = 2'b10;
    X = 4'b1110;      //0
    #10 X = 4'b0110;
    Y = 4'b1100;     //0
    #10 $finish;
  end

endmodule: isWrongTester

module BCDtoSevenSegment 
    (input logic [3:0] TotalHits,
    output logic [6:0] numHits);

    always_comb
        case (TotalHits)
            4'b0000: numHits = 7'b100_0000; //0
            4'b0001: numHits = 7'b111_1001; //1
            4'b0010: numHits = 7'b010_0100; //2 
            4'b0011: numHits = 7'b011_0000; //3
            4'b0100: numHits = 7'b001_1001; //4
            4'b0101: numHits = 7'b001_0010; //5
            4'b0110: numHits = 7'b000_0010; //6
            4'b0111: numHits = 7'b111_1000; //7
            4'b1000: numHits = 7'b000_0000; //8
            4'b1001: numHits = 7'b001_0000; //9
            default: numHits = 7'b111_1111; //all off
    endcase
endmodule: BCDtoSevenSegment

module BCDtoSevenSegment_test();
    logic [3:0] TotalHits;
    logic [6:0] numHits;

    BCDtoSevenSegment bss(.TotalHits(TotalHits), .numHits(numHits));

   initial begin
   $monitor ($time,,
            "bcd = %b, sevenSegment = %b",
            TotalHits, numHits);

        TotalHits = 4'b0000; //0
    #10 TotalHits = 4'b0100; //4
    #10 TotalHits = 4'b1001; //9
    #10 TotalHits = 4'b1111; //invalid
    #10 TotalHits = 4'b0011; //3

   end
endmodule : BCDtoSevenSegment_test

module typeMiss
  (input logic [3:0] X, Y,
   input logic Hit,
  output logic nearMiss, Miss);

  always_comb 
    unique case ({X, Y})
      8'b0001_0001: nearMiss = 1'b1;
      8'b0001_0101: nearMiss = 1'b1;
      8'b0001_1000: nearMiss = 1'b1;
      8'b0001_1001: nearMiss = 1'b1;
      8'b0001_1010: nearMiss = 1'b1;
      8'b0010_0100: nearMiss = 1'b1;
      8'b0010_0111: nearMiss = 1'b1;
      8'b0011_0100: nearMiss = 1'b1;
      8'b0011_1000: nearMiss = 1'b1;
      8'b0011_1001: nearMiss = 1'b1;
      8'b0011_1010: nearMiss = 1'b1;
      8'b0100_0100: nearMiss = 1'b1;
      8'b0101_0001: nearMiss = 1'b1;
      8'b0101_0010: nearMiss = 1'b1;
      8'b0101_0100: nearMiss = 1'b1;
      8'b0110_0010: nearMiss = 1'b1;
      8'b0110_0100: nearMiss = 1'b1;
      8'b0110_0110: nearMiss = 1'b1;
      8'b0111_0011: nearMiss = 1'b1;
      8'b0111_0101: nearMiss = 1'b1;
      8'b0111_0111: nearMiss = 1'b1;
      8'b1000_0001: nearMiss = 1'b1;
      8'b1000_0101: nearMiss = 1'b1;
      8'b1000_0111: nearMiss = 1'b1;
      8'b1001_0010: nearMiss = 1'b1;
      8'b1001_0110: nearMiss = 1'b1;
      8'b1010_0010: nearMiss = 1'b1;
      default: nearMiss = 1'b0;
    endcase

  assign Miss = !(Hit || nearMiss);

endmodule: typeMiss

module typeMissTester ();
  logic [3:0] X, Y;
  logic Hit, nearMiss, Miss;

  typeMiss dut(.*);

  initial begin
    $monitor($time, " X = %d, Y = %d, Hit = %b, nearMiss = %b, Miss = %b", 
             X, Y, Hit, nearMiss, Miss);
    X = 4'd1;
    Y = 4'd1;
    Hit = 1'b0; //nearMiss
    #10 Y = 4'd2;
    Hit = 1'b1; //Hit
    #10 Y = 4'd4;
    Hit = 1'b0; //Miss
    #10 X = 4'd6; //nearMiss
    #10 Y = 4'd1; //Miss
    #10 X = 4'd8; //nearMiss
    #10 Y = 4'd6; 
    Hit = 1'b1; //Hit
    #10 $finish;
  end

endmodule: typeMissTester



module shipHit
    (input logic [3:0] X, Y,
     output logic [4:0] BiggestShipHit);

    logic patrol1, patrol2, battleship, aircraft_c, sub, cruiser;
    
    always_comb 
        unique case ({X, Y})
            8'b0111_0110: patrol1 = 1'b1;
            8'b1000_0110: patrol1 = 1'b1;
            default: patrol1 = 1'b0;
        endcase

    always_comb 
        unique case ({X, Y})
            8'b1001_0001: patrol2 = 1'b1;
            8'b1010_0001: patrol2 = 1'b1;
            default: patrol2 = 1'b0;
        endcase

    always_comb 
        unique case ({X, Y})
            8'b0010_0011: aircraft_c = 1'b1;
            8'b0011_0011: aircraft_c = 1'b1;
            8'b0100_0011: aircraft_c = 1'b1;
            8'b0101_0011: aircraft_c = 1'b1;
            8'b0110_0011: aircraft_c = 1'b1;
            default: aircraft_c = 1'b0;
        endcase

    always_comb 
        unique case ({X, Y})
            8'b0001_0010: battleship = 1'b1;
            8'b0010_0010: battleship = 1'b1;
            8'b0011_0010: battleship = 1'b1;
            8'b0100_0010: battleship = 1'b1;
            default: battleship = 1'b0;
        endcase

    always_comb 
        unique case ({X, Y})
            8'b0010_0001: cruiser = 1'b1;
            8'b0011_0001: cruiser = 1'b1;
            8'b0100_0001: cruiser = 1'b1;
            default: cruiser = 1'b0;
        endcase

    always_comb 
        unique case ({X, Y})
            8'b0010_1000: sub = 1'b1;
            8'b0010_1001: sub = 1'b1;
            8'b0010_1010: sub = 1'b1;
            default: sub = 1'b0;
        endcase

    always_comb begin 
        if (aircraft_c) BiggestShipHit = 5'b10000;
        else if (battleship) BiggestShipHit = 5'b01000;
        else if (cruiser) BiggestShipHit = 5'b00100;
        else if (sub) BiggestShipHit = 5'b00010;
        else if (patrol1 || patrol2) BiggestShipHit = 5'b00001;
        else BiggestShipHit = 5'b00000;
    end

endmodule: shipHit


module shiphit_test();

    logic [3:0] X, Y;
    logic [4:0] CurrBiggest;
    logic [4:0] BiggestShipHit;
    shipHit dut (.*);

  initial begin
    $monitor("X: %d, Y: %d, BiggestShip: %b", X, Y, BiggestShipHit);
       X = 4'b0011; Y = 4'b0011; //Aircraft_C
    #5 X = 4'b0011; Y = 4'b0010; //Battleship
    #5 X = 4'b0100; Y = 4'b0001; //Cruiser
    #5 X = 4'b0010; Y = 4'b1001; //Sub
    #5 X = 4'b0111; Y = 4'b0110; //Patrol
    #5 X = 4'b1001; Y = 4'b0001; //Patrol
    #5 X = 4'b0001; Y = 4'b0001; //No Ship
    #5 $finish;
  end

endmodule : shiphit_test




module isHit
  (input logic [3:0] X, Y,
  output logic Hit, nearMiss, Miss,
  output logic [4:0] BiggestShipHit);
 
  typeMiss TypeMiss(.*);

  shipHit ShipHit(.*);

  always_comb begin
    unique case({X, Y})
      8'b0001_0010: Hit = 1'b1;
      8'b0010_0001: Hit = 1'b1;
      8'b0010_0010: Hit = 1'b1;
      8'b0010_0011: Hit = 1'b1;
      8'b0010_1000: Hit = 1'b1;
      8'b0010_1001: Hit = 1'b1;
      8'b0010_1010: Hit = 1'b1;
      8'b0011_0001: Hit = 1'b1;
      8'b0011_0010: Hit = 1'b1;
      8'b0011_0011: Hit = 1'b1;
      8'b0100_0001: Hit = 1'b1;
      8'b0100_0010: Hit = 1'b1;
      8'b0100_0011: Hit = 1'b1;
      8'b0101_0011: Hit = 1'b1;
      8'b0110_0011: Hit = 1'b1;
      8'b0111_0110: Hit = 1'b1;
      8'b1000_0110: Hit = 1'b1;
      8'b1001_0001: Hit = 1'b1;
      8'b1010_0001: Hit = 1'b1;
      default: Hit = 1'b0;
    endcase
  end

endmodule: isHit

module isHitTester ();
  logic [3:0] X, Y;
  logic Hit, nearMiss, Miss;
  logic [4:0] BiggestShipHit;

  isHit IsHit(.*);

  initial begin
    $monitor($time, " X = %d, Y %d, Hit = %b, nearMiss = %b, Miss = %b, BiggestShipHit = %b", 
             X, Y, Hit, nearMiss, Miss, BiggestShipHit);
    X = 4'b0001;
    Y = 4'b0001; //nearMiss
    #10 Y = 4'b0010; //Hit Battleship
    #10 X = 4'b1001; //nearMiss
    #10 Y = 4'b0001; //Hit Patrol
    #10 X = 4'b1010;
    Y = 4'b1010; //Miss
    #10 $finish;
  end

endmodule: isHitTester

module isBomb 
  (input logic [3:0] X, Y,
   input logic [1:0] BigLeft,
   input logic Big, ScoreThis,
  output logic [6:0] numHits,
  output logic [4:0] BiggestShipHit,
  output logic Hit, nearMiss, Miss, SomethingIsWrong);

  logic [3:0] XLo, XHi, YLo, YHi, TotalHits;
  logic Hit1, Hit2, Hit3, Hit4, Hit5, Hit6, Hit7, Hit8, Hit9;
  logic Miss1, Miss2, Miss3, Miss4, Miss5, Miss6, Miss7, Miss8, Miss9;
  logic nearMiss1, nearMiss2, nearMiss3, nearMiss4, nearMiss5;
  logic nearMiss6, nearMiss7, nearMiss8, nearMiss9;
  logic [4:0] BiggestShipHit1, BiggestShipHit2, BiggestShipHit3, BiggestShipHit4;
  logic [4:0] BiggestShipHit5, BiggestShipHit6, BiggestShipHit7, BiggestShipHit8, BiggestShipHit9;

  isWrong IsWrong(.*);

  always_comb begin
    if (Big) begin
      XLo = X - 1;
      XHi = X + 1;
      YLo = X - 1;
      YHi = Y + 1;
    end
    else begin
      XLo = 3'd0;
      XHi = 3'd0;
      YLo = 3'd0;
      YHi = 3'd0;
    end
  end

  isHit isHit1(.X(XLo), .Y(YLo), .Hit(Hit1), .nearMiss(nearMiss1), .Miss(Miss1),  
               .BiggestShipHit(BiggestShipHit1));
  isHit isHit2(.X(XLo), .Y(Y), .Hit(Hit2), .nearMiss(nearMiss2), .Miss(Miss2),  
               .BiggestShipHit(BiggestShipHit2));
  isHit isHit3(.X(XLo), .Y(YHi), .Hit(Hit3), .nearMiss(nearMiss3), .Miss(Miss3),  
               .BiggestShipHit(BiggestShipHit3));
  isHit isHit4(.X(X), .Y(YLo), .Hit(Hit4), .nearMiss(nearMiss4), .Miss(Miss4),  
               .BiggestShipHit(BiggestShipHit4));
  isHit isHit5(.X(X), .Y(Y), .Hit(Hit5), .nearMiss(nearMiss5), .Miss(Miss5),  
               .BiggestShipHit(BiggestShipHit5));
  isHit isHit6(.X(X), .Y(YHi), .Hit(Hit6), .nearMiss(nearMiss6), .Miss(Miss6),  
               .BiggestShipHit(BiggestShipHit6));
  isHit isHit7(.X(XHi), .Y(YLo), .Hit(Hit7), .nearMiss(nearMiss7), .Miss(Miss7),  
               .BiggestShipHit(BiggestShipHit7));
  isHit isHit8(.X(XHi), .Y(Y), .Hit(Hit8), .nearMiss(nearMiss8), .Miss(Miss8),  
               .BiggestShipHit(BiggestShipHit8));
  isHit isHit9(.X(XHi), .Y(YHi), .Hit(Hit9), .nearMiss(nearMiss9), .Miss(Miss9), 
               .BiggestShipHit(BiggestShipHit9));

  always_comb begin
    TotalHits = 4'b0000;
    if (Hit1) TotalHits += 1;
    if (Hit2) TotalHits += 1;
    if (Hit3) TotalHits += 1;
    if (Hit4) TotalHits += 1;
    if (Hit5) TotalHits += 1;
    if (Hit6) TotalHits += 1;
    if (Hit7) TotalHits += 1;
    if (Hit8) TotalHits += 1;
    if (Hit9) TotalHits += 1;
  end

  always_comb begin
    BiggestShipHit = BiggestShipHit1;
    if (BiggestShipHit < BiggestShipHit2) BiggestShipHit = BiggestShipHit2;
    if (BiggestShipHit < BiggestShipHit3) BiggestShipHit = BiggestShipHit3;
    if (BiggestShipHit < BiggestShipHit4) BiggestShipHit = BiggestShipHit4;
    if (BiggestShipHit < BiggestShipHit5) BiggestShipHit = BiggestShipHit5;
    if (BiggestShipHit < BiggestShipHit6) BiggestShipHit = BiggestShipHit6;
    if (BiggestShipHit < BiggestShipHit7) BiggestShipHit = BiggestShipHit7;
    if (BiggestShipHit < BiggestShipHit8) BiggestShipHit = BiggestShipHit8;
    if (BiggestShipHit < BiggestShipHit9) BiggestShipHit = BiggestShipHit9;
  end

  BCDtoSevenSegment BCD2SevenSegment(.*);

endmodule: isBomb