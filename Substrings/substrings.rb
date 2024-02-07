dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(string, words_array)
  string.downcase!
  string = string.split
  listing = Hash.new(0)
  words_array.each do |word|
    string.each do |s|
      if s.include?(word)
        listing[word] += 1
      end
    end
  end
  listing.reject { |_, value| value.zero? }
end

puts substrings("below", dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
