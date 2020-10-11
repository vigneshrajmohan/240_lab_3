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
    ScoreThis = 1'b1;
    #10 X = 4'b0000;
    #10 X = 4'b1010;
    #10 X = 4'b1111;
    #10 X = 4'b0011;
    Y = 4'b0000;
    #10 Y = 4'b1010;
    #10 Y = 4'b1111;
    #10 Y = 4'b0011;
    BigLeft = 2'b11;
    #10 BigLeft = 2'b00;
    Big = 1'b1;
    #10 BigLeft = 2'b01;
    #10 ScoreThis = 1'b0;
    BigLeft = 2'b00;
    #10 Big = 1'b0;
    BigLeft = 2'b11;
    #10 BigLeft = 2'b10;
    X = 4'b1110;
    #10 X = 4'b0110;
    Y = 4'b1100;
    #10 $finish;
  end

endmodule: isWrongTester

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
    Hit = 1'b0;
    #10 Y = 4'd2;
    Hit = 1'b1;
    #10 Y = 4'd4;
    Hit = 1'b0;
    #10 X = 4'd6;
    #10 Y = 4'd1;
    #10 X = 4'd8;
    #10 Y = 4'd6;
    Hit = 1'b1;
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
        else if (patrol1 | patrol2) BiggestShipHit = 5'b00001;
        else BiggestShipHit = 5'b00000;
    end

endmodule: shipHit


module shiphit_test();

    logic [3:0] X, Y;
    logic [4:0] BiggestShipHit;
    shipHit dut (.*);

  initial begin
    $monitor("X: %h, Y: %h, BiggestShip: %b", X, Y, BiggestShipHit);
       X = 4'b0011; Y = 4'b0011;
    #5 X = 4'b0011; Y = 4'b0010;
    #5 X = 4'b0100; Y = 4'b0001;
    #5 X = 4'b0010; Y = 4'b1001;
    #5 X = 4'b0111; Y = 4'b0110;
    #5 X = 4'b1001; Y = 4'b0001;
    #5 X = 4'b0001; Y = 4'b0001;
    #5 $finish;
  end

endmodule : shiphit_test




module isHit
  (input logic [3:0] X, Y,
   input logic [3:0] CurrHits,
  output logic Hit, nearMiss, Miss,
  output logic [4:0] BiggestShipHit,
  output logic [3:0] TotalHits,
  output logic [6:0] numHits);

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
    if (Hit) TotalHits[3:0] = CurrHits[3:0] + 1;
    else TotalHits[3:0] = CurrHits[3:0];
  end

endmodule: isHit

module isHitTester ();
  logic [3:0] X, Y, CurrHits,
  logic Hit, nearMiss, Miss,
  logic [4:0] BiggestShipHit,
  logic [3:0] TotalHits
  logic [6:0] numHits);

  initial begin
    $monitor($time, " X = %d, Y %d, CurrHits = %d, Hit = %b, nearMiss = %b, \
             Miss = %b, TotalHits = %d, numHits = %d, BiggestShipHit = %b", 
             X, Y, CurrHits, Hit, nearMiss, Miss, TotalHits, 
             numHits, BiggestShipHit);
    X = 4'b0001;
    Y = 4'b0001;
    CurrHits = 4'b0000;
    #10 
  end

endmodule: isHitTester