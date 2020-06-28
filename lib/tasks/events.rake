require 'csv'

namespace :events do
  desc 'Add user events mapping'
  task map_with_users: :environment do
    batch_size   = 500
    File.open(Rails.root.join('lib', 'seed_data', 'events.csv'), 'r') do |file|
      file.lazy.each_slice(batch_size) do |lines|
        user_events_data = CSV.parse(lines.join, write_headers: false)
        ActiveRecord::Base.transaction do
          user_events_data.each do |row|
            event =
              Event.find_or_create_by(
                title: row[0],
                start_datetime: Time.parse(row[1].to_s),
                end_datetime: Time.parse(row[2].to_s),
                description: row[3],
                all_day: row[5].to_s.downcase == 'true'
              )
            next unless row[4]

            users_rsvp = row[4].split(';')
            users_rsvp.each do |user_rsvp|
              next unless users_rsvp

              user_detail = user_rsvp.split('#')
              user = User.find_by(user_name: user_detail[0])
              next unless user

              # finding overlapping events and marking rsvp as no
              start_time = Time.parse(row[1])
              end_time = event.all_day ? start_time.end_of_day : Time.parse(row[2])

              user.user_events.joins(:event).where("((events.start_datetime >= ? AND events.end_datetime <= ?) OR (events.start_datetime >= ? AND events.end_datetime <= ?) OR (events.all_day = ? AND DATE(events.start_datetime) = ?)) AND rsvp = ? AND event_id != ?", start_time, start_time, end_time, end_time, event.all_day, start_time.to_date.strftime("%Y-%m-%d"), UserEvent.rsvps['yes'], event.id).update_all(rsvp: UserEvent.rsvps['no'])

              # find existing user event for user and event, if any exist then update rsvp else create userevent
              user_events = UserEvent.where(event_id: event.id, user_id: user.id)
              if user_events.present?
                user_events.update_all(rsvp: UserEvent.rsvps[user_detail[1]])
              else
                UserEvent.create(
                  event_id: event.id,
                  user_id: user.id,
                  rsvp: UserEvent.rsvps[user_detail[1]]
                )
              end
            end
          rescue => e
            puts "User event import failed for row with details #{row}, error: #{e}, NEEDS TO BE FIXED!"
          end
        end
      end
    end
  end
end

