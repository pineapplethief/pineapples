require_relative 'copy_file'

module Pineapples
  module Actions
    module Rails
      def copy_migration(migration_name, options = {})
        # TODO: find migration file
        action CopyMigration.new(self, migration_name, options)
      end

      class CopyMigration < CopyFile
        attr_reader :migration_name

        def initialize(generator, migration_name, options)
          @migration_name = migration_name

          set_source_for_migration!
          @target = target_for_migration

          # TODO: set source and target properly
          super(generator, @source, @target, options, nil)
        end

        def invoke!
          sleep 0.01
          super
        end

        private

        def set_source_for_migration!
          Dir.glob("#{migration_dir}/*.rb").each do |filename|
            if filename.include?(migration_name)
              @source = File.join(relative_migration_dir, filename)
            end
          end
          raise ArgumentError, "Failed to find migration by name #{migration_name}" if @source.nil?
        end

        def target_for_migration
          "#{migration_timestamp}#{migration_name}.rb"
        end

        def migration_dir
          File.join(generator.templates_root, relative_migration_dir)
        end

        def relative_migration_dir
          'db/migrate'
        end

        def migration_timestamp
          Time.now.strftime('%Y%m%d%H%M%S')
        end
      end

    end
  end
end
