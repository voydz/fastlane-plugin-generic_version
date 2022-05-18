describe Fastlane::Actions::GenericVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The generic_version plugin is working!")

      Fastlane::Actions::GenericVersionAction.run(nil)
    end
  end
end
