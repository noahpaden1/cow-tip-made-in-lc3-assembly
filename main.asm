;;;;;;;;;;;;;;;;;;;;;;;;;;;;  	Confirguration:
;;			  ;;	- "ld p3os.obj"
;; Noah Paden Crozier	  ;;	- "as cowtip.asm"
;;			  ;;	- "ld cowtip.obj"
;; ECE-109		  ;;	- "as cow.asm"
;;			  ;;	- "ld cow.obj"
;; Due 7/8/2025 	  ;;	- "set pc x3000"
;; 			  ;;
;; Program 2 Source Code  ;;
;;  			  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	Description: this program initially accesses a library called "p3os" which allows Pennsim to access its graphic display. 
;	With this display, we then load in a picture of a cow into the memory and then this picture is outputted onto the screen.
;	From here, the user is able to control the cows movements using "wasd" keys like in a normal video game. Additionally, 
;	the user is able to toggle tip the cow using the 't' button and then the user can end the program with 'q' and reset the game
;	using 'return' so they can keep playing. Also one last thing is there is grass in this game that the cow can trample and then 
;	whence the cow moves and goes over the grass it goes away until the user resets the game.

.ORIG x3000

START                   	; start function that also doubles as a reset function when 'LF' is entered
    JSR CLR_SCREEN    		; clears the display screen at program start (redundant but its there for when 'LF' is entered)
    JSR RESET_COW_POS   	; set the cows position to the center of the screen 
    JSR DRAW_GRASS      	; calls function to draw grass

    LD R0, ORIENT_FLAG  
    BRz SKIP_FLIP_RESET 	; if cow is already upright (flag equals 0) then it skips flip process 
    BRnzp FLIP_COW      	; otherwise cow is flipped to make it go back upright using unconditional branch
     
SKIP_FLIP_RESET         	; cow flipping process is skipped if its already upright
    JSR DRAW_COW        	; redraws cow at its current position and orientation

MAIN_LOOP               	; main game loop which basically just determines what action is activated based on user input 
    GETC                	; get a character entered from the user and then store it into R0
    LD R5, RET_ASCII   		; load 'LF' ASCII character
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz START           	; if 'return' was entered by user it reruns 'START' sub routine to reset game 

    LD R5, W_ASCII        	; load 'w' ASCII character
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz MOVE_UP         	; if 'w' was entered by user then the 'MOVE_UP' sub routine is set off 

    LD R5, A_ASCII        	; load 'a' ASCII character
    NOT R5, R5	
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz MOVE_LEFT      		; if 'a' was entered by user then the 'MOVE_LEFT' subroutine is set off 

    LD R5, S_ASCII        	; load 's' ASCII character
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz MOVE_DOWN       	; if 's' was entered by user then the 'MOVE_DOWN' subroutine is set off 

    LD R5, D_ASCII        	; load 'd' ASCII character
    NOT R5, R5	
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz MOVE_RIGHT      	; if 'd' was entered by user then the 'MOVE_RIGHT' subroutine is set off 

    LD R5, Q_ASCII        	; load 'q' ASCII chracter
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz Q_EXIT          	; if 'q' was entered by user then the 'Q_EXIT' sub routine is set off which ends game 

    LD R5, T_ASCII        	; load 't' ASCII character
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R0, R5
    BRz FLIP_COW        	; if 't' was enered by user then the 'FLIP_COW' subroutine is set off 
    BRnzp DRAW_COW      	; if no recognized keys are entered then program loops

MOVE_UP                 	; move cow up (y - 4) 
    LD R1, DEST_PTR
    ST R1, TMP_PTR      	; save current cow position
    JSR ERASE_COW       	; erase cow before moving
    LD R6, DEST_PTR
    LD R7, SHIFT_UP
    ADD R6, R6, R7      	; move cow up by 4 pixels
    JSR CHECK_BOUNDS    	; check if new position is valid
    BRz SKIP_MOVE_UP    	; if out of bounds then skip updating position 
    ST R6, DEST_PTR     	; store new valid position
    LD R0, ORIENT_FLAG  
    BRz SKIP_FLIP_RESET 	 
    BRnzp FLIP_COW

SKIP_MOVE_UP            	; sub routine that skips position update if out of bounds 
    BRnzp DRAW_COW      	; redraws cow as is

MOVE_LEFT               	; move cow left (x - 4) 
    LD R1, DEST_PTR
    ST R1, TMP_PTR
    JSR ERASE_COW
    LD R6, DEST_PTR
    LD R7, SHIFT_LEFT
    ADD R6, R6, R7
    JSR CHECK_BOUNDS
    BRz SKIP_MOVE_LEFT  	; if out of bounds then just skip update
    ST R6, DEST_PTR
    LD R0, ORIENT_FLAG  
    BRz SKIP_FLIP_RESET 	 
    BRnzp FLIP_COW

SKIP_MOVE_LEFT         		; skip position update if out of bouds 
    BRnzp DRAW_COW      	

MOVE_DOWN               	; move cow down (y + 4)
    LD R1, DEST_PTR	
    ST R1, TMP_PTR
    JSR ERASE_COW
    LD R6, DEST_PTR
    LD R7, SHIFT_DOWN
    ADD R6, R6, R7
    JSR CHECK_BOUNDS
    BRz SKIP_MOVE_DOWN  	; if out of bounds then skip update
    ST R6, DEST_PTR
    LD R0, ORIENT_FLAG  
    BRz SKIP_FLIP_RESET 	 
    BRnzp FLIP_COW

SKIP_MOVE_DOWN         		
    BRnzp DRAW_COW      	

MOVE_RIGHT              	; move cow right (x + 4)
    LD R1, DEST_PTR
    ST R1, TMP_PTR
    JSR ERASE_COW
    LD R6, DEST_PTR
    LD R7, SHIFT_RIGHT
    ADD R6, R6, R7
    JSR CHECK_BOUNDS
    BRz SKIP_MOVE_RIGHT
    ST R6, DEST_PTR
    LD R0, ORIENT_FLAG  
    BRz SKIP_FLIP_RESET 	 
    BRnzp FLIP_COW

SKIP_MOVE_RIGHT        		; skip position update if out of bounds
    BRnzp DRAW_COW      	

CHECK_BOUNDS            	; make sure cows potential new screen position is valid 
    LD R3, SCREEN_START
    NOT R3, R3
    ADD R3, R3, #1
    ADD R4, R6, R3
    BRn INVALID         	; if new position is before screen start then set off 'INVALID' sub routine 
    LD R3, SCREEN_END
    NOT R3, R3
    ADD R3, R3, #1
    ADD R4, R6, R3
    BRp INVALID         	; if new position is after screen end then set off 'INVALID' sub routine
    LD R1, LEFT_BDRY
    LD R3, ROW_WIDTH
    NOT R1, R1
    ADD R1, R6, R1
    ADD R2, R1, #0
    LD R3, NEG_128
    LD R4, POS_128

HORIZONTAL_LOOP        		; loop adjusting column offset 
    ADD R2, R2, R3
    BRn HORIZONTAL_DONE 	; basically loops until R2 becomes negative 
    BRnzp HORIZONTAL_LOOP 	

HORIZONTAL_DONE        		; end of horizontal check loop
    ADD R2, R2, R4      	
    LD R3, MAX_COL_OFFSET
    NOT R3, R3
    ADD R3, R3, #1
    ADD R4, R2, R3
    BRp INVALID         	
    RET

INVALID                 	; sub routine that is activated if user attempts to make invalid move
    AND R6, R6, #0      	
    RET


ERASE_COW              		; sub routine that fills the cows previous space with black pixels 
    LD R0, BLACK_PIX
    LD R1, TMP_PTR
    LD R2, ROWS

ERASE_OUTER           		; outer loop for erasing rows
    LD R3, COLS

ERASE_INNER           		; inner loop for erasing columns
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R3, R3, #-1
    BRp ERASE_INNER     	
    LD R4, ROW_SKIP
    ADD R1, R1, R4
    ADD R2, R2, #-1
    BRp ERASE_OUTER     	; continue to next row 
    RET	

DRAW_COW              		; redraws cow from soure address in center of screen
    LD R0, SOURCE_PTR	
    LD R1, DEST_PTR
    LD R2, ROWS

DRAW_OUTER           		; outer loop for drawing rows
    LD R3, COLS

DRAW_INNER           		; inner loop for drawing colums
    LDR R4, R0, #0
    STR R4, R1, #0
    ADD R0, R0, #1
    ADD R1, R1, #1
    ADD R3, R3, #-1
    BRp DRAW_INNER     		; finish row
    LD R4, ROW_SKIP
    ADD R1, R1, R4
    ADD R2, R2, #-1
    BRp DRAW_OUTER     		; goes to next row to draw
    BRnzp MAIN_LOOP    		; this returns to the main gam loop

FLIP_COW              		; subroutine that flips cow
    LD R0, SOURCE_PTR
    LD R1, ROWS
    ADD R1, R1, #-1      	; bottom row index
    AND R2, R2, #0       	; resets top row index

FLIP_ROW_LOOP        		; loop through rows to swap pixels
    NOT R3, R1
    ADD R3, R3, #1
    ADD R3, R3, R2
    BRzp FLIP_DONE

    AND R4, R4, #0
    LD R7, COLS
    ADD R6, R2, #0

MULT_LOOP_START     		; loop to find top row offset
    ADD R6, R6, #-1
    BRn MULT_LOOP_END 		; if R6 is greater than 0 it exits top row loop 
    ADD R4, R4, R7
    BRnzp MULT_LOOP_START	

MULT_LOOP_END        		; ends top row offset calculations
    ADD R4, R0, R4
    AND R5, R5, #0
    ADD R6, R1, #0

MULT_LOOP2_START    		; loop to find bottom row offset 
    ADD R6, R6, #-1
    BRn MULT_LOOP2_END 		; if R6 is greater than 0 the code exits botom row loop
    ADD R5, R5, R7
    BRnzp MULT_LOOP2_START

MULT_LOOP2_END       		; end bottom row offset calculations
    ADD R5, R0, R5
    LD R3, COLS

PIX_SWAP_LOOP    		; loop to swap corresponding pixels between top and bottom rows
    LDR R6, R4, #0
    LDR R7, R5, #0
    STR R7, R4, #0
    STR R6, R5, #0
    ADD R4, R4, #1
    ADD R5, R5, #1
    ADD R3, R3, #-1
    BRp PIX_SWAP_LOOP 		; continue swapping row pixels 

    ADD R2, R2, #1
    ADD R1, R1, #-1
    BRnzp FLIP_ROW_LOOP 	; continue to next pair of rows 

FLIP_DONE            		; the finish flipping sub routie
    LD R0, ORIENT_FLAG
    BRz FLIP_SET_ONE   		; if flag was 0 aka upright then set it to 1 which means flipped
    AND R0, R0, #0
    ST R0, ORIENT_FLAG  
    BRnzp DRAW_COW     		; draw the flipped cow 

FLIP_SET_ONE        		; the set orientation flag subroutine 
    ADD R0, R0, #1
    ST R0, ORIENT_FLAG
    BRnzp DRAW_COW     		; draw the flipped cow

DRAW_GRASS            		; draw 21 vertical blades of grass that are 2 pixels wide 
    LD R0, GREEN_PIX
    LD R1, GRASS_START
    LD R2, CONST_24

GRASS_COLUMN_LOOP    		; loop through grass blade columns
    LD R3, CONST_25
    AND R4, R4, #0
    ADD R4, R4, R1

GRASS_ROW_LOOP      		; loop through rows of a grass blade
    STR R0, R4, #0
    ADD R5, R4, #1
    STR R0, R5, #0
    LD R5, GRASS_ROW_SKIP
    ADD R4, R4, R5
    ADD R3, R3, #-1
    BRp GRASS_ROW_LOOP  	; draw grass for 25 rows (height of cow) 
    ADD R1, R1, #6
    ADD R2, R2, #-1
    BRp GRASS_COLUMN_LOOP 	; draw next blade then continue grass column loop
    RET

RESET_COW_POS         		; reset cow to center position
    LD R0, COW_START_POS
    ST R0, DEST_PTR
    RET

CLR_SCREEN          		; fill screen with black pixels
    LD R0, BLACK_PIX
    LD R1, SCREEN_START
    LD R2, PIX_COUNT

CLR_LOOP          		; loop to clear screen pixels
    STR R0, R1, #0
    ADD R1, R1, #1
    ADD R2, R2, #-1
    BRp CLR_LOOP     		; end of loop when screen is clear 
    RET

Q_EXIT           		; subroutine that runs if 'q' ASCII is entered which just ends program
    HALT

SOURCE_PTR      .FILL x5000
DEST_PTR        .FILL xD8B1
TMP_PTR         .FILL x0000
COLS            .FILL #30
ROWS            .FILL #25
ROW_SKIP        .FILL #98
SHIFT_UP        .FILL #-512
SHIFT_DOWN      .FILL #512
SHIFT_LEFT      .FILL #-4
SHIFT_RIGHT     .FILL #4
GRASS_ROW_SKIP  .FILL #128
CONST_25        .FILL #25
CONST_24        .FILL #21

W_ASCII         .FILL x0077
A_ASCII         .FILL x0061
S_ASCII         .FILL x0073
D_ASCII         .FILL x0064
Q_ASCII         .FILL x0071
T_ASCII         .FILL x0074
RET_ASCII      	.FILL x000A
SCREEN_START    .FILL xC000
SCREEN_END      .FILL xF200
PIX_COUNT     	.FILL #15872
COW_START_POS   .FILL xD8B1
BLACK_PIX       .FILL x0000
GREEN_PIX     	.FILL x03E0
GRASS_START     .FILL xD883
BLADE_BASE_ADDR .FILL x0000
ORIENT_FLAG     .FILL #0   	; pointer for what flip position the cow is: 0 = upright and 1 = upside down

LEFT_BDRY   	.FILL xC000
ROW_WIDTH       .FILL #128
MAX_COL_OFFSET  .FILL #98
NEG_128         .FILL xFF80
POS_128         .FILL x0080

        .END
