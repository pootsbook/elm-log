require 'rails_helper'

RSpec.describe TimeZoneParamsProcessor do

  describe '#process' do
    subject { TimeZoneParamsProcessor.process(params) }
    let(:params) do
      {
        'starts_at(1i)' => '2014',
        'starts_at(2i)' => month,
        'starts_at(3i)' => '28',
        'starts_at(4i)' => '18',
        'starts_at(5i)' => '30',
        'time_zone'     => 'Amsterdam'
      }
    end

    context 'Central European Time (CET) [November–March]' do
      let(:month) { '1' }

      it 'produces the correct UTC offset' do
        expect(subject['utc_offset']).to eq(3600)
        expect(subject['utc_offset_fmt']).to eq('+01:00')
      end
    end

    context 'Central European Summer Time (CEST) [April–October]' do
      let(:month) { '7' }

      it 'produces the correct UTC offset' do
        expect(subject['utc_offset']).to eq(7200)
        expect(subject['utc_offset_fmt']).to eq('+02:00')
      end
    end
  end
end
