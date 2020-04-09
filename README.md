# Kandi

## $\LaTeX$ kansio

Sisältää nimensä mukaisesti latex koodin ja tietenkin lopullisen pdf tiedoston.

## R kansio

Sisältää lyhyitä scriptejä esim kuvaajia varten ja muutaman esimerkin. Jotkin tiedostot toimivat vain unix ja unix-like koneilla koska ```parallel``` paketti toimii vaan niillä.

## cpp kansio 

Sisältää R paketin, jota on käytetty R koodin apuna. Sisältää c++ koodia joten tarvitsee kääntäjän. Kääntäjänä on käytetty gcc:tä. `~/.R/Makevars` tiedostossa minulla on 

```
CC=gcc-9
CXX=g++-9
CXX11=g++-9
CFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
CXXFLAGS=-mtune=native -g -O2 -Wall -pedantic -Wconversion
FLIBS=-L/usr/local/Cellar/gcc/9.2.0_3/lib/gcc/9
```

joilla paketti ainakin kääntyy. Tämä pakottaa R:n käyttämään gcc:tä sillä MacOS:ssä default asetuksilla `gcc` on symlink Apple `clang` kääntäjään eikä oikeaan `gcc`:n historiallisista syistä, ja `openmp` ei oikein toimi yhteen Applen kääntäjän kanssa. Gcc minulla on perus homebrew gcc. Kääntö tapahtuu

```
cd ~/path/to/directory/
R CMD build && R CMD install [tarball name]
```

Tai asennus suoraan tarballista

```
cd ~/path/to/directory/
R CMD install [tarball name]
```
```helperfunctions::sampleGibbs``` funktio aiheuttaa segfaultin. Teinkin tämän lopulta R:llä. En suosittele ajamaan siis tuota functiota
