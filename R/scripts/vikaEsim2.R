library(foreach)
library(doParallel)
library(tidyverse)
library(coda)

####################################################################################

n_cores <- detectCores()
registerDoParallel(cores = n_cores)

####################################################################################

air <- airquality %>%
  select(Ozone, Solar.R, Wind) %>%
  na.omit() %>%
  as.matrix()

y <- air[,1]
x1 <- air[,2]
x2 <- air[,3]


update_tau <- function(beta0, beta1, beta2) {
  alpha <- alpha_p + (N/2)
  res <- (y-beta0-beta1*x1-beta2*x2)^2
  gamma <- gamma_p + .5 * sum(res)
  rgamma(1, alpha, gamma)
}

update_beta0 <- function(beta1, beta2, tau) {
  precision <- tau0 + tau * N
  mean <- tau0*mu0 + tau*sum(y-beta1*x1-beta2*x2)
  mean <- mean/precision
  rnorm(1, mean, 1/sqrt(precision))
}

update_beta1 <- function(beta0, beta2, tau) {
  precision <- tau1 + tau * sum(x1^2)
  mean <- (tau1*mu1 + tau*sum((y-beta0-beta2*x2)*x1))/precision
  rnorm(1, mean, 1/sqrt(precision))
}

update_beta2 <- function(beta0, beta1, tau) {
  precision <- tau2 + tau * sum(x2^2)
  mean <- (tau2*mu2 + tau*sum((y-beta0-beta1*x1)*x2))/precision
  rnorm(1, mean, 1/sqrt(precision))
}

N <- air[,1] %>% length()
chains <- n_cores
iter <- 2000


mu0 <- 80
mu1 <- 0
mu2 <- -5
tau0 <- 1/50
tau1 <- 1/50
tau2 <- 1/50
alpha_p <- 5
gamma_p <- 0.01

set.seed(1957)

samples <- foreach(i = 1:chains) %dopar% {
  samples <- matrix(0, nrow = iter, ncol = 4)
  #' Jostain syystä ei pelaa hyvin negatiivisten aloitusarvojen kanssa
  #' en jaksa debugata just nyt
  beta0 <- rnorm(1) %>% abs()
  beta1 <- rnorm(1) %>% abs()
  beta2 <- rnorm(1) %>% abs()
  tau <- rnorm(1) %>% abs()
  samples[1,] <- c(beta0, beta1, beta2, tau)
  for (j in 2:iter) {
    beta0 <- update_beta0(beta1, beta2, tau)
    beta1 <- update_beta1(beta0, beta2, tau)
    beta2 <- update_beta2(beta0, beta1, tau)
    tau <- update_tau(beta0, beta1, beta2)

    samples[j,] <- c(beta0, beta1, beta2, tau)
  }
  samples
}





####################################################################################
####################################################################################

# Muutetaan ketjut parametrikohtaisiksi ja katkaistaan burnin pois
##beta0 <- map(samples, function(x) x[10000:20000,1]) %>% unlist() %>% matrix(ncol = 8)
##beta1 <- map(samples, function(x) x[10000:20000,2]) %>% unlist() %>% matrix(ncol = 8)
##beta2 <- map(samples, function(x) x[10000:20000,3]) %>% unlist() %>% matrix(ncol = 8)
##tau   <- map(samples, function(x) x[10000:20000,4]) %>% unlist() %>% matrix(ncol = 8)


# Muutetaan ketjut coda objekteiksi ja poistetaan burnin
#samples2 <- map(samples, function(x) as.mcmc(x[10001:20000,]))
samples2 <- map(samples, function(x) as.mcmc(x[1001:2000,]))
#samples2 <- map(samples, function(x) as.mcmc(x[250:500,]))
#samples <- map(samples, function(x) x[10000:20000,])
samples <- do.call(rbind, samples2)
samples.mcmc <- mcmc.list(samples2)

gelman.diag(samples.mcmc, autoburnin=FALSE, multivariate=FALSE)
gelman.plot(samples.mcmc)
effectiveSize(samples.mcmc)
summary(samples.mcmc)

png("/Users/topiaskarjalainen/Documents/University/kandi/Kandi/latex/gibbs2.png",
    width = 1100,
    height = 1500
)
plot(samples.mcmc)
dev.off()

####################################################################################
####################################################################################

plot(samples[,3], type = "l", col = rgb(0,0,0,0.2))
lines(samples[,2], col = rgb(1,0,0,0.2))

mean(samples[,1])
mean(samples[,2])
mean(samples[,3])
1/mean(samples[,4])

hist(samples[,1], breaks = 50, freq = F)
hist(samples[,2], breaks = 50, freq = F)
hist(samples[,3], breaks = 50, freq = F)
hist(1/samples[,4], breaks = 50, freq = F, xlab = expression(sigma^2))
samples <- samples[seq(1, 20000, length.out = 250),]
pairs(samples, pch = 20, col = rgb(0,0,0,0.3))


density(samples[,1], breaks = 50) %>% plot()
density(samples[,2], breaks = 50) %>% plot()
density(samples[,3], breaks = 50) %>% plot()
density(1/samples[,4], breaks = 50) %>% plot(xlab = expression(sigma^2))



###############

ss <- summary(samples.mcmc)
ss.df <- cbind(ss$statistics, ss$quantiles)
ss.df <- ss.df[,c(1,2,5,6,7,8,9)]
xtable::xtable(ss.df, type = "latex", digits = c(5)) %>% print()

####


b0 <- samples[,1] %>% mean()
b1 <- samples[,2] %>% mean()
b2 <- samples[,3] %>% mean()
####################
samples.p <- samples[seq(1, length(samples[,1]), length.out = 2000),]
fit <- lm(y~x1+x2)

png("/Users/topiaskarjalainen/Documents/University/kandi/Kandi/latex/gibbsexample.png",
    width = 1100,
    height = 600
)
par(mfrow = c(1,2))
plot(x1, y, pch = 20, col = rgb(0,0,0,0.3),
     xlab = "Solar.R", ylab = "Ozone")
for (i in 1:length(samples.p)) {
  abline(samples.p[i,1],samples.p[i,2], col = rgb(0,0,1,0.05))
}
abline(b0, b1, col="red", lwd = 2)
#abline(77.19940,0.09995)
abline(fit$coefficients["(Intercept)"],fit$coefficients["x1"], col = "green",
       lwd = 2)


plot(x2, y, pch = 20, col = rgb(0,0,0,0.3),
     xlab = "Wind", ylab = "Ozone")
for (i in 1:1000) {
  abline(samples.p[i,1],samples.p[i,3], col = rgb(0,0,1,0.05))
}
abline(b0, b2, col="red", lwd = 2)
#abline(77.19940, -5.39131)
abline(fit$coefficients["(Intercept)"],fit$coefficients["x2"], col = "green",
       lwd = 2)
dev.off()
