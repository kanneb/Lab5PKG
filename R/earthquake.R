library(httr2)

translate_region <- function(region){

  if(region == "Africa"){
    return(list("minlatitude" = -35, "maxlatitude" = 38, "minlongitude" = -18,"maxlongitude" = 52))
  }
  else if(region == "Europe"){
    return(list("minlatitude" = 35, "maxlatitude" = 72, "minlongitude" = -25,"maxlongitude" = 66))
  }

  return(FALSE)

}



earthquake <- function(region, starttime, endtime, min_magnitude){

  coordinates <- translate_region(region)

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



  return(resp_status(resp) )


}

fe <- earthquake("Europe", "2025-01-01", "2025-01-03",1)

print(fe)
