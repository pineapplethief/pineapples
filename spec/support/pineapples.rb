module PineapplesTestHelpers
  APP_NAME = 'dummy_app'

  def run_pineapples(arguments = nil)
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        ENV['TESTING'] = '1'

        %x(#{bin_path} #{APP_NAME} #{arguments})
      end
    end
  end

  def create_app_directory
    FileUtils.mkdir_p(app_path)
  end

  def remove_app_directory
    FileUtils.rm_rf(app_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def remove_tmp_directory
    FileUtils.rm_rf(tmp_path)
  end

  def drop_dummy_database
    if File.exist?(app_path)
      Dir.chdir(app_path) do
        Bundler.with_clean_env do
          `rake db:drop`
        end
      end
    end
  end

  def app_path
    @app_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def bin_path
    File.join(root_path, 'bin', 'pineapples')
  end

  def root_path
    File.expand_path('../../', __dir__)
  end

  def fixtures_path
    File.expand_path('../fixtures', __dir__)
  end

end
