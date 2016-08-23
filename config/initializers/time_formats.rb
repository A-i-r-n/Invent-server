# my_datetime_formats = { :default => '%Y-%m-%d %H:%M:%S' } #or any other you like
# my_date_formats = { :default => '%Y-%m-%d' } #or any other you like
#
# Time::DATE_FORMATS.merge!(my_datetime_formats)
# Date::DATE_FORMATS.merge!(my_date_formats)

ActiveSupport::JSON::Encoding.time_precision = 0

ActiveSupport::JSON::Encoding.use_standard_json_time_format = false


# Date::DATE_FORMATS[:default] = '%Y-/%m/%d'
# Time::DATE_FORMATS[:default] = '%Y-/%m/%d %H:%M:%S'