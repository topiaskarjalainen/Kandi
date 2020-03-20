targ <- function(theta) {
  theta^4*(1-theta)^6
}

jump <- function(prop, x, TO = TRUE) {
  if (TO) {
    if (x < .5) {
      dunif(prop, x, 1)
    } else {
      dunif(prop, 0, x)
    }
  } else {
    if (prop < .5) {
      dunif(x, prop, 1)
    } else {
      dunif(x, 0, prop)
    }
  }
}

mh_ber <- function(target, N, x) {
  samples <- matrix(NA, nrow = N, ncol = 1)
  samples[1,] <- x
  for (i in 2:N) {
    #browser()
    if (x < 0.5) {
      prop <- runif(1, x, 1)
      r <- (target(prop)*jump(prop, x, F))/(target(x)*jump(prop, x, T))
      if (!is.double(r)) r <- 1
    } else {
      prop <- runif(1, 0, x)
      r <- (target(prop)*jump(prop, x, F))/(target(x)*jump(prop, x, T))
      if (!is.double(r)) r <- 1
    }
    
    if (runif(1) < min(1, r))
      x <- prop
    samples[i,] <- x
  }
  return(samples)
}



set.seed(4)
n.iter <- 10000
sam <- mh_ber(targ, n.iter, 0)


#png("/Users/topiaskarjalainen/Documents/University/kandi/Kandi/latex/mhexample2.png",
#    width = 1000,
#    height = 500
#)
par(mfrow=c(1,2))
plot(1, type="n", 
     xlab=expression(theta), 
     ylab=expression(probability), 
     main = "n=100000",
     xlim=c(0, 1), 
     ylim=c(0, 3),
     cex.lab=1.5, 
     cex.axis=1.5, 
     cex.main=1.5, 
     cex.sub=1.5
)
hist(sam, breaks = 50, freq = F, add = T, col = rgb(0,1,0,alpha=0.3))
x <- seq(0,1,length.out = 200)
lines(x, dbeta(x, 5, 7), col = "red", lwd=3)
abline(v = 5/(5+7), col = "red", lty=6, lwd=3)
abline(v = mean(sam), col = "green", lty=6)
par(mfrow=c(1,1))
plot(1, type="n", 
     xlab="n", 
     ylab=expression(theta), 
     main = "n=100000",
     xlim=c(0, n.iter), 
     ylim=c(0, 1),
     cex.lab=1.5,
     cex.axis=1.5, 
     cex.main=1.5, 
     cex.sub=1.5
)
lines(sam)
abline(h=mean(sam), col = "red")
#dev.off()

rstan::monitor(sam, digits = 5, warmup = 0)
