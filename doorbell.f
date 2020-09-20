\ ***************************************
\   Application module written in 
\   stm8_eForth
\ ***************************************

\ Peripherals usage:
\ TIMER1 CHANNEL 1 PŴM SERVO-MOTOR SW1 OUTPUT ON PC1 PIN 23
\ TIMER1 CHANNEL 2 PWM SERVO-MOTOR SW2 OUTPUT ON PC2 PIN 24
\ TIMER1 CHANNEL 3 PWM SERVO-MOTOR SW3 OUTPUT ON PC3 PIN 25
\ TIMER2 CHANNEL 1 PWM SERVO-MOTOR SW4 OUTPUT ON PD4 PIN 2
\ TIMER2 CHANNEL 2 PWM SERVO-MOTOR SW5 OUTPUT ON PD3 PIN 1
\ RED LED ON PD0 PIN 30
\ ORANGE LED ON PD1 PIN 31
\ YELLOW LED ON PD2 PIN 32
\ GREEN LED ON PC6 PIN 29 
\ BLUE LED ON PC7 PIN 28 
\ RING BUTTON ON PF4 PIN 13
\ RESET BUTTON ON NRST pin 6 
\ SWIM SIGNAL ON PIN 31
\ *************************************************************

\ REMOVE COMMENT ON NEXT LINE WHEN READY TO FLASH
 TO-FLASH 

\ FORGET OLD VERSION
FORGET BSET

\ set register bit
: BSET ( b a -- )
    DUP C@ ROT 1 SWAP LSHIFT OR SWAP C! ;

\ reset register bit
: BRES ( b a -- )
    DUP C@ ROT 1 SWAP LSHIFT NOT AND SWAP C! ;

\ read register bit
: BREAD ( b a -- 0|1 )
    OVER >R C@ 1 ROT LSHIFT AND R> RSHIFT ;

\ toggle register bit
: BTOGL ( b a -- )
    DUP C@ ROT 1 SWAP LSHIFT XOR SWAP C! ; 

\ set 16 bits register value
: R16! ( n a -- )
    OVER 8 RSHIFT OVER C! 1+ C! ;

\ compute ARR value from frequency
: PWM-PER ( fr -- u )
\ for timer clock = 2Mhz, i.e. prescale divisor 8.
    31250 32 ( fr -- fr 31250 64 ) 
    ROT ( -- 31250 64 fr )
    DUP ( --  31250 64 fr fr ) 
    2/ ( --  31250 64 fr fr/2 )
    >R ( --  31250 64 fr ) ( R: -- fr/2 ) 
    */MOD ( -- r q ) \ 31250*8/fr -> remainder and quotient
    SWAP ( -- q r ) \ remainder on top 
    R>   ( -- q r fr/2 ) \ round to nearest integer 
    /    ( -- q 0|1 ) \ 
    + ( -- u ) \ nearest integer
; 

\ LEDS 
0 DUP CONSTANT RED
1+ DUP CONSTANT ORANGE
1+ DUP CONSTANT YELLOW
1+ DUP CONSTANT GREEN
1+ CONSTANT BLUE

\ SERVO MOTORS 
RED DUP CONSTANT SM1
1+ DUP CONSTANT SM2
1+ DUP CONSTANT SM3
1+ DUP CONSTANT SM4
1+ CONSTANT SM5

\ from LED color return bit position u1 and ODR u2 
: LED-PIN ( u -- u1 u2 ) \ u is LED id {RED,ORANGE,YELLOW,GREEN,BLUE}
    DUP
    3 - 0< IF
    PD-ODR
    ELSE
    3 + PC-ODR
    THEN
; 

\ turn on LED, u is LED color
: LED-ON ( u -- )
    LED-PIN
    BRES
;

\ turn off LED, u is LED COLOR
: LED-OFF ( u -- )
    LED-PIN
    BSET
;

\ initialize LED pins in output mode.
: INIT-LED-OUTPUT ( -- )
    3 6 LSHIFT PC-ODR 2DUP C! 2 + C! \ PC6|PC7 GREEN|BLUE
    7 PD-ODR 2DUP C! 2 + SWAP 32 + SWAP C! \ PD0|PD1|PD2 RED,ORANGE,YELLOW 
;

\ LIGHT LEDS in sequence from RED to BLUE 
: LED-TEST ( -- )
    333 \ delay msec
    BLUE FOR
    BLUE I - DUP LED-ON 
    OVER PAUSE
    LED-OFF
    NEXT
    DROP 
;


: INIT-TIMERS ( -- ) \ initialize TIMER1 and TIMER2 in PMW mode.
\ T2 CH1 & CH2  SM4 & SM5  
    4 T2-PSCR C! \ prescale DIV 16, Fclock=16Mhz/8=1Mhz 
    50 PWM-PER T2-ARRH R16! \ period 
    1000 T2-CCR1H R16! \ SERVO CH1 PULSE WIDTH
    1000 T2-CCR2H R16! \ SERVO CH2 
    $D 3 LSHIFT T2-CCMR1 C! \ CH1 MODE PWM 
    $D 3 LSHIFT T2-CCMR2 C! \ CH2 MODE PWM
    $11 T2-CCER1 C! \ CH1 & CH2 ENABLE
    7 T2-EGR C! \ update CCR1,2 registers 
    1 T2-CR1 C! \ enable T2 counter 
\ T1 CH1,CH2,CH3 SM1,SM2,SM3
    16 T1-PSCRH R16! \  PRESCALE DIVISOR
    50 PWM-PER T1-ARRH R16! 
    1000 T1-CCR1H R16! 
    1000 T1-CCR2H R16!
    1000 T1-CCR3H R16!
    $D 3 LSHIFT T1-CCMR1 C!
    $D 3 LSHIFT T1-CCMR2 C!
    $D 3 LSHIFT T1-CCMR3 C!
    $11 T1-CCER1 C! \ ENABLE CH1,CH2
    1 T1-CCER2 C! \ ENABLE CH3
    $80 T1-BKR C! \ MAIN OUTPUT ENABLE
    15 T1-EGR C! \ update CCR1,2,3
    1 T1-CR1 C! \ ENABLE T1 COUNTER
;

: APP-INIT ( -- ) \ initialize application peripherals.
    INIT-LED-OUTPUT
    4 PF-CR1 BSET \ enable pull-up on PF-4 (ring button input)
    INIT-TIMERS
;

: RING? ( -- 0|-1 )
\ check ring button on PF4
    20 TIMER \  msec debounce
    0 BEGIN
        4 PF-IDR BREAD 
        IF 1- ELSE 1+ THEN  
        1 PAUSE 
        TIMEOUT? 
      UNTIL
      0< NOT  
;

: CCR! ( u1 u2 u3 -- ) \ u1=position, u2=Tx-CCR1H, u3 channel
\ Store u1 value in Tx-CCR register
    2* + R16!
;

: SERVO-POS ( u1 u2 -- ) \ u1=position, u2=channel
\ update servo-motor position
    DUP 3 - 0< IF 
    T1-CCR1H SWAP CCR!
    15 T1-EGR C! \ update 3 channels
    ELSE
    3 - 
    T2-CCR1H SWAP CCR! 
    7 T2-EGR C! \ update 2 channels
    THEN
; 

: BACK-OFF ( u1 -- ) \ u1=channel 
\ backoff hammer, rest poistion 1000
    BLUE OVER - LED-OFF
    1000 SWAP 
    SERVO-POS
    50 PAUSE
;

: KNOCK ( u1 -- ) \ u1=channel 
    BLUE OVER - LED-ON 
    1660 OVER SERVO-POS
    120 PAUSE
    BACK-OFF
;

: RING ( -- ) \ sound tubular bells.
    4 FOR I KNOCK 500 PAUSE NEXT 
;

\ programme principal de l'application.
: DOORBELL
    APP-INIT
    RING? NOT IF
    LED-TEST
    BEGIN
    RING? IF RING THEN
    AGAIN
    THEN
; 


TO-RAM
