P <- matrix(c(0.7, 0.3, 0.2, 0.8), byrow = T, nrow = 2)

r <- eigen(P)
rv <- r$vectors
# left eigenvectors 
lvec <- solve(r$vectors)
# eigenvalues
lam <- r$values

pi<-lvec[1,]/sum(lvec[1,])
pi
