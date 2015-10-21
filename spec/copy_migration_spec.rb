module Pineapples
  module Actions
    describe Rails::CopyMigration do
      before(:each) do
        remove_app_directory
        create_app_directory
      end

      def now
        Time.mktime(2015, 10, 21)
      end

      def timestamp(time = now)
        time.strftime('%Y%m%d%H%M%S')
      end

      it "finds migration by it's name & copies migration to proper target with timestamp prepended" do
        allow(Time).to receive(:now).and_return(now)

        generator.copy_migration 'test_migration'

        expect(File).to exist("#{app_path}/db/migrate/#{timestamp}_test_migration.rb")
      end

    end
  end
end
