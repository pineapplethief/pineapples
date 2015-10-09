class FakeGithub
  RECORDER = File.expand_path('../../tmp/hub_commands', __dir__)

  def initialize(args)
    @args = args
  end

  def run!
    File.open(RECORDER, 'a') do |file|
      file.write @args.join(' ')
    end
  end

  def self.clear!
    FileUtils.rm_rf RECORDER
  end

  def self.has_created_repo?(repo_name)
    File.read(RECORDER) == "create #{repo_name}"
  end
end
