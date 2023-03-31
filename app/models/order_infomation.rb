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
    select('osi_ca, DATE_FORMAT(flt_date, "%Y-%m") as month_date, SUM(fare + charge) AS total_value').group('osi_ca, month_date')
  }

  scope :get_month_flt, lambda {
    select("MONTH(flt_date) AS month")
  }

  scope :get_year_flt, lambda {
    select("YEAR(flt_date) AS year")
  }

  scope :by_year_flt, lambda { |year|
    where("YEAR(flt_date) = ?", year)
  }

  scope :by_month_flt, lambda { |month|
    where("MONTH(flt_date) = ?", month)
  }

  scope :order_by_class, lambda {
    order(Arel.sql("field(class_ticket, 'J', 'C', 'D', 'I', 'W', 'Z', 'U', 'Y', 'B', 'M', 'S', 'H',
                                        'K', 'L', 'Q', 'N', 'R', 'T', 'E', 'P', 'A', 'G')"))
  }

  scope :load_value_by_osi, lambda {
    select('osi_ca, DATE_FORMAT(flt_date, "%m/%Y") as month_date, SUM(fare + charge) AS total_value')
      .where.not(osi_ca: ['', nil])
      .group('osi_ca, month_date')
  }

  scope :load_value_by_booker, lambda {
    select('osi_booker, DATE_FORMAT(flt_date, "%m/%Y") as month_date, SUM(fare + charge) AS total_value')
      .where.not(osi_ca: ['', nil])
      .group('osi_booker, month_date')
  }

  scope :flt_date_range, lambda { |start_date, end_date|
    where("flt_date BETWEEN ? AND ?", start_date, end_date)
  }
end
