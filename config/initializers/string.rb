class String
  def include_any?(array)
    array.any? { |i| self.include? i }
  end
end
