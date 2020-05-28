library(MASS)
library(tidyverse)
library(helperfunctions)

# valmistellaan dataa
boston <- MASS::Boston %>% 
  select(medv, dis, crim) %>% 
  as.matrix() 

#' asetetaan hyperparametrit c(mu0, mu1, mu2, tau0, tau1, tau2, alpha, gamma)
#' annetaan keskiarvoiksi pns estimaatista saatavat arvot ja 
#' varianssille suurehko arvo, jotta emme rajoita liikaa
fit <- lm(medv~dis+crim, data = MASS::Boston)
hypers <- c(0, 0, 0, 10, 10, 10, 50, 1)

# aloitus c(beta0, beta1, beta2, tau)

init <- c(0, 0, 0, 1)

samples <- helperfunctions::sampleGibbs(10000, boston, init, hypers)



  