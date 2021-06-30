# MAke datafile for rsv transmission model (uk specific)
# a) Demographic parameters, change depending on country
ageGroupBoundary <- c(0:11/12, 1:5, 10, 15, 25, 35, 45, 55, 65, 75)
ageGroupNumber <- length(ageGroupBoundary)
numberDailyLiveBirths <- round(100000 / 365)
population <-  8867713

# b) Import POLYMOD matrix, must be an A x A matrix. If conversation contacts not available just turn off 'qc' parameter and initialise 'contactMatrixCon' as a zero matrix.
contactMatrixPhy <- matrix(read_table(here::here("inst", "extdata", "cntCA.txt"), col_names = FALSE )$`X1`, 25, 25)  # contact matrix for physical 
contactMatrixCon <- matrix(read_table(here::here("inst", "extdata", "cntPA.txt"), col_names = FALSE )$`X1`, 25, 25)  # contact matrix for conversational contacts

# c) Get the observation
observationalData_raw <- read.csv(file = here::here("inst", "extdata", "resceu_raw.csv"))
ncols_raw <- dim(observationalData_raw)[2]
age_strat <- list(
    "<1mo" = c(2, 2),
    "1mo" = c(3, 3),
    "2mo" = c(4, 4),
    "3mo" = c(5, 5),
    "4mo" = c(6, 6),
    "5mo" = c(7, 7),
    "6mo" = c(8, 8),
    "7mo" = c(9, 9),
    "8mo" = c(10, 10),
    "9mo" = c(11, 11),
    "10mo" = c(12, 12),
    "11mo" = c(13, 13),
    "1yr" = c(14, 13 + 12),
    "2yr" = c(13 + 12 + 1, 13 + 24),
    "3yr" = c(13 + 24 + 1, 13 + 36),
    "4yr" = c(13 + 36 + 1, 13 + 48),
    "5-9yrs" = c(62, 62),
    "10-14yrs" = c(63, 63),
    "15-24yrs" = c(64, 65),
    "25-34hrs" = c(66, 67),
    "35-44yrs" = c(68, 69),
    "45-54hrs" = c(70, 71),
    "55-64yrs" = c(72, 73),
    "65-74yrs" = c(74, 75),
    "75+yrs" = c(76, 77)
)

observational_data_list <- vector(mode = "list", length = 25)
for (i in 1:25) {
    if ( i < 25)
        observational_data_list[[i]] <- apply(observationalData_raw[age_strat[[i]][1]:age_strat[[i]][2]], 1, sum) / 1000 * 100000 * (ageGroupBoundary[i + 1] - ageGroupBoundary[i])
    else 
         observational_data_list[[i]] <- apply(observationalData_raw[age_strat[[i]][1]:age_strat[[i]][2]], 1, sum) / 1000 * (population - 100000*ageGroupBoundary[i-1])
}
observationalData <- bind_cols(observational_data_list) %>% as.data.frame
observationalData <- bind_rows(observationalData[7:12, ], observationalData[1:6, ])

resceudata <- list(
    ageGroupBoundary = ageGroupBoundary,
    ageGroupNumber = ageGroupNumber,
    numberDailyLiveBirths = numberDailyLiveBirths,
    population = population,
    contactMatrixPhy = contactMatrixPhy,
    contactMatrixCon = contactMatrixCon,
    observationalData = observationalData)

save(resceudata, file = here::here("data", "rsv_data_resceu.RData"))
