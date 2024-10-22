# demo queries work

    Code
      tips_by_day_hour <- taxi_data_2019 %>% filter(total_amount > 0) %>% mutate(
        tip_pct = 100 * tip_amount / total_amount, dn = wday(pickup_datetime), hr = hour(
          pickup_datetime)) %>% summarise(avg_tip_pct = mean(tip_pct), n = n(), .by = c(
        dn, hr)) %>% arrange(desc(avg_tip_pct))
      tips_by_day_hour
    Output
      [1] dn          hr          avg_tip_pct n          
      <0 rows> (or 0-length row.names)

---

    Code
      tips_by_passenger <- taxi_data_2019 %>% filter(total_amount > 0) %>% mutate(
        tip_pct = 100 * tip_amount / total_amount) %>% summarise(avg_tip_pct = median(
        tip_pct), n = n(), .by = passenger_count) %>% arrange(desc(passenger_count))
      tips_by_passenger
    Output
      [1] passenger_count avg_tip_pct     n              
      <0 rows> (or 0-length row.names)

---

    Code
      popular_manhattan_cab_rides <- taxi_data_2019 %>% filter(total_amount > 0) %>%
        inner_join(zone_map, by = join_by(pickup_location_id == LocationID)) %>%
        inner_join(zone_map, by = join_by(dropoff_location_id == LocationID)) %>%
        filter(Borough.x == "Manhattan", Borough.y == "Manhattan") %>% select(
        start_neighborhood = Zone.x, end_neighborhood = Zone.y) %>% summarise(
        num_trips = n(), .by = c(start_neighborhood, end_neighborhood), ) %>% arrange(
        desc(num_trips))
      popular_manhattan_cab_rides
    Output
      [1] start_neighborhood end_neighborhood   num_trips         
      <0 rows> (or 0-length row.names)

---

    Code
      num_trips_per_borough <- taxi_data_2019 %>% filter(total_amount > 0) %>%
        inner_join(zone_map, by = join_by(pickup_location_id == LocationID)) %>%
        inner_join(zone_map, by = join_by(dropoff_location_id == LocationID)) %>%
        mutate(pickup_borough = Borough.x, dropoff_borough = Borough.y) %>% select(
        pickup_borough, dropoff_borough, tip_amount) %>% summarise(num_trips = n(),
      .by = c(pickup_borough, dropoff_borough))
      num_trips_per_borough_no_tip <- taxi_data_2019 %>% filter(total_amount > 0,
      tip_amount == 0) %>% inner_join(zone_map, by = join_by(pickup_location_id ==
        LocationID)) %>% inner_join(zone_map, by = join_by(dropoff_location_id ==
        LocationID)) %>% mutate(pickup_borough = Borough.x, dropoff_borough = Borough.y,
        tip_amount) %>% summarise(num_zero_tip_trips = n(), .by = c(pickup_borough,
        dropoff_borough))
      num_zero_percent_trips <- num_trips_per_borough %>% inner_join(
        num_trips_per_borough_no_tip, by = join_by(pickup_borough, dropoff_borough)) %>%
        mutate(num_trips = num_trips, percent_zero_tips_trips = 100 *
          num_zero_tip_trips / num_trips) %>% select(pickup_borough, dropoff_borough,
        num_trips, percent_zero_tips_trips) %>% arrange(desc(percent_zero_tips_trips))
      num_zero_percent_trips
    Output
      [1] pickup_borough          dropoff_borough         num_trips              
      [4] percent_zero_tips_trips
      <0 rows> (or 0-length row.names)

