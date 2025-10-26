class Calculator
  def add(a, b)
    a + b
  end

  def self.multiply(a, b)
    a * b
  end

  def Calculator.divide(a, b)
    return nil if b.zero?
    a / b
  end
end
