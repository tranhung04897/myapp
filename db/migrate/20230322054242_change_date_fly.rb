class ChangeDateFly < ActiveRecord::Migration[7.0]
  def up
    orders = OrderInfomation.all
    orders.each do |order|
      fly_date = order.flt_date.split('-').first
      next if fly_date.blank?

      issue_date_year = order.issue_date.year
      fly_date = fly_date.to_date
      fly_date = fly_date.change(year: issue_date_year)
      case order.type_ticket
      when 'S'
        if fly_date < order.issue_date
          fly_date = fly_date.change(year: issue_date_year + 1)
        end
      else
        if fly_date < order.issue_date
          fly_date = fly_date.change(year: issue_date_year - 1)
        end
      end
      order.update(flt_date: fly_date.to_s)
    end
  end

  def down
    # Irreversible
  end
end
