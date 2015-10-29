module Pineapples
  describe Actions::Target do
    before(:each) do
      remove_app_directory
      create_app_directory
    end

    def target(filename)
      Actions::Target.new(filename, generator)
    end

    describe '#initialize' do
      it 'raises error when filename given is falsey' do
        expect { Actions::Target.new(false, generator) }.to raise_error(Pineapples::Error)
      end

      it 'raises error when there is no guard method on generator instance' do
        expect { target('config/!boot!.rb') }.to raise_error(Pineapples::Error)
      end

      it 'sets @skip to result of guard method call' do
        generator.define_singleton_method(:boot?) { true }
        target = target('config/!boot!.rb')

        expect(target.skip?).to be true
      end

      it 'sets @skip to negative of result of pass method call' do
        generator.define_singleton_method(:boot?) { true }
        target = target('config/!=boot!.rb')

        expect(target.skip?).to be false
      end

      it 'determine pass method properly in presence of accessor method' do
        generator.define_singleton_method(:ajax_login?) { !!@ajax_login }
        generator.define_singleton_method(:ajax_login) { @ajax_login }
        generator.define_singleton_method(:"ajax_login=") { |value| @ajax_login = value }
        generator.ajax_login = true

        target = target('config/!=ajax_login!.rb')

        expect(target.skip?).to be false
      end

      it 'removes guard clause(!!) from filename given' do
        generator.define_singleton_method(:boot?) { true }
        target = target('config/boot!boot!.rb')

        expect(target.given).to eq('config/boot.rb')
      end

      it 'raises error when there is no filename method on generator instance' do
        expect { target('config/%boot%.rb') }.to raise_error(Pineapples::Error)
      end

      it 'sets filename to result of filename method on generator instance' do
        generator.define_singleton_method(:filename) { 'boot' }

        target = target('config/%filename%.rb')

        expect(target.given).to eq('config/boot.rb')
      end

      it 'expands path given relative to app_root' do
        target = target('config/boot.rb')

        expect(target.fullpath).to eq("#{app_path}/config/boot.rb")
      end

      it 'sets valid relative path' do
        target = target('config/boot.rb')

        expect(target.relative).to eq('config/boot.rb')
      end

      it 'handles multiple pass clauses' do
        generator.define_singleton_method(:devise_devise?) { true }
        generator.define_singleton_method(:ajax_login?) { true }

        target = target('lib/devise!=devise_devise!/ajax_failure!=ajax_login!.rb')

        expect(target.relative).to eq('lib/devise/ajax_failure.rb')
      end
    end
  end
end
