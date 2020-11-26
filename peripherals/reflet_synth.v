/*------------------------------------\
|Generate a frequency depending on a  |
|6 bit number to choose the tone and  |
|a 2 bits number to choose the volume.|
\------------------------------------*/

module reflet_synth_generator #(
    parameter clock_freq = 1000000
    )(
    input clk,
    input reset,
    input [1:0] volume,
    input [5:0] tone,
    output out
    );

    //Computing the number of time the 1 MHz clock must be divided and the duty cycle of the signal
    wire [13:0] divisor_map;
    wire [43:0] divisor = divisor_map * (clock_freq / 1000000);
    wire [43:0] duty = divisor >> volume;
    reflet_synth_div_map map(
        .clk(clk),
        .select(tone),
        .out(divisor_map));

    //Generating the signal with a PWM
    reflet_pwm_pwm #(.size(44)) pwm (
        .clk(clk),
        .reset(reset),
        .duty_cycle( |volume ? duty : 0),
        .max(divisor),
        .out(out));

endmodule
    


/*--------------------------------------------------------\
|Compute the divisor needed to reduced a 1 MHz signal to a|
|signal whose frequency is indicated in the comment.      |
\--------------------------------------------------------*/

module reflet_synth_div_map (
    input clk,
    input [5:0] select,
    output [13:0] out
    );
    
    reg [13:0] divisor;
    assign out = divisor;

    always @ (posedge clk)
        case(select)
            00 : divisor = 14431; // f = 69.2956577442181
            01 : divisor = 13621; // f = 73.416191979352
            02 : divisor = 12856; // f = 77.7817459305203
            03 : divisor = 12135; // f = 82.4068892282176
            04 : divisor = 11454; // f = 87.3070578582511
            05 : divisor = 10811; // f = 92.4986056779087
            06 : divisor = 10204; // f = 97.9988589954374
            07 : divisor = 9631;  // f = 103.826174394986
            08 : divisor = 9091;  // f = 110.0
            09 : divisor = 8581;  // f = 116.540940379523
            10 : divisor = 8099;  // f = 123.470825314031
            11 : divisor = 7645;  // f = 130.812782650299
            12 : divisor = 7215;  // f = 138.591315488436
            13 : divisor = 6810;  // f = 146.832383958704
            14 : divisor = 6428;  // f = 155.563491861041
            15 : divisor = 6067;  // f = 164.813778456435
            16 : divisor = 5727;  // f = 174.614115716502
            17 : divisor = 5405;  // f = 184.997211355817
            18 : divisor = 5102;  // f = 195.997717990875
            19 : divisor = 4816;  // f = 207.652348789973
            20 : divisor = 4545;  // f = 220.0
            21 : divisor = 4290;  // f = 233.081880759045
            22 : divisor = 4050;  // f = 246.941650628062
            23 : divisor = 3822;  // f = 261.625565300599
            24 : divisor = 3608;  // f = 277.182630976872
            25 : divisor = 3405;  // f = 293.664767917408
            26 : divisor = 3214;  // f = 311.126983722081
            27 : divisor = 3034;  // f = 329.62755691287
            28 : divisor = 2863;  // f = 349.228231433004
            29 : divisor = 2703;  // f = 369.994422711634
            30 : divisor = 2551;  // f = 391.995435981749
            31 : divisor = 2408;  // f = 415.304697579945
            32 : divisor = 2273;  // f = 440.0
            33 : divisor = 2145;  // f = 466.16376151809
            34 : divisor = 2025;  // f = 493.883301256124
            35 : divisor = 1911;  // f = 523.251130601197
            36 : divisor = 1804;  // f = 554.365261953744
            37 : divisor = 1703;  // f = 587.329535834815
            38 : divisor = 1607;  // f = 622.253967444162
            39 : divisor = 1517;  // f = 659.25511382574
            40 : divisor = 1432;  // f = 698.456462866008
            41 : divisor = 1351;  // f = 739.988845423269
            42 : divisor = 1276;  // f = 783.990871963499
            43 : divisor = 1204;  // f = 830.609395159891
            44 : divisor = 1136;  // f = 880.0
            45 : divisor = 1073;  // f = 932.32752303618
            46 : divisor = 1012;  // f = 987.766602512249
            47 : divisor = 956;   // f = 1046.50226120239
            48 : divisor = 902;   // f = 1108.73052390749
            49 : divisor = 851;   // f = 1174.65907166963
            50 : divisor = 804;   // f = 1244.50793488832
            51 : divisor = 758;   // f = 1318.51022765148
            52 : divisor = 716;   // f = 1396.91292573202
            53 : divisor = 676;   // f = 1479.97769084654
            54 : divisor = 638;   // f = 1567.981743927
            55 : divisor = 602;   // f = 1661.21879031978
            56 : divisor = 568;   // f = 1760.0
            57 : divisor = 536;   // f = 1864.65504607236
            58 : divisor = 506;   // f = 1975.5332050245
            59 : divisor = 478;   // f = 2093.00452240479
            60 : divisor = 451;   // f = 2217.46104781498
            61 : divisor = 426;   // f = 2349.31814333926
            62 : divisor = 402;   // f = 2489.01586977665
            63 : divisor = 379;   // f = 2637.02045530296
        endcase

endmodule

