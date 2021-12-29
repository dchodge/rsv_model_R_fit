# File to contain all the information about the priors in the model
# a) Parameters which are fitted in the model, (there's a lot of parameters!!!!)
fit.par <- data.frame(
  namesOfParameters = c("alpha_i", "phi", "qp", "qc", "b1", "psi", "ep1", "ep2", "ep3", "ep4", "ep5", "ep6", "ep7", "ep8", "ep9", "l1", "l2"),
  lowerParSupport = c(0, 0, 0, 0,          0,    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  # lower boundary 
  upperParSupport = c(1, 1.0, 1.0, 1.00, 10,  1,  1, 1,  1, 1, 1, 1, 1, 1, 1, 1, 1),
  fit_indicator= rep(1, 17)
)

# b) import the prior distributions associated with each of the parameters
priorDistSample <- list(runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif, runif)
priorDistDensity <- list(dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif, dunif)
priorDistPar1 <- c(0, 0.0, 0.0, 0.0,        0,  0,  0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
priorDistPar2 <- c(1, 1, 0.1, 1,            10, 1,  0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 1, 1)

priordata <- list(
    fit.par = fit.par,
    priorDistSample = priorDistSample,
    priorDistDensity = priorDistDensity,
    priorDistPar1 = priorDistPar1,
    priorDistPar2 = priorDistPar2)

save(priordata, file = here::here("data", "resceu", "prior_data_resceu.RData"))
