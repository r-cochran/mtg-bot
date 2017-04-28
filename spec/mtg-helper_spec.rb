require 'spec_helper'

describe 'MTGHelperModule' do
  subject { MTGHelperModuleStub.new }

  describe '.get_search_term' do
    context 'card name provided' do
      let(:params) { { 'text' => 'mtg card' } }

      it 'should defines name' do
        expect(subject.get_search_term(params).name).to eql 'mtg card'
      end
    end

    context 'set provided' do
      it 'should parse if valid' do
        expect(subject.get_search_term('text' => "mtg card#KLD").set).to eql 'KLD'
      end

      it 'should upcase set if necessary' do
        expect(subject.get_search_term('text' => "mtg card#ori").set).to eql 'ORI'
      end

      it 'should throw away if invalid' do
        expect(subject.get_search_term('text' => "mtg card#bullshit").set).to be_nil
      end

      it 'should ignore if missing' do
        expect(subject.get_search_term('text' => "mtg card#").set).to be_nil
      end
    end
  end
end

class MTGHelperModuleStub
  include MTGHelperModule
end