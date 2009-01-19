\name{logitreg}
\alias{logitreg}
\alias{logitreg.default}
\alias{logitreg.analog}
\alias{print.logitreg}
\alias{summary.logitreg}
\alias{print.summary.logitreg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Logistic regression models for assessing analogues/non-analogues}
\description{
  Fits logistic regression models to each level of \code{group} to
  model the probability of two samples being analogues conditional upon
  the dissimilarity between the two samples.
}
\usage{
logitreg(object, groups, k = 1, ...)

\method{logitreg}{default}(object, groups, k = 1, ...)

\method{logitreg}{analog}(object, groups, k = 1, ...)

\method{summary}{logitreg}(object, p = 0.9, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{for \code{logitreg}; a full dissimilarity matrix. For
    \code{summary.logitreg} an object of class \code{"logitreg"}, the
    result of a call to \code{logitreg}.}
  \item{groups}{factor (or object that can be coerced to one) containing
  the group membership for each sample in \code{object}.}
  \item{k}{numeric; the \code{k} closest analogues to use in the model
    fitting.}
  \item{p}{probability at which to predict the dose needed.}
  \item{\dots}{arguments passed to other methods.}
}
\details{
  Fits logistic regression models to each level of \code{group} to
  model the probability of two samples being analogues (i.e. in the same
  group) conditional upon the dissimilarity between the two samples.

  This function can be seen as a way of directly modelling the
  probability that two sites are analogues, conditional upon
  dissimilarity, that can also be done less directly using
  \code{\link{roc}} and \code{\link{bayesF}}.
}
\value{
  \code{logitreg} returns an object of class \code{"logitreg"}; a list
  whose components are objects returned by \code{\link{glm}}. See
  \code{\link{glm}} for further details on the returned objects.

  The components of this list take their names from \code{group}.

  For \code{summary.logitreg} an object of class
  \code{"summary.logitreg"}, a data frame with summary statistics of the
  model fits. The components of this data frame are:

  \item{In, Out}{The number of analogue and non-analogue dissimilarities
    analysed in each group,}
  \item{Est.(Dij), Std.Err}{Coefficient and its standard error for
    dissimilarity from the logit model,}
  \item{Z-value, p-value}{Wald statistic and associated p-value for each
    logit model.}
  \item{Dij(p=?), Std.Err(Dij)}{The dissimilarity at which the posterior
    probability of two samples being analogues is equal to \eqn{p}, and
    its standard error. These are computed using
    \code{\link[MASS]{dose.p}}.}
}
%\references{ ~put references to the literature/web site here ~ }
\author{Gavin L. Simpson}
\note{
  The function may generate warnings from function
  \code{\link{glm.fit}}. These should be investigated and not simply
  ignored.

  If the message is concerns fitted probabilities being numerically 0 or
  1, then check the fitted values of each of the models. These may well
  be numerically 0 or 1. Heed the warning in \code{\link{glm}} and read
  the reference cited therein which \strong{may} indicate problems with
  the fitted models, such as (quasi-)complete separation.
}
\seealso{\code{\link{roc}}, \code{\link{bayesF}}, \code{\link{glm}}. }
\examples{
## continue the example from ?roc
example(roc)

## fit the logit models to the analog object
swap.lrm <- logitreg(swap.ana, grps)
swap.lrm

## summary statistics
summary(swap.lrm)

## plot the fitted logit curves
plot(swap.lrm, conf.type = "polygon")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{methods}