# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean          default(FALSE), not null
#  email               :string           indexed
#  name                :string

class User
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_by_email(email)
    where(email: email).first
  end

  def User.create_with_defaults(email)
    new(email: email, admin: false)
  end
end
