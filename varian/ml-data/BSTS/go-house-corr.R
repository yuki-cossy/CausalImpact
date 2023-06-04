library("bsts")
# read series you want to predict
# corr=raw output
# econ=drops spurious

#dat <- read.csv("corr-HSN1FNSA.csv")
dat <- read.csv("econ-HSN1FNSA.csv")
y <- zoo(dat[,2],as.Date(dat[,1]))
y.name <- "housing"

# read predictors
x <- dat[,3:ncol(dat)]


# is seasonal
is.seasonal <- T

# call bsts
source("./go-bsts.R")
