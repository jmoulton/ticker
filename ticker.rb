require 'stock_quote'
require 'terminal-table'
require 'rainbow'

class Ticker
  SYMBOLS = %w(AMD SPY DIS SQ NFLX FTEC MSFT WMT NVDA INTC SNE GOOGL TSLA DJI FB)
  CURRENT = %w(AAPL AMZN DAL)

  def self.run
    while true
      system("clear")
      stocks = StockQuote::Stock.quote(SYMBOLS.sort_by(&:downcase))
      current = StockQuote::Stock.quote(CURRENT.sort_by(&:downcase))

      table = Terminal::Table.new(:headings => ['Company', 'Close', 'Open', 'Last Price', '% change']) do |t|
        stocks.each do |stock|
          t << [stock.company_name, stock.close, stock.open, Rainbow(stock.latest_price).cyan, self.change(stock.change_percent)]
        end

        t << :separator

        current.each do |stock|
          t << [stock.company_name, stock.close, stock.open, Rainbow(stock.latest_price).cyan, self.change(stock.change_percent)]
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
