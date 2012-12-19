require 'date_time_precision/lib'
require 'date'

class Date
  include DateTimePrecision

  MAX_PRECISION = DateTimePrecision::DAY

  class << self
    alias_method :new_orig, :new
    def new(*args)
      precision = self.precision(args)
      d = new_orig(*args)
      d.precision= precision
      d
    end
    
    alias_method :parse_orig, :parse
    def parse(str='-4712-01-01T00:00:00+00:00', start=ITALY)
      comp = !block_given?
      elem = _parse(str, comp)
      precision = self.precision(elem)
      d = parse_orig(str, start)
      d.precision = precision
      d
    end
    
    alias_method :civil_orig, :civil
    def civil(y=nil, m=nil, d=nil, sg=ITALY)
      vals = [y,m,d]
      precision = self.precision(vals)
      unless vals.all?
        vals = vals.compact
        vals = vals.concat(NEW_DEFAULTS.slice(vals.length, NEW_DEFAULTS.length - vals.length))
      end
      y,m,d = vals
    
      d = civil_orig(y,m,d,sg)
      d.precision = precision
      d
    end
    
    alias_method :strptime_orig, :strptime
    def strptime(date, format='%F', start=ITALY)
      elem = _strptime(date, format)
      precision = self.precision(elem)
      d = strptime_orig(date, format, start)
      d.precision = precision
      d
    end
  end

=begin
Following code is unnecessary, but keeping it as an example
  # Return the date as a human-readable string.
  #
  # The format used is YYYY-MM-DD, YYYY-MM, or YYYY.
  def to_s
    case 
    when self.precision.nil?, self.precision >= DateTimePrecision::DAY
      format('%.4d-%02d-%02d', year, mon, mday)
    when self.precision == DateTimePrecision::MONTH
      format('%.4d-%02d', year, mon)
    when self.precision == DateTimePrecision::YEAR
      format('%.4d', year)
    else
      '?'
    end
  end
=end

end