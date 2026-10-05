translate_region <- function(region){
  "Returns a given regions coordinates"
  switch(region,
         "Europe"        = list(minlatitude =  36, maxlatitude = 82, minlongitude =  -25, maxlongitude =  52),
         "Africa"        = list(minlatitude = -40, maxlatitude = 36, minlongitude =  -25, maxlongitude =  52),
         "Asia"          = list(minlatitude = -11, maxlatitude = 82, minlongitude =   52, maxlongitude = 170),
         "Oceania"       = list(minlatitude = -60, maxlatitude = -11, minlongitude = 110, maxlongitude = 210),
         "North America" = list(minlatitude =   7, maxlatitude = 84, minlongitude = -190, maxlongitude = -25),
         "South America" = list(minlatitude = -56, maxlatitude =  7, minlongitude =  -92, maxlongitude = -25),
         "Antarctica"    = list(minlatitude = -90, maxlatitude = -60, minlongitude = -180, maxlongitude = 180),
         NULL
  )
}

#'Earthquake API fetcher
#'
#'Get data about earthquake
#'
#'@param region user selected continent
#'@param starttime user selected start date
#'@param endtime user selected end time
#'@param min_magnitude user selected minimum magnitude
#'
#'@importFrom httr2 request req_url_query req_timeout req_perform resp_body_string
#'@importFrom utils read.csv
#'@export
earthquake <- function(region, starttime, endtime, min_magnitude){

  stopifnot("Magnitude must be a single number" = is.numeric(min_magnitude) && length(min_magnitude) == 1,
            "Magnitude must be 0 or higher" = min_magnitude >= 0,
            "Not valid region" = region %in% c("Asia", "Africa", "Europe", "South America",
                                               "North America", "Antarctica", "Oceania"),
            "Start time must be a date string like 2025-01-01" = is.character(starttime) &&
              !is.na(as.Date(starttime, format = "%Y-%m-%d")),
            "End time must be a date string like 2025-01-01" = is.character(endtime) &&
              !is.na(as.Date(endtime, format = "%Y-%m-%d")),
            "End time must be after start time" = as.Date(endtime) > as.Date(starttime))

  coordinates <- translate_region(region)
  if (is.null(coordinates)) stop("Invalid coordinates, Internal error")

  #REQUEST
  resp <- tryCatch(
            request("https://earthquake.usgs.gov/fdsnws/event/1/query") |>
                  req_url_query(format = "csv",
                  starttime = starttime, endtime = endtime,
                  minmagnitude = min_magnitude,
                  minlatitude = coordinates$minlatitude,
                  maxlatitude = coordinates$maxlatitude,
                  minlongitude = coordinates$minlongitude,
                  maxlongitude = coordinates$maxlongitude) |>
                  req_timeout(30) |>
                  req_perform(),
            error = function(e) {
              stop("Could not fetch data! ", conditionMessage(e), call. = FALSE)
            }
  )


  # Turning response to data.frame
  text_resp <- resp_body_string(resp)
  df <- read.csv(text = text_resp) |>
    subset(select = c("time", "latitude", "longitude", "depth", "mag", "magError", "place", "rms", "type"))

  # Returning data.frame
  return(df)
}
