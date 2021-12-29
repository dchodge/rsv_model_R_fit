
library(Rcpp)       # For c++ intergration
library(RcppEigen)  # Ditto
library(coda)       # Ditto
library(tidyverse)
library(parallel)
library(MASS)
library(foreach)
library(gridExtra)
library(doParallel)
library(BayesianTools)
library(devtools)
library(here)
source( here::here("src", "helpers.R")) #ensure c++14 is enabled

args <- commandArgs()
num <- as.character(args[6])

#install_github(repo = "https://github.com/dchodge/ptmc")
library(ptmc)

load(file = here::here("data", "rsv_data_resceu.RData")) # loads ukdata
load(file = here::here("data", "prior_data_resceu.RData")) # loads priordata

sourceCpp(here("src", "logLikelihoodModule.cpp")) #ensure c++14 is enabled
classEvaluateLogLikelihood <- new(EvaluateLogLikelihood, resceudata$numberDailyLiveBirths, resceudata$population, resceudata$ageGroupBoundary) # Calls class
classEvaluateLogLikelihood$contactMatrixPhy <- resceudata$contactMatrixPhy
classEvaluateLogLikelihood$contactMatrixCon <- resceudata$contactMatrixCon
classEvaluateLogLikelihood$observedData <- as.matrix(resceudata$observationalData)
classEvaluateLogLikelihood$lowerParamSupport <- priordata$fit.par$lowerParSupport
classEvaluateLogLikelihood$upperParamSupport <- priordata$fit.par$upperParSupport
classEvaluateLogLikelihood$run_start <- 0
classEvaluateLogLikelihood$run_burn <- 30 * 12 + 1
classEvaluateLogLikelihood$run_oneyr <- 30 * 12 + classEvaluateLogLikelihood$run_burn
classEvaluateLogLikelihood$run_full <- 30 * 12 # number of days to fit the data and model to

model <- list(

  namesOfParameters =  c("xi", "si", "g0", "g1", "g2", "om","pA1", "pA2", "pA3", "pA4", "alpha_i", "d1", "d2", "d3", "phi", "qp", "qc", "b1", "psi", "c5ep1", "c5ep2","ep5", "ep6", "l1", "l2"),

  # Generate the initial step of Markov chain
  samplePriorDistributions = function() {
      s <- vector()
      for (i in 1:25) {
        s[i] <- prior.sample(priordata$fit.par$lowerParSupport[i], priordata$fit.par$upperParSupport[i], 
        priordata$priorDistSample[[i]], priordata$priorDistPar1[i], priordata$priorDistPar2[i])
      }
      s
    },

  evaluateLogPrior = function(params) {
    p = 0
    for (i in 1:25){
        if (params[i] < priordata$fit.par$lowerParSupport[i] || params[i] > priordata$fit.par$upperParSupport[i]) {
            return(log(0))
        }
        else{
            p <- p + prior(params[i], priordata$fit.par$lowerParSupport[i], priordata$fit.par$upperParSupport[i], 
              priordata$priorDistDensity[[i]], TRUE, priordata$priorDistPar1[i], priordata$priorDistPar2[i])
        }
    }
    return(p)
  },

  # Evaluate the log likelihood
  evaluateLogLikelihood = function(params, covariance) {
    ll <- classEvaluateLogLikelihood$evaluateLogLikelihoodCppMonthly(params)
    return(ll)
  }
)

settingsPT <-  list(
  numberChainRuns = 1,
  numberTempChains = 12,
  iterations = 500000,
  burninPosterior = 100000,
  thin = 10,
  consoleUpdates = 100,
  numberFittedPar = 25,
  onAdaptiveCov = TRUE,
  updatesAdaptiveCov = 10,
  burninAdaptiveCov = 30000,
  onAdaptiveTemp = TRUE,
  updatesAdaptiveTemp = 1,
  onDebug = FALSE,
  lowerParBounds = priordata$fit.par$lowerParSupport,
  upperParBounds = priordata$fit.par$upperParSupport
)


output1 <- ptmc_func(model, settingsPT)
#taskIdChar <- Sys.getenv("SGE_TASK_ID")

save(output1, file = here("data", paste0("posteriors_resceu_", num, ".RData")))