% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survtd.R
\name{survtd}
\alias{survtd}
\title{Fit survival hazard models with time-dependent covariates}
\usage{
survtd(formula, data, id, visit.time, model = "Cox", method = "MIJM",
  M = 5, G = 5, time.trend = as.formula("~x"))
}
\arguments{
\item{formula}{A formula object, with the response on the left of a ~ operator, and the terms on the right as regressors.
The response must be a survival object as returned by the Surv function of type "right" (other types are not
supported at this stage). Time-dependent regressors are specified by the wrapper \code{td()} (see \strong{Examples} section below).
This development version does not support interactions nor terms constructed using I(). The user thus needs to create the
necessary interaction/derived variables in the dataset before using this function.}

\item{data}{A data.frame in which to interpret the variables named in the formula. The dataset needs to be in long format, with
one row per individual and per visit time at which any of the time-dependent covariates were measured, with the corresponding measurements.
The dataset must also include a variable that uniquely identifies observations from the same individual (see parameter \code{id} below);
a variable that indicates the timing of each measurement visit (see parameter \code{visit.time} below); and other fixed variables
(time-to-event, event indicator, time-fixed covariates) which are constant across rows of the same individual.}

\item{id}{The name of the variable in \code{data} that uniquely identifies observations from the same individual.}

\item{visit.time}{The name of the variable in \code{data} that indicates the timing of each visit.}

\item{model}{Indicates which hazard model to fit. Options are "Cox" for the Cox proportional hazard model and "Add" for the semi-parametric
additive hazards model.}

\item{method}{Indicates which method to use to fit the model. Options are "MIJM", "unMIJM", "LOCF" and "simple2S". Both "MIJM" and "unMIJM" use a two-stage
joint modeling approach based on multiple imputation to incorporate time-varying continuous covariates (see \strong{Details} section below).
Method "LOCF" uses the Last Observation Carried Forward (LOCF) approach. Method "simple2S" is a simple two-stage approach (see \strong{Details} section below).}

\item{M}{Number of imputations to perform for methods "MIJM" and "unMIJM" (ignored if method="LOCF" or "simple2S").}

\item{G}{Number of iterations to perform in multiple imputation by chained equations (MICE) algorithm for methods "MIJM" and "unMIJM"
(ignored if method is "LOCF" or "simple2S").}

\item{time.trend}{Formula object with empty left hand side and right hand side expressing a polynomial of "x" which determines the
way time is modeled in the fixed effects part of the linear mixed model for each time-depdent marker (ignored if method="LOCF"). Default is a linear trend
(i.e. include \code{visit.time} as predictor in the model). The random effects part includes a random intercept and slope.
Future development plans are to allow a different \code{time.trend} argument for each marker, the possibility to include
natural cubic splines in this argument and more general random effects structures.}
}
\value{
This development version returns a data frame with regression coefficient estimates for each
covariate based on the method chosen, along with standard errors, 95\%  confidence intervals and p-values.
This will change in future versions when a proper class of objects and summary and other such methods are developed.
}
\description{
\code{survtd} fits semi-parametric Cox proportional hazards or additive hazards models
with time-fixed covariates of any type and time-dependent covariates with either of these approaches:
Multiple Imputation for Joint Modeling (MIJM);Unadapted version of that approach (unMIJM);
Simple two-stage approach (simple2S); Last observation carried forward approach (LOCF).
}
\details{
The \code{survtd} function can be used to fit the Cox proportional hazards or
  semi-parametric additive hazard models with time-depedent covariates.

  Methods "MIJM" and "unMIJM" can be used to fit models with time-fixed
  covariates of any type and multiple continuous time-dependent covariates.
  To deal with the discrete-time observation of the time-varying covariates,
  particularly measurement error and missing data, a two-stage joint modeling approach
  is used that is based on multiple imputation. Details are provided in Moreno-Betancur
  et al. (2017), but briefly, in Stage 1 the true (error-corrected) values of the
  time-dependent covariates at each event time at which an individual is at risk are multiply
  imputed by drawing iteratively from smoothed trajectories based on interdependent
  linear mixed models using Multiple Imputation by Chained Equations (MICE).
  An adaptation of the \code{mice} function from the \emph{mice} package is used for this step,
  largely based on the procedure developed by Moreno-Betancur and Chavance (2016).
  In Stage 2, the time-to-event model is fitted to each of the imputed datasets
  (see below) and estimates are pooled using Rubin's MI formulas.

  The two methods "MIJM" and "unMIJM" differ in the way information about the event occurrence is
  included in the imputation models: the "unMIJM" method includes the
  the event indicator, while the "MIJM" approach is based on a more refined
  approximation including a modified event indicator (see Moreno-Betancur et al. 2017).
  Hence, the approach "MIJM" is generally preferable.

  The "simple2S" method can be used to fit models with time-fixed covariates of any type
  and multiple continuous time-dependent covariates using a simple two-stage approach.
  This method singly imputes each continuous marker at each event time from its estimated
  trajectory obtained from a linear mixed model including fixed and random effects for time
  (see description of \code{time.trend} argument) and fixed effects for the time-fixed
  covariates appearing in the formula argument. The method thus ignores: the uncertainty
  in these imputed values, the interrelations between the time-dependent markers and
  the relation between the time-dependent markers and the
  time-to-event process (see Moreno-Betancur et al. 2017).

  The "LOCF" method can be used with any type of time-fixed and time-varying covariates
  (categorical or continuous). This approach uses the last available measurement of the
  time-varying covariate to singly impute its value at each event time at which an
  individual is at risk. It can perform very poorly if the observations are not
  synchronously updated across individuals (e.g. due to missing data) and if the
  time-varying covariates are measured with error (see Moreno-Betancur et al. 2017).

  Once the values of the time-dependent covariates are imputed at each of the event-times at which
  the individual is at risk according to either of the four methods,
  the function uses \code{coxph} from the \emph{survival} package to fit the Cox model and
  \code{aalen} from the \emph{timereg} package to fit the additive model.
}
\examples{

  ## Example with additive model ##

  dat<-simjm(n=200,surv_model="Add",marker_model="RE",
            MErr="Low",Miss="High",effects="Strong",corr="Mod")

  survtd(Surv(time=tt,event=event)~Z1+Z2+td(Yij_1)+td(Yij_2)+td(Yij_3),
         data=dat,  id="ID", visit.time="tj", model="Add",
         method="MIJM", M=5, G=5,time.trend=as.formula("~x+I(x^2)"))

  survtd(Surv(time=tt,event=event)~Z1+Z2+td(Yij_1)+td(Yij_2)+td(Yij_3),
         data=dat,  id="ID", visit.time="tj", model="Add",
         method="simple2S", M=5, G=5,time.trend=as.formula("~x+I(x^2)"))

  survtd(Surv(time=tt,event=event)~Z1+Z2+td(Yij_1)+td(Yij_2)+td(Yij_3),
         data=dat,  id="ID", visit.time="tj", model="Add",
         method="LOCF", M=5, G=5)

  simjm_benchmark(dat,surv_model="Add",marker_model="RE",corr="Mod")

}
\references{
Moreno-Betancur M, Carlin JB, Brilleman SL, Tanamas S, Peeters A, Wolfe R (2017). Survival analysis
with time-dependent covariates subject to missing data or measurement error: Multiple Imputation for Joint Modeling (MIJM).
\emph{Biostatistics} [Epub ahead of print 12 Oct 2017].

Moreno-Betancur M., Chavance M. (2016) Sensitivity analysis of incomplete
longitudinal data departing from the missing at random assumption: Methodology
and application in a clinical trial with drop-outs. \emph{Statistical methods in medical research}, 25 (4), 1471-1489
[Epub ahead of print, May 22 2013]
}
