// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// mvrnormArma
arma::mat mvrnormArma(int n, arma::rowvec mu, arma::mat sigma);
RcppExport SEXP _helperfunctions_mvrnormArma(SEXP nSEXP, SEXP muSEXP, SEXP sigmaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< arma::rowvec >::type mu(muSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type sigma(sigmaSEXP);
    rcpp_result_gen = Rcpp::wrap(mvrnormArma(n, mu, sigma));
    return rcpp_result_gen;
END_RCPP
}
// ringfunc
float ringfunc(arma::rowvec v);
RcppExport SEXP _helperfunctions_ringfunc(SEXP vSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::rowvec >::type v(vSEXP);
    rcpp_result_gen = Rcpp::wrap(ringfunc(v));
    return rcpp_result_gen;
END_RCPP
}
// mhalgo
arma::mat mhalgo(const int n, const arma::rowvec initial, const arma::mat VCOV, const int burnin);
RcppExport SEXP _helperfunctions_mhalgo(SEXP nSEXP, SEXP initialSEXP, SEXP VCOVSEXP, SEXP burninSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const arma::rowvec >::type initial(initialSEXP);
    Rcpp::traits::input_parameter< const arma::mat >::type VCOV(VCOVSEXP);
    Rcpp::traits::input_parameter< const int >::type burnin(burninSEXP);
    rcpp_result_gen = Rcpp::wrap(mhalgo(n, initial, VCOV, burnin));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_helperfunctions_mvrnormArma", (DL_FUNC) &_helperfunctions_mvrnormArma, 3},
    {"_helperfunctions_ringfunc", (DL_FUNC) &_helperfunctions_ringfunc, 1},
    {"_helperfunctions_mhalgo", (DL_FUNC) &_helperfunctions_mhalgo, 4},
    {NULL, NULL, 0}
};

RcppExport void R_init_helperfunctions(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
