class VoteStatistic

  def initialize(client)
    @client = client
    @event_ids = client.events.ids if @client.try(:client?)
  end

  def all
    { data: data_days, best_result: best_result }
  end

  def best_result
    { day: best_day.slice(:day, :count), time: best_hour }
  end

  def data_days
    return [] if @client.nil?
    return @data_days if @data_days.present?

    data = data_by_day
    @data_days = []
    7.times do |val|
      item = data.find{|r| r['day'].to_i == val }
      count = item.nil? ? 0 : item['count']
      @data_days.push(day: val, count: count, hours: data_hours(val))
    end

    @data_days
  end

  def data_hours(day)
    result = []

    data = data_by_hour(day)
    24.times do |val|
      item = data.find{|r| r['hour'].to_i == val }
      count = item.nil? ? 0 : item['count']
      result.push(hour: val, count: count)
    end

    result
  end

  private

  def best_day
    best(data_days)
  end

  def best_hour
    best(best_day[:hours])
  end

  def best(data)
    max = data.map{|k| k[:count] }.max
    data.find{|k| k[:count] == max }
  end

  def data_by_day
    return [] if @event_ids.empty?

    sql = %Q{
      SELECT COUNT(*), EXTRACT(DOW FROM created_at) AS day
      FROM votes
      WHERE event_id IN(#{@event_ids.join(', ')})
      GROUP BY day
    }
    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def data_by_hour(day)
    return [] if  @event_ids.empty?

    sql = %Q{
      SELECT COUNT(*), EXTRACT(HOUR FROM created_at) AS hour
      FROM votes
      WHERE EXTRACT(DOW FROM created_at) = #{day} AND event_id IN(#{@event_ids.join(', ')})
      GROUP BY hour
    }
    ActiveRecord::Base.connection.execute(sql).to_a
  end

end
