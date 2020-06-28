require 'csv'

namespace :users do
  desc 'Add users'
  task create: :environment do
    batch_size = 100
    File.open(Rails.root.join('lib', 'seed_data', 'users.csv'), 'r') do |file|
      file.lazy.each_slice(batch_size) do |lines|
        users_data = CSV.parse(lines.join, write_headers: false)
        ActiveRecord::Base.transaction do
          users_data.each do |row|
            user = User.find_by(email: row[1])
            next if user

            User.create(
              user_name: row[0],
              email: row[1],
              contacts_attributes: [
                Contact.parse(row[2])
              ]
            )
          end
        rescue => e
          puts "User import failed, error: #{e}, NEEDS TO BE FIXED!"
        end
      end
    end
  end
end
