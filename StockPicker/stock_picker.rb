def stock_picker(stock_prices)
  pairs = [[]]
  prev_price = 0
  # group pairs based on least min and most max
  stock_prices.each do |price|
    if price >= prev_price
      pairs[-1].push(price)
      prev_price = price
    else
      pairs.push([])
      pairs[-1].push(price)
      prev_price = price
    end
  end
  # remove pairs with one day
  pairs.reject! { |pair| pair.length <= 1 }
  # calculate profits and add to new array
  pairs.each { |pair| pair.push(pair[-1] - pair[0]) }
  profits = pairs.map { |pair| pair[-1] }
  # Get pair with highest profits
  profit_pair = pairs[profits.index(profits.max)]
  # get index of profitable buying and selling date
  buy_date = stock_prices.index(profit_pair[0])
  sell_date = stock_prices.index(profit_pair[-2])
  days = ["Best day to buy: #{buy_date}, Best day to sell: #{sell_date}"]

  days
end


puts stock_picker([17,3,6,9,15,8,6,1,10])
