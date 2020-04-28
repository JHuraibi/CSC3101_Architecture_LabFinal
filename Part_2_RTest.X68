*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Testing modulus WORKING
*-----------------------------------------------------------

    ORG    $1000
START:                  * first instruction of program
     

        * [ if(a > b) -> GCD(b, a % b) ]
		* [ a = (b), b =(a % b) ]
        
		MOVE.B  a, D1
		MOVE.B  b, D2
        DIVU    D1, D2          * D2 / D1 -> D2 

        MOVE.W  #0, D2          * Clear lower 16-bits of D2
        SWAP    D2              * Remainder now in lower 16-bits
        
        MOVE.B  b, a            * !! Store 'b' into 'a' BEFORE updating 'b'
        MOVE.B  D2, b           * Store mod remainder in 'b'
        
        LEA     newLine, A1    
        MOVE.B  #14, D0     
        TRAP    #15
        
        LEA     msgA, A1    
        MOVE.B  #14, D0     
        TRAP    #15

        MOVE.B  a, D1
        MOVE.B  #3, D0     
        TRAP    #15
        
        LEA     msgB, A1    
        MOVE.B  #14, D0     
        TRAP    #15

        MOVE.B  b, D1
        MOVE.B  #3, D0     
        TRAP    #15
        
    SIMHALT             * halt simulator

*---------------------------------*
*---| Variables and Constants |---*
*---------------------------------*
a       DC.B	20
b       DC.B	30 
value   DC.B    0
testA   DC.B	0
testB   DC.B	0
mod     DC.B    0

newline  DC.B $0D,$0A,0
prmtGetA DC.W 'Input a: ', 0
prmtGetB DC.W 'Input b: ', 0

isZeroA   DC.W 'a was 0, return b',$0D,$0A,0
isZeroB   DC.W 'b was 0, return a',$0D,$0A,0
msgSR_END DC.W 'SR END',$0D,$0A,0
valueWas  DC.W 'Value Returned: ',0
msgRecur  DC.W 'RECURSIVE CALL',$0D,$0A,0

msgD2     DC.W 'D2: ',0
msgA      DC.W 'A: ',0
msgB      DC.W 'B: ',0


*---------------------*
*---| Subroutines |---*
*---------------------*
        
subr_2  MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack
        
        LEA     msgRecur, A1    * TESTING, indicate SR call
        MOVE.B  #14, D0         
        TRAP    #15

        * [ if(a == 0), return b ]
        MOVE.B  testA, D1       * Load value in 'a'
        CMP     #0, D1          * Check if a == 0
        BNE     checkB
        MOVE.B  testB, value    * Set 'value' equal to 'b'

        LEA     isZeroA , A1    * TESTING
        MOVE.B  #14, D0         
        TRAP    #15

        BRA     recurBlock

checkB                  
        * [ if(b == 0), return a ]
        MOVE.B  testB, D1       * Load value in 'b'
        CMP     #0, D1          * Check if b == 0
        BNE     recurBlock
        MOVE.B  testA, value    * Set 'value' equal to 'a'

        LEA     isZeroA , A1    * TESTING
        MOVE.B  #14, D0         
        TRAP    #15
        
        BRA     recurBlock
        
recurBlock
        * [ if/else block ]
        LEA     msgSR_END, A1    * TESTING
        MOVE.B  #14, D0         
        TRAP    #15

        * PART 2_2 (ifElseBlock)
        * [ if(a > b), return GCD(b, a% b) ]
        
        
        * return

  		MOVE.L  D7,(A7)         * Push the PC value back into the stack
        RTS                     * Exit subroutine            
		
    		        *END [ Second SR ]

    END    START   * last line of source





        * [ if(a > b) -> GCD(b, a % b) ]
		* [ a = (b), b =(a % b) ]
        
		*MOVE.L  a, D1
		MOVE.L  b, D2
        DIVU    a, D2          * a / b -> D2 

        CLR.L   D3              * Clear potential garbage
        MOVE.W  D2, D3          * Store D2 in just-cleared D3
        MOVE.W  #0, D2          * Clear lower 16-bits of D2
        SWAP    D2              * Remainder now in lower 16-bits
        
        MOVE.B  b, a            * Store 'b' into 'a' BEFORE updating 'b'
        MOVE.B  D2, b           * Store mod remainder in 'b'
        
        LEA     newLine, A1    
        MOVE.B  #14, D0     
        TRAP    #15
        
        LEA     msgMod, A1    
        MOVE.B  #14, D0     
        TRAP    #15

        MOVE.B  b, D1
        MOVE.B  #3, D0     
        TRAP    #15










        




*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
