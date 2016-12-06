describe Fastlane::Actions::ForceSignAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The force_sign plugin is working!")

      Fastlane::Actions::ForceSignAction.run(nil)
    end
  end
end
