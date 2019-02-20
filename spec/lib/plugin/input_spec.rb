require 'spec_helper'
module Fusuma
  module Plugin
    module Inputs
      DUMMY_OPTIONS = { inputs: { dummy_input: 'dummy' } }.freeze

      class DummyInput < Input
      end

      RSpec.describe Generator do
        let(:options) { DUMMY_OPTIONS }
        let(:generator) { described_class.new(options: options) }

        before do
          allow(generator).to receive(:plugins) { [DummyInput] }
        end

        describe '#generate' do
          subject { generator.generate }

          it { is_expected.to be_a_kind_of(Array) }

          it 'generate plugins have options' do
            expect(subject.any?(&:options)).to be true
          end

          it 'have a DummyInput' do
            expect(subject.first).to be_a_kind_of DummyInput
          end

          it 'have only a input options' do
            expect(subject.first.options).to eq DUMMY_OPTIONS[:inputs][:dummy_input]
          end
        end
      end
    end
  end
end
