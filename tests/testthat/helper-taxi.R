taxi_data_2019 <- as_duckplyr_df(data.frame(
  vendor_name = character(0),
  pickup_datetime = as.POSIXct(character(0), tz = "UTC"),
  dropoff_datetime = as.POSIXct(character(0), tz = "UTC"),
  passenger_count = numeric(0),
  trip_distance = numeric(0),
  pickup_longitude = numeric(0),
  pickup_latitude = numeric(0),
  rate_code = character(0),
  store_and_fwd = character(0),
  dropoff_longitude = numeric(0),
  dropoff_latitude = numeric(0),
  payment_type = character(0),
  fare_amount = numeric(0),
  extra = numeric(0),
  mta_tax = numeric(0),
  tip_amount = numeric(0),
  tolls_amount = numeric(0),
  total_amount = numeric(0),
  improvement_surcharge = numeric(0),
  congestion_surcharge = numeric(0),
  pickup_location_id = numeric(0),
  dropoff_location_id = numeric(0),
  year = character(0),
  month = character(0)
))

zone_map <- as_duckplyr_df(data.frame(
  LocationID = numeric(0),
  Borough = character(0),
  Zone = character(0),
  service_zone = character(0)
))
