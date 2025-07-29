module Branch_Logic(
    funct3,
    N,
    Z,
    C,
    V,
    predictionE,
    prediction,
    BranchE,
    Jump,
    PCSrc
);


    input [2:0] funct3;
    input N,Z,C,V;
    input BranchE;
    input predictionE;
    input prediction;
    input [1:0]Jump;
    reg Btaken;
   
    
    output reg [2:0] PCSrc;
    
    always@(*) begin
        if(BranchE == 1'h1) begin
            if((funct3 == 3'b000) && (Z == 1'h1)) begin  
                Btaken = 1'h1;
            end //beq
            else if((funct3 == 3'b001) && (Z == 1'h0)) begin  
                Btaken = 1'h1;
            end //bne
			else if((funct3 == 3'b100) &&(N!=V))begin
				Btaken =1'h1;
			end //blt
			else if((funct3 == 3'b110) && (C== 1'h0))begin
				Btaken = 1'h1;
			end //bltu
			else if((funct3 == 3'b111) && (C == 1'h1))begin
				Btaken = 1'h1;
			end // bgeU
			else if((funct3 == 3'b101) && (N==V))begin
				Btaken = 1'h1;
			end// bge
            else begin
                Btaken = 1'h0;
            end
        end
        else begin
            Btaken = 1'h0;
        end
    end
    

    always@(*)
    begin 
        if (Jump == 2'b10||(!predictionE && Btaken)) //(flush후 복구)
        begin
		    PCSrc = 3'b011;
	    end
	    else if (Jump == 2'b01) //(flush후 복구)
        begin
		    PCSrc = 3'b010;
	    end 
            // 예측 taken & 실제 taken
        else if (predictionE && Btaken)
        begin
            PCSrc = 3'b001;                //(pc_plus4)
        end
            // 예측 taken & 실제 not taken      (flush후 복구 pc_plus4E)
        else if (predictionE && !Btaken)
        begin
            PCSrc = 3'b101;
        end
            // 예측 not taken & 실제 taken (flush후 pc_targetE)
       /* else if (!predictionE && Btaken)
        begin
            PCSrc = 3'b110;
        end*/
            // 예측 not taken & 실제 not taken
        else if (prediction == 1'b1)   //no flush
        begin
            PCSrc = 3'b111;
        end
        else
        begin
            PCSrc = 3'b000;    //no flush
        end
           
        
    end

    //한클락안에 처리를 해야 효율이 높아지지 않나.
endmodule
