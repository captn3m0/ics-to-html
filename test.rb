require './ics_to_html'

calendar = ICSToHTML.new('./test_calendar.ics')
puts calendar.to_json