# Skabeloner til undervisningsmaterialer

(Lua)Latex skabeloner til generering af materialer til læringsaktiviteter i folkeskolen. Skabelonerne er lavet til at læse data fra en CSV fil, for på den måde at gøre det hurtigt at lave flotte kort til fx. quiz og byt, magretheskål, kategoriserings øverlser eller lign.

Pt. er der to skabeloner *Billederkort* generere kort med en overskift og et billede. Men *QuizOgByt* generer simple kort med en stor tekst øverst og en en mindre længere tekst nederst. 

Kortene kompileres ved at:
```lualatex  Billederkort.tex [sti til csv fil] [antal kort sæt]
```

Testet med en TexLive 2017 installation.
