module HomesHelper
  def vnd_currency(number)
    number_to_currency(number, unit: '', delimiter: ' ', precision: 0)
  end
end
