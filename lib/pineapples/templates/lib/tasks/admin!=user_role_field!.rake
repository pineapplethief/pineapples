namespace :admin do
  desc 'Create admin user'
  task create: :environment do
    require 'highline/import'

    class User
      def reset_password
        begin
          password = ask('Password:         ') { |q| q.echo = 'x' }
          password_confirmation = ask('Repeat password:  ') { |q| q.echo = 'x' }
        end while password != password_confirmation
        self.password              = password
        self.password_confirmation = password
      end
    end

    begin
      email = ask('Email:  ')
      existing_user = User.find_by_email(email)

      # check if user account already exists
      if existing_user
        user = existing_user
        # user already exists, ask for password reset
        reset_password = ask('User with this email already exists! Do you want to reset the password for this email? (Y/n)  ')
        user.reset_password if yes?(reset_password)
      else
        # create new user otherwise
        user = User.new(email: email, confirmed_at: Time.current)
        user.reset_password
      end

      saved = user.save
      if !saved
        puts admin.errors.full_messages.join("\n")
        next
      end

      grant_admin = ask('Do you want to grant Admin privileges to this account? (Y/n)  ')
      if yes?(grant_admin)
        user.role = :admin
        say("\nYour account now has Admin privileges!") if user.save
      end
    end while !saved
  end
end

def yes?(string)
  string = string.strip.downcase
  string.empty? || string == 'y' || string == 'yes'
end
