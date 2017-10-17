
<!-- README.md is generated from README.Rmd. Please edit that file -->
survtd
======

[![License](License-GPL-image.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

**survtd** is an R package to fit semi-parametric Cox or additive hazards regression models with time-fixed covariates of any type and multiple continuous time-dependent covariates subject to missing data, measurement error or simply observed in discrete time.

All these issues are handled with the two-stage Multiple Imputation for Joint Modeling (MIJM) approach developed by Moreno-Betancur et al. (2017). Briefly, the MIJM approach uses an adapted multiple imputation by chained equations procedure to impute true values of each marker at each event time.

The package also provides easy-to-use implementations of an unadapted version of the approach (unMIJM); a simple two-stage approach (simple2S), based on single imputation of the continuous markers from linear mixed models; and the last observation carried forward (LOCF) approach for time-dependent covariates of any type, which is the traditional method to incoporate these in hazard models. Data simulation functions also included.

**Note:** Please note that the version available on GitHub is the most up-to-date *development* version of the package. A stable version of the package will be available from CRAN once it is released.

Getting Started
---------------

### Prerequisites

The **survtd** package requires the following packages: **lme4**, **survival**, **timereg**, **mice**, **boot**, **ipw**, **stringr**, **MASS**, **Matrix**.

### Installation

The **survtd** package can be installed directly from GitHub using the **devtools** package, which must be first installed from CRAN by the user to proceed. Then it suffices to execute the following commands to install **survtd**:

``` r
library(devtools)
install_github("moreno-betancur/survtd")
```

### Reference manual

The full reference manual of the package can be dowloaded [here](https://rawgit.com/moreno-betancur/Reference_manuals/master/survtd.pdf).

Example
-------

An example of usage of the package will be added soon.

Bug Reports
-----------

If you find any bugs, please report them via email to [Margarita Moreno-Betancur](mailto:margarita.moreno@mcri.edu.au).

References
----------

Moreno-Betancur M, Carlin JB, Brilleman SL, Tanamas S, Peeters A, Wolfe R (2017). [Survival analysis with time-dependent covariates subject to missing data or measurement error: Multiple Imputation for Joint Modeling (MIJM).](https://academic.oup.com/biostatistics/article-abstract/doi/10.1093/biostatistics/kxx046/4461848/Survival-analysis-with-time-dependent-covariates?redirectedFrom=fulltext) *Biostatistics* \[Epub ahead of print 12 Oct 2017\].

Moreno-Betancur M., Chavance M. (2016) [Sensitivity analysis of incomplete longitudinal data departing from the missing at random assumption: Methodology and application in a clinical trial with drop-outs.](http://journals.sagepub.com/doi/abs/10.1177/0962280213490014) *Statistical methods in medical research*, 25 (4), 1471-1489 \[Epub ahead of print, May 22 2013\].
