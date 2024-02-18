
class Hashmap
  attr_reader :size
  Load_factor = 0.8
  Default_size = 16
  def initialize(size = Default_size)
    @buckets = Array.new(size) {[]}
    @size = size
    @count = 0
  end

  def hash(key)
    # polynomial hashing
    prime = 31
    hash = 0
    exponent = key.length - 1
    key.each_char do |char|
      hash += char.ord * exponent
      exponent *= prime
    end
    hash
  end

  def set(key, value)
    hash_code = hash(key)
    index = hash_code % @buckets.length

    bucket = @buckets[index]
    existing_pair = bucket.find { |pair| pair[0] == key }

    if existing_pair
      existing_pair[1] = value
    else
      bucket << [key, value]
      @count += 1
    end

    if (@count.to_f / @size) > Load_factor
      resize
    end
  end

  def resize
    new_size = @size * 2
    new_buckets = Array.new(new_size) {[]}

    @buckets.each do |bucket|
      bucket.each do |key, value|
        new_hash_code = hash(key) % new_size
        new_buckets[new_hash_code] << [key, value]
      end
    end

    @buckets = new_buckets
    @size = new_size
  end

  def get(key)

    hash_code = hash(key)
    index = hash_code % @buckets.length

    bucket = @buckets[index]

    pair = bucket.find { |pair| pair[0] == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    hash_code = hash(key)
    index = hash_code % @buckets.length

    bucket = @buckets[index]
    bucket.any? { |pair| pair[0] == key }
  end

  def remove(key)
    hash_code = hash(key)
    index = hash_code % @buckets.length
    bucket = @buckets[index]

    pair_index = bucket.index { |pair| pair[0] == key }
    return nil if pair_index.nil?

    removed_pair = bucket.delete_at(pair_index)
    @count -= 1
    removed_pair[1]
  end

  def length
    @count
  end

  def clear
    @buckets.each(&:clear)
    @count = 0
  end

  def keys
    all_keys = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        all_keys << pair[0]
      end
    end
    all_keys
  end

  def values
    all_values = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        all_values << pair[1]
      end
    end
    all_values
  end

  def entries
    all_entries = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        all_entries << pair
      end
    end
    all_entries
  end

end


# Test
myhash = Hashmap.new
puts myhash.size
myhash.set('a', 1)
myhash.set('a1', 1.1)
myhash.set('z2', 26.2)
myhash.set('b', 2)
myhash.set('c', 3)
myhash.set('d', 4)
myhash.set('e', 5)
myhash.set('f', 6)
myhash.set('g', 7)
myhash.set('h', 8)
myhash.set('i', 9)
myhash.set('j', 10)
myhash.set('k', 11)
myhash.set('l', 12)
myhash.set('m', 13)
myhash.set('m1', 13.1)
myhash.set('n', 14)
myhash.set('o', 15)

puts myhash.size
puts myhash.get('e')
puts myhash.get('h')

puts myhash.has?('c')
puts myhash.has?('z')

puts myhash.remove('g')
puts myhash.remove('a')
puts myhash.has?('a')
puts myhash.has?('g')

puts myhash.length
puts myhash.keys.inspect
puts myhash.values.inspect
puts myhash.entries.inspect

myhash.clear
puts myhash.length
