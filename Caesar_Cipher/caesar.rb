def caesar_cipher(string, shift)
  string_bytes = string.bytes
  string_bytes.map! do |byte|
    if byte.between?(65,90)  #A-Z
      ((byte + shift - 65) % 26 + 65).chr
    elsif byte.between?(97,122)   #a-z
      ((byte + shift - 97) % 26 + 97).chr
    else
      byte.chr
    end
  end
  string_bytes.join
end


word = "What a string!"
puts word
puts caesar_cipher(word,5)
