require 'cheeky/row'

describe Cheeky::Row do
  it 'only stores 21 values' do
    row = described_class.new(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0)
    expect(row.states.length).to eq 21
  end

  it 'converts each input, defaulting to 0 for missing values' do
    row = described_class.new(true, false, :on, :off, 'a', ' ', 9, :banana, :blues)
    expect(row.states).to eq [1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end

  it 'fills itself with zeros when not given any data' do
    row = described_class.new
    expect(row.states.length).to eq 21
    expect(row.states.inject(:+)).to eq 0
  end

  it 'can be intialized with an instance of itself' do
    expect(described_class.new(described_class.new).states.length).to eq 21
  end

  context 'value conversions' do
    def converted_value(value)
      described_class.new(value).states.first
    end

    {
      true => 1,
      false => 0,
      :on => 1,
      :off => 0,
      'a' => 1,
      ' ' => 0,
      :a => 1,
      1 => 1,
      0 => 0,
      7 => 1
    }.each do |input, output|
      specify "convert #{input} to #{output}" do
        expect(converted_value(input)).to eq output
      end
    end
  end
  
end