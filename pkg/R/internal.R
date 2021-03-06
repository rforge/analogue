###########################################################################
##                                                                       ##
## Internal functions for package analogue - not meant to be used by     ##
## users.                                                                ##
##                                                                       ##
###########################################################################

###########################################################################
##                                                                       ##
## cumWmean - calculates the cumulative weighted mean of y               ##
##                                                                       ##
## Created       : 27-May-2006                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 27-May-2006                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## weights           - the weights to use                                ##
## y                 - the vector of values to calculate weighted mean   ##
##                     of                                                ##
## drop              - drop spurious zero distance                       ##
##                                                                       ##
###########################################################################
cumWmean <- function(weights, y, drop = TRUE, kmax) {
    if(missing(kmax))
        kmax <- length(y)
    ##if (length(weights) != length(y))
    ##  stop("'y' and 'weights' must have the same length")
    nas <- is.na(weights)
    ord <- order(weights[!nas])
    if(drop) {
        weights <- 1 / weights[!nas][ord][-1]
        env <- y[!nas][ord][-1]
    } else {
        weights <- 1 / weights[!nas][ord]
        env <- y[!nas][ord]
    }
    K <- seq_len(kmax)
    cumsum(weights[K] * env[K]) / cumsum(weights[K])
}
###########################################################################
##                                                                       ##
## cummean - calculates the cumulative mean of y                         ##
##                                                                       ##
## Created       : 27-May-2006                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 27-May-2006                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## dis               - the distances to sort by                          ##
## y                 - the vector of values to calculate mean of         ##
## drop              - drop spurious zero distance                       ##
##                                                                       ##
###########################################################################
cummean <- function(dis, y, drop = TRUE, kmax) {
    if(missing(kmax))
        kmax <- length(y)
    nas <- is.na(dis)
    ord <- order(dis[!nas])
    y <- y[!nas][ord]
    len <- length(dis[!nas])
    if(drop) {
        y <- y[-1]
        len <- len - 1
    }
    K <- seq_len(kmax)
    ##cumsum(y) / 1:len
    cumsum(y[K]) / K
}
###########################################################################
##                                                                       ##
## minDij - returns the non-zero minimum distance                        ##
##                                                                       ##
## Created       : 27-May-2006                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 27-May-2006                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## x                 - the vector of distances for which the non-zero    ##
##                     minimum is required                               ##
##                                                                       ##
###########################################################################
minDij <- function(x, drop = TRUE)
  {
    ord <- order(x)
    if(drop)
      x[ord][2] # we don't want the first zero distance
    else
      x[ord][1]
  }
###########################################################################
##                                                                       ##
## maxBias - returns the maximum bias statistic of mat residuals         ##
##                                                                       ##
## Created       : 27-May-2006                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 27-May-2006                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## error             - model residuals                                   ##
## y                 - the vector original observed env data             ##
## n                 - number of sections to break env gradient into     ##
##                                                                       ##
###########################################################################
maxBias <- function(error, y, n = 10)
  {
    groups <- cut.default(y, breaks = n, labels = 1:n)
    bias <- tapply(error, groups, mean)
    bias[which.max(abs(bias))]
  }
###########################################################################
##                                                                       ##
## .simpleCap - simple capitalisation function from ?toupper             ##
##                                                                       ##
## Created       : 16-Feb-2007                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 16-Feb-2007                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## x - string to be capitalised                                          ##
##                                                                       ##
###########################################################################
.simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}
###########################################################################
##                                                                       ##
## wmean - simple, quick version of weighted.mean                        ##
##                                                                       ##
## Created       : 16-Feb-2007                                           ##
## Author        : Gavin Simpson                                         ##
## Version       : 0.1                                                   ##
## Last modified : 16-Feb-2007                                           ##
##                                                                       ##
## ARGUMENTS:                                                            ##
## x - string to be capitalised                                          ##
##                                                                       ##
###########################################################################
wmean <- function(spp, env) {
  sum(env * spp)/sum(spp)
}

## w.avg - fast weighted mean function with no checks
`w.avg` <- function(x, env) {
    opt <- ColSums(x * env) / ColSums(x)
    names(opt) <- colnames(x)
    opt
}

## fast rowSums and colSums functions without the checking
`RowSums` <- function(x, na.rm = FALSE) {
    dn <- dim(x)
    p <- dn[2]
    dn <- dn[1]
    .rowSums(x, dn, p, na.rm)
}

`ColSums` <- function(x, na.rm = FALSE) {
    dn <- dim(x)
    n <- dn[1]
    dn <- dn[2]
    .colSums(x, n, dn, na.rm)
}

## w.tol --- computes weighted standard deviations AKA tolerances
w.tol <- function(x, env, opt, useN2 = TRUE) {
    ## x   = species abundances
    ## env = vector of response var
    ## opt = weighted average optima
    nr <- NROW(x)
    nc <- NCOL(x)
    tol <- .C("WTOL", x = as.double(env), w = as.double(x),
              opt = as.double(opt),
              nr = as.integer(nr), nc = as.integer(nc),
              stat = double(nc), NAOK = FALSE,
              PACKAGE="analogue")$stat
    if(useN2)
        tol <- tol / sqrt(1 - (1 / sppN2(x)))
    names(tol) <- colnames(x)
    tol
}

`sppN2` <- function(x) {
    ## quickly compute Hill's N2 for species
    ## x = species abundances
    ## ONLY call within an existing function
    tot <- ColSums(x)
    x <- sweep(x, 2, tot, "/")
    x <- x^2
    H <- ColSums(x, na.rm = TRUE)
    1/H
}

