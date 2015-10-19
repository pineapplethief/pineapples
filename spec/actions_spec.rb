describe Pineapples::Actions do
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

  describe '#template' do
    it 'creates file from the template with proper name' do
      generator.template('sample.tt')

      expect(File).to exist("#{app_path}/sample")
    end

    it 'evaluates ERB in the template in context of generator instance' do
      generator.template('sample.tt')

      content = File.read("#{app_path}/sample")

      expect(content).to eq(generator.app_name.humanize + "\r\n")
    end
  end

end
