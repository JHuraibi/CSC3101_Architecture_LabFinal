*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Third SR of Project (Print final value: GCD)
* STATUS     : NOT WORKING, IN PROGRESS
*-----------------------------------------------------------

    ORG    $1000
START:                  * first instruction of program


        
        BSR     gcdStart
        
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

a       DC.B	3
b       DC.B	5
value   DC.B    0

newline  DC.B $0D,$0A,0
prmtGetA DC.W 'Input a: ', 0
prmtGetB DC.W 'Input b: ', 0

isZeroA   DC.W 'a was 0, return b',$0D,$0A,0
isZeroB   DC.W 'b was 0, return a',$0D,$0A,0
msgSR_END DC.W 'SR END',$0D,$0A,0
valueWas  DC.W 'Value Returned: ',0
msgRecur  DC.W 'RECURSIVE CALL',$0D,$0A,0


*---------------------*
*---| Subroutines |---*
*---------------------*
        
gcdStart 
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack

gcd     
        LEA     msgRecur, A1    * TESTING, indicate SR call
        MOVE.B  #14, D0         
        TRAP    #15

        * [ if(a == 0), return b ]
        MOVE.B  a, D1           * Load value of 'a'
        CMP     #0, D1          * (a == 0) ?
        BNE     checkB
        MOVE.B  b, value        * Set 'value' equal to 'b'

        LEA     isZeroA , A1    * TESTING
        MOVE.B  #14, D0         
        TRAP    #15

        BRA     recurBlock

checkB                  
        * [ if(b == 0), return a ]
        MOVE.B  b, D1           * Load value in 'b'
        CMP     #0, D1          * (b == 0) ?
        BNE     recurBlock
        MOVE.B  a, value        * Set 'value' equal to 'a'

        LEA     isZeroA , A1    * TESTING
        MOVE.B  #14, D0         
        TRAP    #15

* [if/else sorted by LOC: (a == b), (b > a), (a > b)]
        
recurBlock

		MOVE.B  a, D3
		MOVE.B  b, D4
		CMP     D3, D4          * (a == b) ? 

		* [ (a == b), return a ]
		MOVE.B  D3, value		
        BRA endRecur            * return a

        * [ (b > a), return GCD( a, (b % a)) ]
        MOVE.B  a, D3
		MOVE.B  b, D4
        DIVU    D4, D3          * [D3] / [D4] -> [D3]

        MOVE.W  #0, D4          * Clear lower 16-bits of D4
        SWAP    D4              * Move remainder to lower 16-bits
        MOVE.B  D4, b           * Store mod remainder in 'b'
        BRA     gcd             * return GCD(a, b % a)
        
aGreater
        * [ (a > b), return GCD(b, (a % b)) ] 
    	MOVE.B  a, D3           * [Should be redundant]
		MOVE.B  b, D4
		
	    CMP     D3, D4          * (a > b) ? 
		BLT     aGreater        * False: branch
		
        DIVU    D3, D4          * [D4] / [D3] -> [D4]
        MOVE.W  #0, D4          * Clear lower 16-bits of D4
        SWAP    D4              * Move remainder to lower 16-bits
        
        MOVE.B  b, a            * Store 'b' into 'a' BEFORE updating 'b'
        MOVE.B  D4, b           * Store mod remainder in 'b'
        BRA     gcd             * return GCD(b, a % b)

endRecur
  		MOVE.L  D7,(A7)         * Push the PC value back into the stack
        RTS                     * Exit subroutine            
		
    		        *END [ Second SR ]

    END    START   * last line of source 





*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
