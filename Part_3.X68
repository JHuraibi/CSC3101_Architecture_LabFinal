*-----------------------------------------------------------
* Title      : CSC3101 Final Lab
* Written by : J.Huraibi, fh1328
* Date       : April 25, 2020
* Description: Part 3, all subroutines together
* STATUS     : WORKING, ROUGH
*-----------------------------------------------------------

    ORG    $1000
START:                  * first instruction of program

    * Run Subroutine 1 *
        LEA     SR1_Start, A1	* Indicate SR1 starting
        MOVE.B  #13, D0     
        TRAP    #15
        
        BSR     getInputs       * Call SR1

		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        LEA     SR1_End, A1		* Indicate SR1 ended
        MOVE.B  #13, D0     
        TRAP    #15   
		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15     
        
    * Run Subroutine 2 *
        LEA     SR2_Start, A1	* Indicate SR2 starting
        MOVE.B  #13, D0     
        TRAP    #15
        
        BSR     startGCD		* Call SR2
        
		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        LEA     SR2_End, A1		* Indicate SR2 ended
        MOVE.B  #13, D0     
        TRAP    #15
		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        
    * Run Subroutine 3 *
        LEA     SR3_Start, A1	* Indicate SR3 starting
        MOVE.B  #13, D0     
        TRAP    #15
      
        BSR     outputValue		* Call SR3

		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        LEA     SR3_End, A1		* Indicate SR3 ended
        MOVE.B  #13, D0     
        TRAP    #15
		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        
    SIMHALT             * halt simulator

* --------------------------------------------------------------------------- *
* ---| Variables and Constants |--------------------------------------------- *
* --------------------------------------------------------------------------- *

a           DC.W	0
b           DC.W	0
finalVal    DC.W    -1

newline       DC.B $0D,$0A,0

promptGetA      DC.W 'Input a: ',0
promptGetB      DC.W 'Input b: ',0

msgConfirmA     DC.W 'For A, you entered: ',0
msgConfirmB     DC.W 'For B, you entered: ',0
msgFinalVal   	DC.W 'The Final GCD is: ',0

alertAZero		DC.W 'A cannot be Zero(0)',$0D,$0A,0  		
alertBZero		DC.W 'B cannot be Zero(0)',$0D,$0A,0  		
alertIfElseErr  DC.W 'if/else ERROR',$0D,$0A,0
alertFailed     DC.W 'FAILED',$0D,$0A,0

*--| Strings for testing |--*
AIsZero		DC.W '[a is 0, returning b]',$0D,$0A,0
BIsZero		DC.W '[b is 0, returning a]',$0D,$0A,0
ABEqual		DC.W '[a equal to b',$0D,$0A,0

SR1_Start   DC.W '[Subroutine 1: Starting]',$0D,$0A,0
SR2_Start   DC.W '[Subroutine 2: Starting]',$0D,$0A,0
SR3_Start   DC.W '[Subroutine 3: Starting]',$0D,$0A,0

SR1_End     DC.W '[Subroutine 1: Ended]',$0D,$0A,0
SR2_End     DC.W '[Subroutine 2: Ended]',$0D,$0A,0
SR3_End     DC.W '[Subroutine 3: Ended]',$0D,$0A,0


* --------------------------------------------------------------------------- *
* ---| Subroutines  |-------------------------------------------------------- *
* --------------------------------------------------------------------------- *

* ---| Subroutine 1 |--------------------------------------------------- *
* TRAP #18: Output string and get input from keyboard (Combines 4 and 14)
* D7 OFF LIMITS

getInputs  
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * Clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack

getA
        LEA     promptGetA, A1  * Get first input from user
        MOVE.B  #18, D0
        TRAP    #15
		
		MOVE.W  D1, a           * Save input in variable 'a'
		CMP 	#0, D1			* Check 'a' is valid
		BNE		getB
		
		LEA     alertAZero, A1  * Input for 'a' was zero
        MOVE.B  #13, D0
        TRAP    #15

		BRA		getA			* Reattempt to get 'a'

getB
        LEA     promptGetB, A1  * Get first input from user
        MOVE.B  #18, D0
        TRAP    #15
		
		MOVE.W  D1, b           * Save input in variable 'b'
		CMP 	#0, D1			* Check 'b' is valid
		BNE		inputsValid
		
		LEA     alertBZero, A1  * Input for 'b' was zero
        MOVE.B  #13, D0
        TRAP    #15

		BRA		getB			* Reattempt to get 'b'


inputsValid
		LEA     newline, A1
        MOVE.B  #13, D0     
        TRAP    #15
        
        LEA     msgConfirmA, A1 * Confirm what was put into 'a'
        MOVE.B  #14, D0         
        TRAP    #15
        
        MOVE.W  a, D1           * Output 'a'
        MOVE.W  #3, D0     
        TRAP    #15

		LEA     newline, A1		* Print new line
        MOVE.B  #13, D0     
        TRAP    #15
	
        LEA     msgConfirmB, A1 * Confirm what was put into 'b'
        MOVE.B  #14, D0         
        TRAP    #15
        
        MOVE.W  b, D1           * Output 'b'
        MOVE.B  #3, D0     
        TRAP    #15
		
  		MOVE.L  D7,(A7)         * Push the PC value back onto the stack
        RTS                     * Exit subroutine
            
* ---------------------------------------------------------------------- *		


* ---| Subroutine 2 |--------------------------------------------------- *
* D3 is always used for 'a'
* D4 is always used for 'b'
* D7 OFF LIMITS
* Label 'checkIfBZero' is not used, for ease of reading and consistency

startGCD
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * Clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack

GCD
        * [ Recursive Start ]
        
checkIfBZero
		* [ if(b == 0), return a ]
        MOVE.W	b, D4
        CMP     #0, D4			* (b == 0) ?
        BNE     checkIfAZero	* [FALSE: Branch]
        
		MOVE.W  a, finalVAl     * [TRUE: return a]
        BRA     return       
       
checkIfAZero
        * [ if(a == 0), return b ]
        CMP     #0, a          	* (a == 0) ?
        BNE     checkAGreater	* [FALSE: Branch]
        
        MOVE.W  b, finalVal     * [TRUE: return b]
        BRA     return

checkAGreater
         * [ if(a > b), return GCD(b, a % b) ]
	
		MOVE.W  a, D3			* D3 == a
		MOVE.W  b, D4			* D4 == b

	    CMP     D4, D3          * (a > b) ?
		BLT     checkBGreater 	* [FALSE: Branch]
	
								* [TRUE: GCD(a, a % b)]
        DIVU    D4, D3          * [D3] / [D4] -> [D3]
        MOVE.W  #0, D3          * Clear lower 16-bits of D4
        SWAP    D3              * Move remainder to lower 16-bits
        
		MOVE.W  b, a            * !! Store 'b' into 'a' BEFORE updating 'b'

        MOVE.W  D3, b           * Store mod remainder in 'b'
        BRA     GCD             * return GCD(b, a % b)


checkBGreater
         * [ if(b > a), return GCD(a, b % a) ]

       	MOVE.W  a, D3			* D3 == a
		MOVE.W  b, D4			* D4 == b
		
		CMP     D3, D4          * (b > a)?
		BLT     else			* [FALSE: Branch]
                                
                                * [TRUE: GCD(a, b % a)]
        DIVU    D3, D4          * [D4] / [D3] -> [D4]

        MOVE.W  #0, D4          * Clear lower 16-bits of D4
        SWAP    D4              * Move remainder to lower 16-bits
        CLR.L   b               * Clear 'b'
        MOVE.W  D4, b           * Store mod remainder in 'b'
        BRA     GCD             * return GCD(a, b % a)


else
        * [ if(a == b), return a ] 

		MOVE.W  a, D3
		MOVE.W  b, D4
		
		*THIS LINE SHOULD ALWAYS BE TRUE:
		CMP     D3, D4          * (a == b) ? 
        BNE     error   		* [FALSE, Branch]
                                
		MOVE.W  a, finalVal     * [TRUE: return a]
        BRA     return

error				
		LEA     alertIfElseErr, A1 	* Show error message
        MOVE.B  #13, D0     
        TRAP    #15
		
		MOVE.W 	#-1, finalVal   * [ Indicate error, store -1 to 'finalVal' ]
		BRA 	return		    * [ Redundant ]
		
return   
  		MOVE.L  D7,(A7)         * Push the PC value back onto the stack
        RTS                     * Exit subroutine        

* ---------------------------------------------------------------------- *

		            

* ---| Subroutine 3 |--------------------------------------------------- *
* Final GCD is in 'finalVal'
* D7 OFF LIMITS

outputValue		
        MOVE.L 	(A7),D7         * Pop the PC value from the stack
        CLR.L   (A7)            * Clear the contents of the stack
        SUB.L   #4,A7           * Decrement the head of the stack

* Part of if/else error checking functionality that got overwritten
*		CMP     #-1, finalVal   * "-1" indicates function failed
*		BNE     success         * [FALSE: Branch]
*		
*		LEA     alertFailed, A1 * [TRUE: Show err alert]
*       MOVE.B  #14, D0
*       TRAP    #15
*       BRA     end

success 	
		LEA     msgFinalVal, A1
        MOVE.B  #14, D0
        TRAP    #15

end        
		MOVE.W  finalVal, D1    * Output finalVal (either GCD or -1)
        MOVE.B  #3, D0     
        TRAP    #15
        
        LEA     newline, A1		* Print new line
        MOVE.B  #13, D0     
        TRAP    #15
  		
        MOVE.L  D7,(A7)         * Push the PC value back onto the stack
        RTS                     * Exit subroutine            
        
* ------------------------------------------------------------------------- *
					 
					 
    END    START   * last line of source



*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
