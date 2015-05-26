# encoding: utf-8
module Scorm
  # Represents a time interval.
  #
  # The format is ``P[yY][mM][dD][T[hH][nM][s[.s]S]]`` where:
  # * y: The number of years (integer, >= 0, not restricted)
  # * m: The number of months (integer, >= 0, not restricted)
  # * d: The number of days (integer, >= 0, not restricted)
  # * h: The number of hours (integer, >= 0, not restricted)
  # * n: The number of minutes (integer, >= 0, not restricted)
  # * s: The number of seconds or fraction of seconds (real or integer, >= 0, not restricted).
  #      If fractions of a second are used, SCORM further restricts the string
  #      to a maximum of 2 digits (e.g., 34.45 – valid, 34.45454545 – not valid).
  #
  # The character literals designators P, Y, M, D, T, H, M and S shall appear if the corresponding non-zero value is present.
  # Zero-padding of the values shall be supported.
  # Zero-padding does not change the integer value of the number being represented by a set of characters.
  # For example, PT05H is equivalent to PT5H and PT000005H.
  #
  # Example:
  #
  #   P1Y3M2DT3H indicates a period of time of 1 year, 3 months, 2 days and 3 hours
  #   PT3H5M indicates a period of time of 3 hours and 5 minutes
  #
  class TimeInterval
    # Raised whenever {Scorm::TimeInterval.parse} gets passed an invalid string
    class InvalidFormat < ArgumentError; end

    REGEX = Regexp.compile(/\AP
                            (?:(\d+)Y|Y)?                  # Year
                            (?:(\d+)M|M)?                  # Month
                            (?:(\d+)D|D)?                  # Day
                            (?:T                           # Time
                              (?:(\d+)H|H)?                #   Hours
                              (?:(\d+)M|M)?                #   Minutes
                              (?:(\d+(?:\.\d{1,2})?)S|S)?  #   Seconds
                            )
                           \Z/ix)

    attr_accessor :years, :months, :days, :hours, :minutes
    attr_writer   :seconds

    # Create TimeInterval instance and parse the interval automatically.
    #
    # @param [interval, String] Interval as described in {TimeInterval}
    # @return {TimeInterval} with all values populated
    def self.parse(interval)
      new(interval)
    end

    def self.from_seconds(seconds)
      raise InvalidFormat.new("Not a number: #{seconds}")   if !seconds.respond_to?(:to_f)
      raise InvalidFormat.new('Seconds cannot be negative') if seconds.to_f < 0

      interval  = new
      remaining = seconds.to_f

      years   = (remaining / 31557600.0).floor.to_i; remaining -= years   * 3600 * 24 * 365.25
      months  = (remaining / 2629800.0).floor.to_i;  remaining -= months  * 3600 * 24 * 30.4375
      days    = (remaining / 86400.0).floor.to_i;    remaining -= days    * 3600 * 24
      hours   = (remaining / 3600.0).floor.to_i;     remaining -= hours   * 3600
      minutes = (remaining / 60.0).floor.to_i;       remaining -= minutes * 60

      interval.years   = years
      interval.months  = months
      interval.days    = days
      interval.hours   = hours
      interval.minutes = minutes
      interval.seconds = remaining.round(2)

      interval
    end

    def initialize(interval = '')
      @raw = interval
      @years = @months = @days = 0
      @hours = @minutes = @seconds = 0

      _parse
    end

    def no_date?
      (years == 0 && months == 0 && days == 0)
    end

    def no_time?
      (hours == 0 && minutes == 0 && seconds == 0.0)
    end

    # Returns the seconds as a float, but with no more than two decimals,
    # as the standard requires.
    def seconds
      return @seconds.to_i if @seconds.to_i == @seconds
      sprintf('%0.2f', @seconds).to_f
    end

    # Return the interval marked up as described in {TimeInterval}
    # @return String
    def to_s
      return 'PT0S' if no_date? && no_time?
      parts = ['P']

      parts << "#{years.to_i}Y"  if years  > 0
      parts << "#{months.to_i}M" if months > 0
      parts << "#{days.to_i}D"   if days   > 0
      return parts.join if no_time?

      parts << "T"
      parts << "#{hours.to_i}H"   if hours   > 0
      parts << "#{minutes.to_i}M" if minutes > 0
      parts << "#{seconds}S"      if seconds > 0

      parts.join
    end

    # Return the interval as seconds
    # @return Float
    def to_f
      return years   * 3600 * 24 * 365.25 +
             months  * 3600 * 24 * 30.4375 +
             days    * 3600 * 24 +
             hours   * 3600 +
             minutes * 60 +
             seconds
    end

    def _parse
      return if @raw == ''

      match = @raw.match(REGEX)
      if !match || match[1..-1].all?(&:nil?)
        raise InvalidFormat.new("#{@raw} is not a valid time interval")
      end

      year, month, day, hour, minute, second = match[1..-1].collect(&:to_i)
      @years   = year   || 0
      @months  = month  || 0
      @days    = day    || 0
      @hours   = hour   || 0
      @minutes = minute || 0
      @seconds = second || 0.0
    end
  end
end
