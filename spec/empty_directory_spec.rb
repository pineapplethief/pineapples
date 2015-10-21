describe Pineapples::Actions::EmptyDirectory do
  before(:each) do
    remove_app_directory
    create_app_directory
  end

  context 'creates empty directory' do
    it 'in application root' do
      generator.empty_directory('test_dir')

      expect(File).to exist("#{app_path}/test_dir")
    end

    it 'with respect of #current_app_dir' do
      generator.inside('app') { generator.empty_directory('assets') }

      expect(File).to exist("#{app_path}/app/assets")
    end
  end

  it 'skips directory with guard clause evaluated to true' do
    generator.empty_directory 'app!execute!'

    expect(File).to_not exist("#{app_path}/app")
  end

  it 'creates directory with pass clause (!=!) evaluated to true' do
    generator.empty_directory 'app!=execute!'

    expect(File).to exist("#{app_path}/app")
  end

end
