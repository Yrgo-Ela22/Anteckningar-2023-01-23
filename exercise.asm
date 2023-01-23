;/********************************************************************************
;* exercise.asm: Implementering av PCI-avbrott f�r toggling av lysdioder.
;*               Tre lysdioder anslutna till pin 8 - 10 (PORTB0 - PORTB2) 
;*               togglas via nedtryckning av var sin tryckknapp ansluten till
;*               pin 11 - 13 (PORTB3 - PORTB5) enligt nedan:
;*
;*               - Lysdiod 1 ansluten till pin 8 (PORTB0) togglas via
;*                 nedtryckning av tryckknapp 1 ansluten till pin 11 (PORTB3).
;*               - Lysdiod 2 ansluten till pin 9 (PORTB1) togglas via
;*                 nedtryckning av tryckknapp 2 ansluten till pin 12 (PORTB4).
;*               - Lysdiod 3 ansluten till pin 10 (PORTB2) togglas via
;*                 nedtryckning av tryckknapp 3 ansluten till pin 13 (PORTB5).
;*
;*               OBS! Skriv inte �ver CPU-register R16 - R18 efter initiering,
;*                d� dessa inneh�ller v�rden f�r enkel toggling av lysdioderna
;*               via skrivning till register PINB med f�ljande v�rden:
;*
;*               - R16 = (1 << LED1)
;*               - R17 = (1 << LED2)
;*               - R18 = (1 << LED3)
;********************************************************************************/
.EQU LED1 = PORTB0 ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU LED2 = PORTB1 ; Lysdiod 2 ansluten till pin 9 (PORTB1).
.EQU LED3 = PORTB2 ; Lysdiod 3 ansluten till pin 10 (PORTB2).

.EQU BUTTON1 = PORTB3 ; Tryckknapp 1 ansluten till pin 11 (PORTB3).
.EQU BUTTON2 = PORTB4 ; Tryckknapp 2 ansluten till pin 12 (PORTB4).
.EQU BUTTON3 = PORTB5 ; Tryckknapp 3 ansluten till pin 13 (PORTB5).

.EQU RESET_vect  = 0x00 ; Reset-vektor, utg�r programmets startpunkt.
.EQU PCINT0_vect = 0x06 ; Avbrottsvektor f�r PCI-avbrott p� I/O-port B.

;********************************************************************************
;* .CSEG - Programminnet, h�r lagras programkoden.
;********************************************************************************
.CSEG

;********************************************************************************
;* RESET_vect: Hoppar till subrutinen main f�r att starta programmet.
;********************************************************************************
.ORG RESET_vect
   RJMP main

;/********************************************************************************
;* PCINT0_vect: Avbrottsvektor f�r PCI-avbrott p� I/O-port B, som �ger rum vid
;*              nedtryckning eller uppsl�ppning av n�gon av tryckknapparna.
;*              Hopp sker till motsvarande avbrottsrutin ISR_PCINT0 f�r att
;*              hantera avbrottet.
;********************************************************************************/
.ORG PCINT0_vect
   RJMP ISR_PCINT0

;/********************************************************************************
;* ISR_PCINT0: Avbrottsrutin f�r hantering av PCI-avbrott p� I/O-port B, som
;*             �ger rum vid nedtryckning eller uppsl�ppning av n�gon av 
;*             tryckknapparna. Om nedtryckning av en tryckknapp orsakade 
;*             avbrottet togglas motsvarande lysdiod, annars g�rs ingenting.
;********************************************************************************/
ISR_PCINT0:
   IN R24, PINB
   ANDI R24, (1 << BUTTON1)
   BREQ ISR_PCINT0_2
   OUT PINB, R16 
   RETI
ISR_PCINT0_2:
   IN R24, PINB
   ANDI R24, (1 << BUTTON2)
   BREQ ISR_PCINT0_3
   OUT PINB, R17 
   RETI 
ISR_PCINT0_3:
   IN R24, PINB
   ANDI R24, (1 << BUTTON3)
   BREQ ISR_PCINT0_end
   OUT PINB, R18 
ISR_PCINT0_end:
   RETI

;/********************************************************************************
;* main: Initierar systemet vid start. Programmet h�lls sedan ig�ng s� l�nge 
;*       matningssp�nning tillf�rs via en loop. Toggling sker via avbrott, 
;*       s� loopen h�lls tom.
;********************************************************************************/
main:

;/********************************************************************************
;* setup: S�tter lysdioderna till utportar, aktiverar interna pullup-resistorer 
;*        samt PCI-avbrott p� tryckknapparnas pinnar. V�rden f�r enkel toggling
;*        av respektive lysdiod sparas i CPU-register R16 - R18.
;********************************************************************************/
setup:
   LDI R16, (1 << LED1) | (1 << LED2) | (1 << LED3) 
   OUT DDRB, R16
   LDI R24, (1 << BUTTON1) | (1 << BUTTON2) | (1 << BUTTON3) 
   OUT PORTB, R24
   LDI R16, (1 << LED1) 
   LDI R17, (1 << LED2) 
   LDI R18, (1 << LED3) 
   SEI
   STS PCICR, R16 
   STS PCMSK0, R24 

;/********************************************************************************
;* main_loop: H�ller ig�ng programmet s� l�nge matningssp�nning tillf�rs.
;********************************************************************************/
main_loop:
   RJMP main_loop