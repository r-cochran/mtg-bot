require 'spec_helper'

describe 'MTGHelperModule' do
  subject { MTGHelperModuleStub.new }

  describe '.get_search_term' do
    context 'card name provided' do
      let(:params) { { 'text' => 'mtg card' } }

      it 'should define name' do
        expect(subject.get_search_term(params).name).to eql "mtg card"
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

    context 'parsing card name' do
      # http://www.fileformat.info/info/unicode/char/201C/index.htm
      it 'should parse out Left Double Quote UTF-8 character' do
        expect(subject.get_search_term('text' => '“sweet mythic').name).to eql '"sweet mythic"'
        expect(subject.get_search_term('text' => "\u201Cdat mythic").name).to eql '"dat mythic"'
      end

      # http://www.fileformat.info/info/unicode/char/201d/index.htm
      it 'should parse out Right Double Quote UTF-8 character' do
        expect(subject.get_search_term('text' => "rad rare”").name).to eql '"rad rare"'
        expect(subject.get_search_term('text' => "rude artifact\u201D").name).to eql '"rude artifact"'
      end

      it 'should parse out extraneous double quotes' do
        expect(subject.get_search_term('text' => 'atraxa a" shit').name).to eql '"atraxa a shit"'

      end
    end
  end
end

class MTGHelperModuleStub
  include MTGHelperModule
end
