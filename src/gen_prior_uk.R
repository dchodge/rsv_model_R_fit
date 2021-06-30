# File to contain all the information about the priors in the model
# a) Parameters which are fitted in the model, (there's a lot of parameters!!!!)
fit.par <- data.frame(
  namesOfParameters=c("xi", "si", "g0", "g1", "g2", "om","pA1", "pA2", "pA3", "pA4", "alpha_i", "d1", "d2", "d3", "phi", "qp", "qc", "b1", "psi", "c5ep1", "c5ep2","ep5", "ep6", "l1", "l2"),
  lowerParSupport =c(14, 2, 2, 0.5, 0.5, 60, 0, 0, 0, 0, 0.05, 0.0, 0.0, 0.0, 0, 0, 0,          0,    0, -10, -10, 0, 0, 0, 0),
  # lower boundary 
  upperParSupport =c(180, 8, 20, 1, 1, 365, 1, 1, 1, 1, 0.95, 1.0, 1.0, 1.0, 1.0, 1.0, 1.00, 2.0,  1,  10, 10,  1, 1, 1, 1),
  fit_indicator= rep(1, 25)
)

# b) import the prior distributions associated with each of the parameters
priorDistSample <- list(runif, rgamma, rweibull, rweibull, rlnorm, rnorm, rbeta, rbeta, rbeta, rbeta, runif, rbeta, rbeta, rbeta, runif, runif, runif, runif, runif, rnorm, rnorm, rgamma, rgamma, runif, runif)
priorDistDensity <- list(dunif, dgamma, dweibull, dweibull, dlnorm, dnorm, dbeta, dbeta, dbeta, dbeta, dunif, dbeta, dbeta, dbeta, dunif, dunif, dunif, dunif, dunif, dnorm, dnorm, dgamma, dgamma, dunif, dunif)
priorDistPar1 <- c(14, 7.111, 4.137, 34.224, -0.561, 135, 3.003, 8.996, 38.033, 35.955, 0.05, 35.583, 22.829, 6.117, 0.3, 0, 0,        0,  0,  -3.9885, -0.1794, 35.0678, 59.2461, 0, 0)
priorDistPar2 <- c(180, 1.0/0.563, 8.303, 0.879, 0.163, 35, 29.997, 43.004, 34.967, 11.045, 0.95, 3.117, 11.417, 12.882, 0.7, 0.1, 1, 2, 1, 0.1357, 0.0413, 1.0/0.00000261628, 1.0/0.00000228079, 1, 1)

priordata <- list(
    fit.par = fit.par,
    priorDistSample = priorDistSample,
    priorDistDensity = priorDistDensity,
    priorDistPar1 = priorDistPar1,
    priorDistPar2 = priorDistPar2)

save(priordata, file = here::here("data", "prior_data_uk.RData"))
