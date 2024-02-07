def bubble_sort(array)
  len = array.length
  sorted = false
  until sorted
    sorted = true
    for i in (1..len-1)
      if array[i-1] > array[i]
        array[i-1], array[i] = array[i], array[i-1]
        sorted = false
      end
    end
  end
  array

end


puts bubble_sort([4,3,78,2,0,2])
