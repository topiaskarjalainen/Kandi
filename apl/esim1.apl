⍝ matrix power
MPOW←{⊃+.×/⍺⍴⊂⍵}
⍝ transition matrix
mat←2 2⍴0.7 0.3 0.2 0.8
⍝ dist after 1000 steps
0.1 0.9  +.× 1000 MPOW mat
⍝ 0.4 0.6
