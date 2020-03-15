cmake_minimum_required(VERSION 3.15)
project(kandi_stuff)

add_library(test SHARED src/RcppExports.cpp)

include_directories(/Library/Frameworks/R.framework/Headers)
include_directories(/Library/Frameworks/R.framework/Resources/library/Rcpp/include)
include_directories(/Library/Frameworks/R.framework/Versions/3.6/Resources/library/RcppArmadillo/include)

