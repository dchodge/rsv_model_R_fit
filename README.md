# R package implementation of the fitting part of the cpp code from Hodgson et al. 20200
## Summary

This package provides an R implementation of the fitting part of cpp code in [Hodgson et al. 2020]( https://doi.org/10.1186/s12916-020-01802-8), see [rsv_trans_model](https://github.com/dchodge/rsv_trans_model) for original cpp code. This code provides an interface for the RSV transmission model to be fitted to custom incidence data, and an example of how to do this is given using the RESCEU model comparison data. 

## Installation guide

*Quick-install instruction

Clone the repository and look through the RMarkdown files in the /vignettes folder.

## Fitting procedure overview

The fitting procedure works in several steps.

### Define the model

First a transmission model in Rcpp must be defined. Examples of these are given in `src/EvaluateLogLikelihood_X.h` header files. The transmission model is given as a class which allows it to be called into R through RCPP_MODULE. The file also contains some custom functions which allow posterior predictive sampling to occur and for the log likelihood to be calculated.

### Call the RCPP_MODULE

Once the transmission model is defined, we call an RCPP_MODULE (see `src/logliklihoodModule_X.h`) which allows features of the cpp class to be accessed and changed directly in R. This means parameters such as the observational data, population size, contact matrices, etc, can be easily customised without having to play around with cpp code. To see how this works in R see the vignettes `X/ptmc_X.Rmd`

### Defined the model and parameters

A list is then defined with four elements:
* `namesOfParameters`, a vector of the string of parameters that are to be fitted.
* `samplePriorDistributions`, a vector must be generated here for the start of the Markov Chain, can either be fixed values or form a sample. Parameters must be given in the same order as in `namesOfParameters`.
* `evaluateLogPrior`, a function which calculates the log prior of the given set of parameters. Should return a log scalar value.
* `evaluateLogLikelihood ` a function which calculates the log likelihood for a given set of parameters. Usually this is a function which is also already given from the RCPP_MODULE. 

See vignettes `X/ptmc_X.Rmd` for examples on how to define these functions.

### Fitting the model

Here we used a parallel tempering sampler (ptmc, see [dchodge/ptmc](https://github.com/dchodge/ptmc)) to fit the models, this seems to work better for large complex modules. However, given the list structured defined above, the BayesianTools (https://cran.r-project.org/web/packages/BayesianTools/index.html) package can also be easily used if that is more familiar to you.

### Checking the fit 
These are some custom functions given in `R/plot_helpers.R` which allow the posterior distributions and posterior predictive distributions to be plotted. See vignettes `X/posterior_plot_X.Rmd` for examples of the code, and the `figs/` folder for exemplar plots.

## Data sets used in this package
### Hodgson et al. 2020 

The files associated with this dataset provides an R implementation of fitting part of the transmission model cpp code [Hodgson et al. 2020]( https://doi.org/10.1186/s12916-020-01802-8). However, for data security reasons, a different dataset is used in this package compared to the weekly RDMS positive RSV samples described in the paper. This means the posteriors from this fit will not be the same as those the paper. For reference the posteriors used in the paper are given in `data/hodgson20/posteriors_true.RData`. Those wishing to use these posteriors in the model to evaluate the impact of RSV vaccination programmes should consult the repository [dchodge/rsv_model_R_custom](https://github.com/dchodge/rsv_model_R_custom).

*Note I've run a shortish simulation with the modified data and the results are given in the figs file. It hasn't converged yet (I will run a longer simulation in the near future).*

### RESCEU

A comparison of RSV models was conducted by RESCEU, whereby the RSV model structure highlighted here was fitted to RSV incidence data from Antwerp, Belgium. The full code and results of this analysis can be found in the repository [dchodge/rsv_resceu_compare](https://github.com/dchodge/rsv_resceu_compare). I have included an implementation of the fitting procedure here to give an example of how this model structure can be fitted to other country-specific RSV datasets.

### Further models

I hope to further populate this repository with other fits to different types of datasets from different countries. Feel free to contact me if this is something you are interested in and would like some advice (david.hodgson@lshtm.ac.uk). 

## Linked publications

If you wish to use any part of this code, please reference

Hodgson, D., Pebody, R., Panovska-Griffiths, J. et al. Evaluating the next generation of RSV intervention strategies: a mathematical modelling study and cost-effectiveness analysis. BMC Med 18, 348 (2020). https://doi.org/10.1186/s12916-020-01802-8

## Contact details

Please email david.hodgson@lshtm.ac.uk with any queries relating to this code.