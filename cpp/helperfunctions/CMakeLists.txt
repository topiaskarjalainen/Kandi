cmake_minimum_required(VERSION 3.15)
project(helperfunctions)

add_library(test SHARED src/RcppExports.cpp src/helper.cpp)

include_directories(/Library/Frameworks/R.framework/Headers)
include_directories(/Library/Frameworks/R.framework/Resources/library/Rcpp/include)
include_directories(/Library/Frameworks/R.framework/Versions/3.6/Resources/library/RcppArmadillo/include)

