require 'stock_quote'
require 'terminal-table'
require 'rainbow'

class Ticker
  SYMBOLS = %w(SPY NVDA AMD INTC SNE AAPL TSLA MSFT AMZN FBGRX DJI)

  def self.run
    while true
      system("clear")
      stocks = StockQuote::Stock.quote(SYMBOLS)

      table = Terminal::Table.new(:headings => ['Company', 'Close', 'Open', 'Last Price', '% change']) do |t|
        stocks.each do |stock|
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
