class OrderInfomation < ApplicationRecord
  scope :get_month, lambda {
    select("MONTH(issue_date) AS month")
  }

  scope :get_year, lambda {
    select("YEAR(issue_date) AS year")
  }

  scope :by_year, lambda { |year|
    where("YEAR(issue_date) = ?", year)
  }

  scope :by_month, lambda { |month|
    where("MONTH(issue_date) = ?", month)
  }

  scope :total_by_osi_ca, lambda {
    select('osi_ca, DATE_FORMAT(issue_date, "%Y-%m") as month_date, SUM(fare + charge) AS total_value').group('osi_ca, month_date')
  }

  scope :get_month_flt, lambda {
    select("MONTH(issue_date) AS month")
  }

  scope :get_year_flt, lambda {
    select("YEAR(issue_date) AS year")
  }

  scope :by_year_flt, lambda { |year|
    where("YEAR(issue_date) = ?", year)
  }

  scope :by_month_flt, lambda { |month|
    where("MONTH(issue_date) = ?", month)
  }

  scope :order_by_class, lambda {
    order(Arel.sql("field(class_ticket, 'J', 'C', 'D', 'I', 'W', 'Z', 'U', 'Y', 'B', 'M', 'S', 'H',
                                        'K', 'L', 'Q', 'N', 'R', 'T', 'E', 'P', 'A', 'G')"))
  }
end
