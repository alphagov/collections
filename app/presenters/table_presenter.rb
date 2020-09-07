class TablePresenter
  def initialize(table)
    @table = table
  end

  def rows
    return unless valid_input?
    table[:rows].map do |row|
      row.map do |field|
        { :text => field }
      end
    end
  end

  def headings
    return unless valid_input?
    table[:headings].map do |heading|
      { :text => heading }
    end
  end

  private
  attr_reader :table

  def valid_input?
    return unless %i(headings rows).sort == table.keys.sort
    table[:rows].all? { |e| e.is_a? Array }
  end
end
