*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Second SR of Project (return a or b) [1 of 2]
* STATUS     : WORKING, GOOD
*-----------------------------------------------------------

    ORG    $1000
START:                  * first instruction of program


*[TESTING] SUBROUTINE 2 CALL WILL BE DONE BY subr_1
        BSR subr_2              
        
        LEA     newLine, A1    
        MOVE.B  #14, D0     
        TRAP    #15
        LEA     valueWas, A1 
        MOVE.B  #14, D0     
        TRAP    #15

        MOVE.B  value, D1   * TESTING what was returned
        MOVE.B  #3, D0     
        TRAP    #15
        
    SIMHALT             * halt simulator

*---------------------------------*
*---| Variables and Constants |---*
*---------------------------------*

a       DC.B	0
b       DC.B	0
value   DC.B    0
testA   DC.B	2
testB   DC.B	0

newline  DC.B $0D,$0A,0
prmtGetA DC.W 'Input a: ', 0
prmtGetB DC.W 'Input b: ', 0

isZeroA   DC.W 'a was 0, return b',$0D,$0A,0
isZeroB   DC.W 'b was 0, return a',$0D,$0A,0
msgSR_END DC.W 'SR END',$0D,$0A,0
valueWas  DC.W 'Value Returned: ',0


*---------------------*
*---| Subroutines |---*
*---------------------*
        
subr_2  MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack
        
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

        * !! PART 2_2 GOES HERE (ifElseBlock)

  		MOVE.L  D7,(A7)         * Push the PC value back into the stack
        RTS                     * Exit subroutine            
		
    		        *END [ Second SR ]

    END    START   * last line of source 






















*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
