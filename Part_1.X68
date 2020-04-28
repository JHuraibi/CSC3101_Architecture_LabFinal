*---------------------------------------------------------------
* Title      : 
* Written by : 
* Date       :
* Description: First SR of Project (Get 2 inputs from user)
* STATUS     : GOOD, WORKING
* Notes      : D7 is storing the PC
*---------------------------------------------------------------

    ORG    $1000
START:                  * first instruction of program


        BSR subr_1              *SUBROUTINE 1 CALL
        

        LEA     valueOfA , A1   * CHECKING VALUE IN 'a' 
        MOVE.B  #14, D0         
        TRAP    #15  
        MOVE.B  a, D1
        MOVE.B  #3, D0
        TRAP    #15

        LEA     newLine, A1
        TRAP    #15

        LEA     valueOfB, A1   * CHECKING VALUE IN 'b'
        MOVE.B  #14, D0         
        TRAP    #15  
        MOVE.B  b, D1
        MOVE.B  #3, D0
        TRAP    #15 

        
    SIMHALT             * halt simulator

*[   Variables and Constants   ]
a       DC.B	0
b       DC.B	0

prmtGetA DC.W 'Input a: ', 0
prmtGetb DC.W 'Input b: ', 0

newline  DC.B $0D,$0A,0
valueOfA DC.W 'Value of A: ', 0
valueOfB DC.W 'Value of B: ', 0

        
subr_1  
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack

        LEA     prmtGetA, A1    * Queue the first prompt message
        MOVE.B  #18, D0         * Load TRAP (18: Output and keyboard)
        TRAP    #15             * Execute TRAP
        MOVE.B  D1, a           * Save to variable 'a'

        LEA     prmtGetB, A1    * Queue the second prompt message
        MOVE.B  #18, D0         * Ensure TRAP value(18: Output and keyboard)
        TRAP    #15             * Execute TRAP
        MOVE.B  D1, b           * Save to variable 'b'
     
  		MOVE.L  D7,(A7)         * Push the PC value back into the stack
        RTS                     * Exit subroutine            
		
    		        *END [ FIRST SR ]

    END    START   * last line of source     



*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
