module branch_logic(
    funct3,
    Nflag,
    Zflag,
    Cflag,
    Vflag,
    Btaken,
    Branch
);

    input [2:0] funct3;
    input Nflag, Zflag, Cflag, Vflag;
    input Branch;
    output reg Btaken;
    
    always @(*) begin
        if(Branch == 1'b1) begin
            if(funct3 == 3'b001) begin    //bne
                if(Zflag == 1'b0) 
                    Btaken = 1'b1;
                else 
                    Btaken = 1'b0;
            end
            else if(funct3 == 3'b000) begin   //beq
                if(Zflag == 1'b1) 
                    Btaken = 1'b1;
                else 
                    Btaken = 1'b0;
            end
            else if(funct3 == 3'b100) begin  //blt
                if(Nflag != Vflag)
                    Btaken = 1'b1;
                else 
                    Btaken = 1'b0;
            end
            else if(funct3 == 3'b110) begin  //bltu
                if(Cflag == 1'b0)
                    Btaken = 1'b1;
                else 
                    Btaken = 1'b0;
            end
            else if(funct3 == 3'b111) begin  //bgeu
                if(Cflag == 1'b1)
                    Btaken = 1'b1;
                else
                    Btaken = 1'b0;
            end
            else if(funct3 == 3'b101) begin
                if(Nflag == Vflag || Zflag == 1'b1)  //bge
                    Btaken = 1'b1;
                else
                    Btaken = 1'b0;
            end
            else begin
                Btaken = 1'b0;
            end
        end
        else begin
            Btaken = 1'b0;
        end
    end
    

endmodule