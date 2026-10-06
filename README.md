
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Lab5PKG

<!-- badges: start -->

[![R-CMD-check](https://github.com/kanneb/Lab5PKG/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kanneb/Lab5PKG/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Lab5PKG fetches earthquake data from the USGS Earthquake API and returns
it as a data frame.

## Installation

Install from GitHub. Set the option first if you also want the vignette:

``` r
# install.packages("pak")
options(pkg.build_vignettes = TRUE)
pak::pak("kanneb/Lab5PKG")
```

## Example

``` r
library(Lab5PKG)

df <- earthquake("Europe", "2026-01-01", "2026-01-10", 3)
head(df)
#>                       time latitude longitude  depth mag magError
#> 1 2026-01-09T14:28:55.992Z  45.7294   10.6498 10.874 3.2    0.056
#> 2 2026-01-09T08:17:43.874Z  37.9262   36.6857 10.000 4.2    0.166
#> 3 2026-01-09T01:33:59.599Z  36.7011   21.5331 51.698 4.1    0.184
#> 4 2026-01-06T23:49:59.661Z  37.5127   20.3401 35.000 4.1    0.127
#> 5 2026-01-06T02:57:52.904Z  37.6824   20.9266 10.000 4.1    0.197
#> 6 2026-01-05T13:24:48.013Z  36.4933    9.2573 10.000 4.4    0.134
#>                           place  rms       type
#> 1     4 km N of Gargnano, Italy 0.64 earthquake
#> 2   19 km ESE of Göksun, Turkey 1.26 earthquake
#> 3   20 km SW of Methóni, Greece 0.54 earthquake
#> 4 48 km WSW of Lithakiá, Greece 0.90 earthquake
#> 5  9 km ESE of Lithakiá, Greece 0.73 earthquake
#> 6 4 km NNE of Tabursuq, Tunisia 0.79 earthquake
```

Available regions: Europe, Africa, Asia, Oceania, North America, South
America and Antarctica.

## More

The vignette explains the function and its error handling:

``` r
browseVignettes("Lab5PKG")
```
