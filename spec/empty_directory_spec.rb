describe Pineapples::Actions::EmptyDirectory do
  before(:each) do
    remove_app_directory
    create_app_directory
  end

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
