describe Pineapples::Actions do
  let(:generator) do
    options = OpenStruct.new(app_name: PineapplesTestHelpers::APP_NAME,
                             app_root: app_path.to_s)
    Pineapples::AppGenerator.new(options)
  end

  before(:each) do
    remove_app_directory
    create_app_directory
  end


  describe '#action' do
    it 'calls action instance method #invoke! when behaviour is :invoke' do
      instance = Pineapples::Actions::EmptyDirectory.new(generator, 'test_dir')

      expect(instance).to receive(:invoke!)

      generator.action(instance)
    end
  end

  describe '#empty_directory' do
    it 'creates empty directory in application root' do
      generator.empty_directory('test_dir')

      expect(File).to exist("#{app_path}/test_dir")
    end

    it 'creates empty directory with respect of #current_app_dir' do
      generator.inside('app') { generator.empty_directory('assets') }

      expect(File).to exist("#{app_path}/app/assets")
    end

    it 'skips directory with guard clause evaluated to true' do
      generator.empty_directory('app!execute?!')

      expect(File).to_not exist("#{app_path}/app")
    end
  end

  describe '#create_file' do
    it 'creates file with given name' do
      generator.create_file '.rspec', '--color'

      expect(File).to exist("#{app_path}/.rspec")
    end

    it 'creates file with given content' do
      generator.create_file '.rspec', '--color'

      content = File.read("#{app_path}/.rspec")

      expect(content).to eq('--color')
    end

    it 'creates directories on file path' do
      generator.create_file 'config/boot.rb', 'boot'

      expect(File).to exist("#{app_path}/config")
    end

    it 'uses return value of block supplied as content for file' do
      generator.create_file 'config/boot.rb' do
        'boot'
      end

      content = File.read("#{app_path}/config/boot.rb")

      expect(content).to eq('boot')
    end
  end

  describe '#current_app_dir' do
    it 'equals app_root without using #inside method' do
      expect(generator.current_app_dir).to eq(generator.app_root)
    end

    it 'returns proper directory path with things in dir_stack' do
      generator.dir_stack.push('app')

      expect(generator.current_app_dir).to eq("#{app_path}/app")
    end
  end

  describe '#in_root' do
    it 'sets current_app_dir to #app_root' do
      current_app_dir = ''
      generator.in_root do
        current_app_dir = generator.current_app_dir
      end

      expect(current_app_dir).to eq(app_path.to_s)
    end
  end

  describe '#inside' do
    it 'creates directory to be inside of' do
      generator.inside('app') {}

      expect(File).to exist("#{app_path}/app")
    end
  end

end
