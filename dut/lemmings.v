module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    reg [2:0] state,next;
    parameter LEFT=0,RIGHT=1,DIG_L=2,DIG_R=3,FALL_L=4,FALL_R=5,SPLAT=6;
    reg [7:0] a;
    
    always@(posedge clk, negedge areset)
        begin
            if(!areset)
                a<=0;
            else if(next == FALL_L | next == FALL_R)
                a<=a+8'd1;
            else
                a<=0;
        end
    
    always@(posedge clk, negedge areset)
        begin
            if(!areset)
                state<=LEFT;
            else
                state<=next;
        end
    
    always@(*)
        begin
            case(state)
                LEFT:
                    begin
                        case({bump_left,ground,dig})
                            3'b110:next<=RIGHT;
                            3'b011:next<=DIG_L;
                            3'b111:next<=DIG_L;
                            3'b000:next<=FALL_L;
                            3'b001:next<=FALL_L;
                            3'b100:next<=FALL_L;
                            3'b101:next<=FALL_L;
                            default:next<=LEFT;
                        endcase
                    end
                RIGHT:
                    begin
                        case({bump_right,ground,dig})
                            3'b110:next<=LEFT;
                            3'b011:next<=DIG_R;
                            3'b111:next<=DIG_R;
                            3'b000:next<=FALL_R;
                            3'b001:next<=FALL_R;
                            3'b100:next<=FALL_R;
                            3'b101:next<=FALL_R;
                            default:next<=RIGHT;
                        endcase
                    end
                DIG_L:
                    begin
                        next<=ground?DIG_L:FALL_L;
                    end
                DIG_R:
                    begin
                        next<=ground?DIG_R:FALL_R;
                    end
                FALL_L:
                    begin
                        if(ground)
                            begin
                                if(a>20)
                                    next<=SPLAT;
                                else
                            		next<=LEFT;
                            end
                        else
                            next<=FALL_L;
                    end
                FALL_R:
                    begin
                        if(ground)
                            begin
                                if(a>20)
                                    next<=SPLAT;
                                else
                            		next<=RIGHT;
                            end
                        else
                            next<=FALL_R;
                    end
                SPLAT:
                    begin
                        next<=SPLAT;
                    end
            endcase
        end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L) | (state == FALL_R);
    assign digging = (state == DIG_L) | (state == DIG_R);
endmodule
