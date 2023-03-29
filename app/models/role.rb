class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  RoleMapping = {
    admin: "Admin",
    manager: "Manager",
    staff: "Staff",
  }

  def admin?
    name == 'admin'
  end
end
