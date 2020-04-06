//
// Created by Topias Karjalainen on 5.4.2020.
//

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
double updateBeta0(double beta1, double beta2, double tau, double d, double d1, arma::mat mat);

double updateBeta1(double beta0, double beta2, double tau, double d, double d1, arma::mat mat);

double updateBeta2(double beta1, double beta2, double tau, double d, double d1, arma::mat mat);

double updatetau(double beta0, double beta1, double beta2, double d, double d1, arma::mat mat);

using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
arma::mat sampleGibbs(int n,
                      arma::mat data,
                      arma::rowvec initial,
                      arma::rowvec hypers) {


    // hyperparameters
    double mu0 = hypers(0);
    double mu1 = hypers(1);
    double mu2 = hypers(2);
    double tau0 = hypers(3);
    double tau1 = hypers(4);
    double tau2 = hypers(5);
    double alpha = hypers(6);
    double gamma = hypers(7);


    // init returnable
    arma::mat samples = arma::zeros<arma::mat>(n, 4);
    samples.row(0) = initial;


    // init parameters
    double beta0 = initial(0);
    double beta1 = initial(1);
    double beta2 = initial(2);
    double tau = initial(3);

    // iterating
    for (int i = 1; i < n - 1; ++i) {
        beta0 = updateBeta0(beta1, beta2, tau, mu0, tau0, data);
        beta1 = updateBeta1(beta0, beta2, tau, mu1, tau1, data);
        beta2 = updateBeta2(beta0, beta1, tau, mu2, tau2, data);
        tau = updatetau(beta0, beta1, beta2, alpha, gamma, data);
        //append samples
        arma::rowvec row = arma::rowvec(4);
        row(0) = beta0;
        row(1) = beta1;
        row(2) = beta2;
        row(3) = tau;
        samples.row(i) = row;
    }


    return samples;
}

double updatetau(double beta0, double beta1, double beta2, double alpha, double gamma, arma::mat data) {
    arma::vec y = data.col(0);
    arma::vec x1 = data.col(1);
    arma::vec x2 = data.col(2);

    int N = y.n_elem;

    double summa = 0.0;

    for (int i = 0; i < N; ++i) {
        double s = y(i) - beta0 - beta1 * x1(i) - beta2 * x2(i);
        summa += std::pow(s, 2.0);
    }

    return Rcpp::as<double>(Rcpp::rgamma(1,alpha + (N/2), gamma + (N/2) * summa));
}

double updateBeta2(double beta0, double beta1, double tau, double mu2, double tau2, arma::mat data) {

    double summaXsquare = 0.0;

    arma::vec y = data.col(0);
    arma::vec x1 = data.col(1);
    arma::vec x2 = data.col(2);

    int N = x2.n_elem;

    for (int j = 0; j < N; ++j) {
        summaXsquare += std::pow(x2(j),2.0);
    }

    double precision = tau2 + tau * summaXsquare;

    double summa = 0.0;
    for (int i = 0; i < N; ++i) {
        summa += (y(i) - beta0 - beta1 * x1(i)) * x2(i);
    }

    double mean = (tau2 * mu2 + tau * summa)/precision;

    return Rcpp::as<double>(Rcpp::rnorm(1, mean, 1.0/precision));
}


double updateBeta1(double beta0, double beta2, double tau, double mu1, double tau1, arma::mat data) {

    double summaXsquare = 0.0;
    arma::vec y = data.col(0);
    arma::vec x1 = data.col(1);
    arma::vec x2 = data.col(2);

    int N = x1.n_elem;

    for (int j = 0; j < N; ++j) {
        summaXsquare += std::pow(x1(j),2.0);
    }

    double precision = tau1 + tau * summaXsquare;

    double summa = 0.0;
    for (int i = 0; i < N; ++i) {
        summa += (y(i) - beta0 - beta2 * x2(i)) * x1(i);
    }

    double mean = (tau1 * mu1 + tau * summa)/precision;

    return Rcpp::as<double>(Rcpp::rnorm(1, mean, 1.0/precision));
}

double updateBeta0(double beta1, double beta2, double tau, double mu0, double tau0, arma::mat data) {
    arma::vec y = data.col(0);
    arma::vec x1 = data.col(1);
    arma::vec x2 = data.col(2);

    int N = y.n_elem;
    double precision = tau0 + tau * N;

    double summa = 0.0;
    for (int i = 0; i < N; ++i) {
        summa += y(i) - beta1 * x1(i) - beta2 * x2(i);
    }

    double mean = (tau0 * mu0 + tau * summa)/precision;

    return Rcpp::as<double>(Rcpp::rnorm(1, mean, 1.0/precision));
}
