*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

        LEA     start, A1    
        MOVE.B  #13, D0     
        TRAP    #15
		
		BSR     gcdStart            * Call GCD
		
		LEA     newline, A1         
        MOVE.B  #14, D0     
        TRAP    #15		
		
		LEA     valueWas, A1        * Output the final numbe
        MOVE.B  #14, D0     
        TRAP    #15

    SIMHALT             ; halt simulator

a           DC.B	0
b           DC.B	0
value       DC.B    0

newline  DC.B $0D,$0A,0
start  	  DC.W 'START',$0D,$0A,0
end  	  DC.W 'END',$0D,$0A,0
recur  	  DC.W 'Recursive Call',$0D,$0A,0
equal     DC.W 'WAS: a == b',$0D,$0A,0
bGreater  DC.W 'WAS: b > a',$0D,$0A,0
aGreater  DC.W 'WAS: a < b',$0D,$0A,0
valueWas  DC.W 'Value Returned: ',0


gcdStart 
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack
gcd		
		MOVE.B  a, D3
		MOVE.B  b, D4
		CMP     D3, D4          * (a == b) ? 
        BNE     
		* [ (a == b), return a ]
		LEA     equal, A1    
        MOVE.B  #13, D0
        TRAP    #15
        
		MOVE.B  D3, value		* Move 'a' into 'value'
        BRA endRecur            * return a, end recursion

checkBGreater
        * [ (b > a), return GCD( a, (b % a)) ]
		LEA     bGreater, A1    
        MOVE.B  #13, D0
        TRAP    #15
		
        MOVE.B  a, D3
		MOVE.B  b, D4
        DIVU    D4, D3          * [D3] / [D4] -> [D3]

        MOVE.W  #0, D4          * Clear lower 16-bits of D4
        SWAP    D4              * Move remainder to lower 16-bits
        
		MOVE.B  D4, b           * Store mod remainder in 'b'
								* 'a' is unchanged
        BRA     gcd             * return GCD(a, b % a)
        
checkAGreater
        * [ (a > b), return GCD(b, (a % b)) ] 
        LEA     aGreater, A1
        MOVE.B  #13, D0
        TRAP    #15
		
		CLR.L   D3
        CLR.L   D4
        
    	MOVE.B  a, D3
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
		            *END [Second SR ]

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
