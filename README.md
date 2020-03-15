# Kandi

## $\LaTeX$ kansio

Sisältää nimensä mukaisesti latex koodin ja tietenkin lopullisen pdf tiedoston.

## R kansio

Sisältää lyhyitä scriptejä esim kuvaajia varten

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

joilla paketti ainakin kääntyy. Gcc on perus homebrew gcc. Kääntötapahtuu

```
cd ~/path/to/directory/
R CMD build && R CMD install [tarball name]
```

Tai asennus suoraan tarballista

```
cd ~/path/to/directory/
R CMD install [tarball name]
```

