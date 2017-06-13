require 'rails_helper'

RSpec.describe RootDomainConstraint, type: :constraint do
  describe '#matches?' do
    subject { RootDomainConstraint.new(:api, :www) }
    let(:request) { double }

    context 'with api.' do
      before { allow(request).to receive(:host) { 'api.elmlog.com' } }
      it 'does not match' do
        expect(subject.matches?(request)).to be_falsey
      end
    end

    context 'with www.' do
      before { allow(request).to receive(:host) { 'www.elmlog.com' } }
      it 'does not match' do
        expect(subject.matches?(request)).to be_falsey
      end
    end

    context 'with root domain' do
      before { allow(request).to receive(:host) { 'elmlog.com' } }
      it 'matches' do
        expect(subject.matches?(request)).to be_truthy
      end
    end
  end
end
