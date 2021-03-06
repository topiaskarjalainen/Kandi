//
// Created by Topias Karjalainen on 15.3.2020.
//
#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;


// [[Rcpp::export]]
arma::mat mvrnormArma(int n, arma::rowvec mu, arma::mat sigma) {
    int ncols = sigma.n_cols;
    arma::mat Y = arma::randn(n, ncols);
    return arma::repmat(mu.t(), 1, n).t() + Y * arma::chol(sigma);
}


//[[Rcpp::export]]
float ringfunc(arma::rowvec v) {
    float x = v[0];
    float y = v[1];
    return std::exp(-5 * std::abs(std::pow(x, 2) + std::pow(y, 2) - 1));
}


// [[Rcpp::export]]
arma::mat mhalgo(const int n,
                 const arma::rowvec initial,
                 const arma::mat VCOV,
                 const int burnin) {


    arma::mat samples = arma::zeros<arma::mat>(n, 2);


    arma::rowvec state = initial;
    samples.row(0) = state;

    for (int i = 1; i < n+burnin-1; ++i) {
        arma::rowvec prop = mvrnormArma(1, state, VCOV).row(0);
        float r = Rcpp::as<float>(Rcpp::runif(1, 0.0, 1.0));

        float ratio = ringfunc(prop)/ringfunc(state);

        if (r < std::fmin(1.0, ratio)) {
            state = prop;
        }
        samples.row(i) = state;
    }

    return samples;
}


