require 'uri'
require 'open-uri'
require 'icalendar'
require 'date'
require 'pp'
require 'json'

class ICSToHTML
  def initialize(path)
    # We only export the first calendar for now
    open path do |f|
      @ics = Icalendar.parse(f.read).first
    end

    today = Date.today
    next_month = Date.parse (Date.today>>2).strftime("%Y-%m-01")
    range = (today..next_month)

    @events = @ics.events.select do |event|
      event.dtstart.between? today, next_month
    end
  end

  # https://github.com/Serhioromano/bootstrap-calendar/blob/master/events.json.php
  def to_json
    result = @events.map do |event|
      Hash[
        'id'      => event.uid,
        'title'   => event.summary,
        'start'   => event.dtstart.strftime('%Q').to_i,
        'end'     => event.dtend.strftime('%Q').to_i
      ]
    end
    Hash[
      'result' => result,
      'success' => 1
    ].to_json
  end
end