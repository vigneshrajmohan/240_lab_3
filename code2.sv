`default_nettype none

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