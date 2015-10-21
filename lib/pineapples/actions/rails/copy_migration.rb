require 'pineapples/actions/copy_file'

module Pineapples
  module Actions
    module Rails
      def copy_migration(migration_name, options = {})
        # TODO: find migration file
        action CopyMigration.new(self, migration_name, options)
      end

      class CopyMigration < CopyFile
        attr_reader :migration_name

        def self.time
          @time ||= Time.now
        end

        def self.time=(value)
          @time = value
        end

        def initialize(generator, migration_name, options)
          @generator = generator
          @migration_name = File.basename(migration_name, File.extname(migration_name))

          set_source_for_migration!
          @target = target_for_migration

          super(generator, @source, @target, options)
        end

        def invoke!
          super
          self.class.time = self.class.time + 2
        end

        private

        def set_source_for_migration!
          sources = generator.source_paths_for_search

          sources.each do |source_path|
            migration_dir = File.join(source_path, relative_migration_dir)
            Dir.glob("#{migration_dir}/*.rb").each do |filename|
              @source = filename if filename.include?(migration_name)
            end
          end

          raise ArgumentError, "Failed to find migration by name #{migration_name}" if @source.nil?
        end

        def target_for_migration
          File.join(relative_migration_dir, "#{migration_timestamp}_#{migration_name}.rb")
        end

        def relative_migration_dir
          'db/migrate'
        end

        def migration_timestamp
          self.class.time.strftime('%Y%m%d%H%M%S')
        end
      end

    end
  end
end
