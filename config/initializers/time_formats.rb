my_datetime_formats = { :default => '%Y-%m-%d %H:%M:%S' } #or any other you like
my_date_formats = { :default => '%Y-%m-%d' } #or any other you like

Time::DATE_FORMATS.merge!(my_datetime_formats)
Date::DATE_FORMATS.merge!(my_date_formats)