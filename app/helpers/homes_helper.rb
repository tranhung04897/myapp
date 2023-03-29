module HomesHelper
  def vnd_currency(number)
    number_to_currency(number, unit: '', delimiter: ' ', precision: 0)
  end

  def load_value_osi(value)
    return 0 unless value.to_i.present?

    vnd_currency(value.to_i)
  end
end
