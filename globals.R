# connection pool ---------------------------------------------------------

conn <- dbConnect(
  RSQLite::SQLite(),
  dbname = 'Data/mainData.sqlite'
)

# Names -------------------------------------------------------------------

names_map <- data.frame(
  names = c('model', 'mpg', 'cyl', 'disp', 'hp', 'drat', 'wt', 'qsec', 'vs',
            'am', 'gear', 'carb', 'created_at', 'created_by', 'modified_at', 'modified_by'),
  display_names = c('Model', 'Miles/Gallon', 'Cylinders', 'Displacement (cu.in.)',
                    'Horsepower', 'Rear Axle Ratio', 'Weight (lbs)', '1/4 Mile Time',
                    'Engine', 'Transmission', 'Forward Gears', 'Carburetors', 'Created At',
                    'Created By', 'Modified At', 'Modified By'),
  stringsAsFactors = FALSE
)