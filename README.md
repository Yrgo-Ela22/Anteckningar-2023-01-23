# Anteckningar 2023-01-23
Implementering av dataminne för emulerad CPU samt övning gällande avbrottsimplementering i assembler.

Filen "exercise.asm" utgör en övningsuppgift innefattande PCI-avbrott i assembler.
Tre lysdioder anslutna till pin 8 - 10 (PORTB0 - PORTB2) togglas via nedtryckning av 
var sin tryckknapp ansluten till pin 11 - 13 (PORTB3 - PORTB5) enligt nedan:

   - Lysdiod 1 ansluten till pin 8 (PORTB0) togglas via nedtryckning av tryckknapp 1 ansluten till pin 11 (PORTB3).
   - Lysdiod 2 ansluten till pin 9 (PORTB1) togglas via nedtryckning av tryckknapp 2 ansluten till pin 12 (PORTB4).
   - Lysdiod 3 ansluten till pin 10 (PORTB2) togglas via nedtryckning av tryckknapp 3 ansluten till pin 13 (PORTB5).

Samtliga .c- och .h-filer utgör den emulerade CPU som konstrueras under kursens gång. I detta fall implementerades
ett dataminne med funktionalitet för läsning, skrivning samt nollställning. Instruktioner STS (Store To Dataspace)
samt LDS (Load From Dataspace) implementerades för skrivning till adress 256 - 511 i dataminnet (till skillnad mot
instruktioner IN och OUT, som medför läsning/skrivning till/från adresser 0 - 255).



