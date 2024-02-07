


def st_pckr(stock_prices)
  max_profit = 0
  best_buy_date = nil
  best_sell_date = nil

  stock_prices.each_with_index do |buy_price, buy_date|
    stock_prices[buy_date+1..].each_with_index do |sell_price, sell_date|
      profit = sell_price - buy_price
      if profit > max_profit
        max_profit = profit
        best_buy_date = buy_date
        best_sell_date = sell_date + buy_date + 1
      end
    end
  end
  if best_buy_date && best_sell_date
    return ["Best day to buy: #{best_buy_date}, Best day to sell: #{best_sell_date}"]
  else
    return ["No profitable trade possible"]
  end
end

puts st_pckr([17,6,6,9,15,8,6,1,10])
