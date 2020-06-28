class Contact < ApplicationRecord
  belongs_to :user

  def self.parse(number)
    ph_number, extsn = number.gsub(/[() .-]/, '').split('x')
    {
      phone_number: ph_number.to_i,
      extension: extsn.to_i
    }
  end
end
