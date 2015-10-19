describe Pineapples::Actions::CreateFile do
  before(:each) do
    remove_app_directory
    create_app_directory
  end

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
