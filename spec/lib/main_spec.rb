require_relative '../spec_helper.rb'
require '../../lib/main'

RSpec.describe Main do
  describe '#run' do
    subject(:run) { described_class.new(tag) }

    let(:tag) { 'cat' }

    it 'main the problem'
    expect(tag.run).to eq('cat')
  end
end
