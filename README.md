# Skabeloner til undervisningsmaterialer
Version 0.2

(Lua)Latex skabeloner til generering af materialer til læringsaktiviteter i folkeskolen. Skabelonerne er lavet til at læse data fra en CSV fil, for på den måde at gøre det hurtigt at lave flotte kort til fx. quiz og byt, magretheskål, byt-byt-par, kategoriserings øvelser, vendespil og lign øvelser.

Første række angiver, hvor indholdet skal placeres. Her kan vælges 'FrontUpper' og 'FrontLower'. Dette kan yderlige følges af et tal, hvis der ønskes flere kort med forskellig type indhold. 
Anden række fortæller typen af indhold og bestemmer på den måde udsenet af kortene. Se liste over understøttede indholds typer længere nede, samt eksempler i mappen Examples.

Kortene kompileres ved at kører:
```
lualatex cards.tex [sti til csv fil] [antal kort sæt]
```

## Indholds typer
* __SingleWord__ er tekst sat med \Huge størrelse og centreret
* __Text__ er tekst sat med \Large
* __LongText__ er tekst sat med \normalsize.
* __Image__ modtager stien til et billede og indsætter det med en maks bredde og højde svarende til kortets bredde. 
* __Equation__ indholdet bliver sat i et amsmat equation* envirronment.
* __Align__ indholdet bliver sat i et amsmat align* envirronment.

Testet med en TexLive 2017 installeret på Ubuntu 18.04.
