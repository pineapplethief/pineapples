namespace :admin do
  desc 'Create admin user'
  task create: :environment do
    require 'highline/import'

    begin
      email = ask('Email:  ')
      existing_user = User.find_by_email(email)

      # check if user account already exists
      if existing_user
        admin = existing_user
        # user already exists, ask for password reset
        reset_password = ask('User with this email already exists! Do you want to reset the password for this email? (Y/n)  ')
        if yes?(reset_password)
          begin
            password = ask('Password:  ') { |q| q.echo = 'x' }
            password_confirmation = ask('Repeat password:  ') { |q| q.echo = 'x' }
          end while password != password_confirmation
          admin.password              = password
          admin.password_confirmation = password
        end
      else
        # create new user otherwise
        admin = User.new(email: email, confirmed_at: Time.current)
        begin
          password = ask('Password:  ') { |q| q.echo = 'x' }
          password_confirmation = ask('Repeat password:  ') { |q| q.echo = 'x' }
        end while password != password_confirmation
        admin.password              = password
        admin.password_confirmation = password
      end

      saved = admin.save
      if !saved
        puts admin.errors.full_messages.join("\n")
        next
      end

      grant_admin = ask('Do you want to grant Admin privileges to this account? (Y/n)  ')
      if yes?(grant_admin)
        admin.role = :admin
        say("\nYour account now has Admin privileges!") if admin.save
      end
    end while !saved
  end
end

def yes?(string)
  string = string.strip.downcase
  string.empty? || string == 'y' || string == 'yes'
end
