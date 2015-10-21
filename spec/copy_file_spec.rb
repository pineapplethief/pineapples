module Pineapples
  describe Actions::CopyFile do
    before(:each) do
      remove_app_directory
      create_app_directory
    end

    context 'copies file' do
      it 'with target filename defaulting to source filename' do
        generator.copy_file 'copy_file.rb'

        expect(File).to exist("#{app_path}/copy_file.rb")
      end

      it 'with target filename given' do
        generator.copy_file 'copy_file.rb', 'new_file.rb'

        expect(File).to exist("#{app_path}/new_file.rb")
      end

      it 'with content returned from block given' do
        generator.copy_file('copy_file.rb') { 'new content' }

        content = File.read("#{app_path}/copy_file.rb")

        expect(content).to eq('new content')
      end
    end

    it 'preserve source file permission if options[:mode] == :preserve' do
      generator.copy_file 'copy_file.rb'

      source_mode = File.stat("#{fixtures_path}/copy_file.rb").mode

      target_mode = File.stat("#{app_path}/copy_file.rb").mode

      expect(source_mode).to eq(target_mode)
    end
  end
end
