describe CompletionBuilder do
  fixtures = load_fixture('completion_builder')

  describe '#call' do
    fixtures.each do |fixture, options|
      context "with :#{fixture}" do
        let(:command) { Script::Command.new options['command'] }
        let(:builder) do
          described_class.new command, with_version: options.fetch('with_version', true)
        end

        it 'returns pattern config data' do
          expect(builder.call.to_yaml)
            .to match_approval("completion_builder/#{fixture}")
        end
      end
    end
  end
end
