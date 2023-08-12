# demo queries work

    Code
      tips_by_day_hour <- arrange(summarise(mutate(filter(taxi_data_2019,
        total_amount > 0), tip_pct = 100 * tip_amount / total_amount, dn = wday(
        pickup_datetime), hr = hour(pickup_datetime)), avg_tip_pct = mean(tip_pct),
      n = n(), .by = c(dn, hr)), desc(avg_tip_pct))
      tips_by_day_hour
    Output
      [1] dn          hr          avg_tip_pct n          
      <0 rows> (or 0-length row.names)

---

    Code
      tips_by_passenger <- arrange(summarise(mutate(filter(taxi_data_2019,
        total_amount > 0), tip_pct = 100 * tip_amount / total_amount), avg_tip_pct = median(
        tip_pct), n = n(), .by = passenger_count), desc(passenger_count))
      tips_by_passenger
    Output
      [1] passenger_count avg_tip_pct     n              
      <0 rows> (or 0-length row.names)

---

    Code
      popular_manhattan_cab_rides <- arrange(summarise(select(filter(inner_join(
        inner_join(filter(taxi_data_2019, total_amount > 0), zone_map, by = join_by(
          pickup_location_id == LocationID)), zone_map, by = join_by(
          dropoff_location_id == LocationID)), Borough.x == "Manhattan", Borough.y ==
        "Manhattan"), start_neighborhood = Zone.x, end_neighborhood = Zone.y),
      num_trips = n(), .by = c(start_neighborhood, end_neighborhood), ), desc(
        num_trips))
      popular_manhattan_cab_rides
    Output
      [1] start_neighborhood end_neighborhood   num_trips         
      <0 rows> (or 0-length row.names)

---

    Code
      num_trips_per_borough <- summarise(select(mutate(inner_join(inner_join(filter(
        taxi_data_2019, total_amount > 0), zone_map, by = join_by(
        pickup_location_id == LocationID)), zone_map, by = join_by(
        dropoff_location_id == LocationID)), pickup_borough = Borough.x,
      dropoff_borough = Borough.y), pickup_borough, dropoff_borough, tip_amount),
      num_trips = n(), .by = c(pickup_borough, dropoff_borough))
      num_trips_per_borough_no_tip <- summarise(mutate(inner_join(inner_join(filter(
        taxi_data_2019, total_amount > 0, tip_amount == 0), zone_map, by = join_by(
        pickup_location_id == LocationID)), zone_map, by = join_by(
        dropoff_location_id == LocationID)), pickup_borough = Borough.x,
      dropoff_borough = Borough.y, tip_amount), num_zero_tip_trips = n(), .by = c(
        pickup_borough, dropoff_borough))
      num_zero_percent_trips <- arrange(select(mutate(inner_join(
        num_trips_per_borough, num_trips_per_borough_no_tip, by = join_by(
          pickup_borough, dropoff_borough)), num_trips = num_trips,
      percent_zero_tips_trips = 100 * num_zero_tip_trips / num_trips), pickup_borough,
      dropoff_borough, num_trips, percent_zero_tips_trips), desc(
        percent_zero_tips_trips))
      num_zero_percent_trips
    Output
      [1] pickup_borough          dropoff_borough         num_trips              
      [4] percent_zero_tips_trips
      <0 rows> (or 0-length row.names)

