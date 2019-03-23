require 'stock_quote'
require 'terminal-table'
require 'rainbow'

class Ticker
  STOCKS  = %w(AMD DIS SQ PYPL GE BABA NFLX MSFT WMT NVDA INTC SNE GOOGL TSLA DJI FB)
  INDEXES = %w(DIA SPY IWM)
  CURRENT = %w(AAPL AMZN DAL BA)

  Terminal::Table::Style.defaults = {:width => 85}

  def self.run
    while true
      system("clear")
      stocks  = StockQuote::Stock.quote(STOCKS.sort_by(&:downcase))
      current = StockQuote::Stock.quote(CURRENT.sort_by(&:downcase))
      indexes = StockQuote::Stock.quote(INDEXES.sort_by(&:downcase))

      table = Terminal::Table.new(:headings => ['SYM', 'Close', 'Open', 'Last Price', '% change']) do |t|
        stocks.each do |stock|
          t << [stock.symbol, stock.close, stock.open, Rainbow(stock.latest_price).cyan, self.change(stock.change_percent)]
        end

        t << :separator

        indexes.each do |stock|
          t << [stock.company_name, stock.close, stock.open, Rainbow(stock.latest_price).cyan, self.change(stock.change_percent)]
        end

        t << :separator

        current.each do |stock|
          t << [stock.symbol, stock.close, stock.open, Rainbow(stock.latest_price).cyan, self.change(stock.change_percent)]
        end
      end

      puts table

      $stdout.flush
      sleep 60
    end
  end

  def self.change(val)
    val = (val * 100).round(2)
    val.negative? ? Rainbow(val.to_s).red : Rainbow(val.to_s).green
  end
end

Ticker.run
