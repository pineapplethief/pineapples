describe Pineapples::AppGenerator do
  let(:generator) do
    options = OpenStruct.new(app_name: PineapplesTestHelpers::APP_NAME,
                             app_root: app_path)
    Pineapples::AppGenerator.new(options)
  end

  it 'has verbose option set to true by default' do
    expect(generator.verbose?).to eq(true)
  end

  it 'has default behaviour set to invoke' do
    expect(generator.behaviour).to eq(:invoke)
  end

end
