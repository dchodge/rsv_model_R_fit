#include <Rcpp.h>

using namespace Rcpp;
#include "EvaluateLogLikelihood.h"

RCPP_MODULE(EvaluateLogLikelihoodModule) {
    class_<EvaluateLogLikelihood>( "EvaluateLogLikelihood" )
    .constructor<double, double, NumericVector>()
    .field( "contactMatrixPhy", &EvaluateLogLikelihood::contactMatrixPhy )
    .field( "contactMatrixCon", &EvaluateLogLikelihood::contactMatrixCon )
    .field( "observedData", &EvaluateLogLikelihood::observedData )
    .field( "lowerParamSupport", &EvaluateLogLikelihood::lowerParamSupport )
    .field( "upperParamSupport", &EvaluateLogLikelihood::upperParamSupport )
    .field( "run_full", &EvaluateLogLikelihood::run_full )
    .field( "run_start", &EvaluateLogLikelihood::run_start )
    .field( "run_burn", &EvaluateLogLikelihood::run_burn )
    .field( "run_oneyr", &EvaluateLogLikelihood::run_oneyr )

    .method( "evaluateLogLikelihoodCppWeekly", &EvaluateLogLikelihood::evaluateLogLikelihoodCppWeekly )
    .method( "evaluateLogLikelihoodCppMonthly", &EvaluateLogLikelihood::evaluateLogLikelihoodCppMonthly )
    .method( "getWeeklySampleCpp", &EvaluateLogLikelihood::getWeeklySampleCpp )
    .method( "getMonthlySampleCpp", &EvaluateLogLikelihood::getMonthlySampleCpp )
    .method( "getAnnualIncidenceCpp", &EvaluateLogLikelihood::getAnnualIncidenceCpp )
    .method( "getProportionBornProtectedCpp", &EvaluateLogLikelihood::getProportionBornProtectedCpp )

    ;
}
