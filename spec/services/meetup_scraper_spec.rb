require 'rails_helper'
require_relative '../fixtures/meetup_response'

RSpec.describe MeetupScraper do
  describe '#process_group_response' do
    context 'with successful meetup response' do
      let(:response) { MeetupResponse.group }

      context 'without existing MeetupGroup' do
        it 'persists a MeetupGroup' do
          expect { 
            subject.process_group_response(response["results"][0])
          }.to change { MeetupGroup.count }.by(1)
          puts MeetupGroup.first.to_yaml
        end
      end

      context 'with existing MeetupGroup' do
        before { MeetupGroup.create!(urlname: 'Elm-user-group-SF') }

        it 'persists nothing' do
          expect {
            subject.process_group_response(response["results"][0])
          }.to change { MeetupGroup.count }.by(0)
        end
      end
    end
  end
end
