#library(helperfunctions)
#library(MASS)
vcov1 <- .01*diag(2)
#vcov2 <- diag(2)

set.seed(1)
data1 <- helperfunctions::mhalgo(10000, c(5,5), vcov1, 0)
set.seed(1)
data2 <- helperfunctions::mhalgo(10000, c(0,0), vcov1, 0)
set.seed(1)
data3 <- helperfunctions::mhalgo(100000, c(0,0), vcov1, 0)

k <- MASS::kde2d(data3[,1], data3[,2], n=500)




png("/Users/topiaskarjalainen/Documents/University/kandi/Kandi/latex/mhexample1.png",
    width = 1100,
    height = 333
    )
#setEPS()
#postscript("/Users/topiaskarjalainen/Documents/University/kandi/Kandi/latex/mhexample1.eps",
#           width = 100,
#           height = 333)
par(mfrow=c(1,3))

plot(1, type="n", 
     xlab=expression(theta[1]), 
     ylab=expression(theta[2]), 
     main = expression(theta[0]*" = (5,5)"),
     xlim=c(-3, 3), 
     ylim=c(-3, 3),
     cex.lab=2, 
     cex.axis=2, 
     cex.main=2, 
     cex.sub=2
     )
points(data1, pch = '.')
lines(head(data1, 250), col = "red")

plot(1, type="n", 
     xlab=expression(theta[1]), 
     ylab=expression(theta[2]), 
     main = expression(theta[0]*" = (0,0)"), 
     xlim=c(-3, 3), 
     ylim=c(-3, 3),
     cex.lab=2, 
     cex.axis=2, 
     cex.main=2, 
     cex.sub=2
     )
points(data2, pch = '.', col = "red")
lines(head(data2, 250))

#plot(1, type="n", xlab="", ylab="", xlim=c(-5, 5), ylim=c(-5, 5))
image(k, col = hcl.colors(100),
      xlab=expression(theta[1]), 
      ylab=expression(theta[2]), 
      main = "Tiheys",
      cex.lab=2, 
      cex.axis=2, 
      cex.main=2, 
      cex.sub=2
      )
dev.off()

