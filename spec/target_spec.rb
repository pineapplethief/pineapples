module Pineapples
  describe Actions::Target do
    before(:each) do
      remove_app_directory
      create_app_directory
    end

    let(:action) do
      action = double('action')
      allow(action).to receive(:generator).and_return(generator)
      action
    end

    def target(filename)
      Actions::Target.new(filename, action)
    end

    describe '#initialize' do
      it 'raises error when filename given is falsey' do
        expect { Actions::Target.new(false, false) }.to raise_error(Pineapples::Error)
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
    end

    describe '#skip?' do
      it 'returns false if @skip is nil' do
        target = target('config/boot.rb')
        expect(target.skip?).to be false
      end
    end
  end
end
