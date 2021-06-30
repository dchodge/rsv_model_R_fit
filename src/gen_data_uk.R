# MAke datafile for rsv transmission model (uk specific)
# a) Demographic parameters, change depending on country
ageGroupBoundary <- c(0:11/12, 1:5, 10, 15, 25, 35, 45, 55, 65, 75)
ageGroupNumber <- length(ageGroupBoundary)
numberDailyLiveBirths <- 1861
population <- 58744600.0

# b) Import POLYMOD matrix, must be an A x A matrix. If conversation contacts not available just turn off 'qc' parameter and initialise 'contactMatrixCon' as a zero matrix.
contactMatrixPhy <- matrix(read_table(here::here("inst", "extdata", "cntCA.txt"), col_names = FALSE )$`X1`, 25, 25)  # contact matrix for physical 
contactMatrixCon <- matrix(read_table(here::here("inst", "extdata", "cntPA.txt"), col_names = FALSE )$`X1`, 25, 25)  # contact matrix for conversational contacts

# c) Get the observation (fake data)
observationalData <- read.csv(file = here::here("inst", "extdata", "rsv_obs_data_uk.csv"))

ukdata <- list(
    ageGroupBoundary = ageGroupBoundary,
    ageGroupNumber = ageGroupNumber,
    numberDailyLiveBirths = numberDailyLiveBirths,
    population = population,
    contactMatrixPhy = contactMatrixPhy,
    contactMatrixCon = contactMatrixCon,
    observationalData = observationalData)

save(ukdata, file = here::here("data", "rsv_data_uk.RData"))
