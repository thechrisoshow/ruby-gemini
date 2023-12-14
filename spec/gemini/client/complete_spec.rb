RSpec.describe Gemini::Client do
  describe "#complete" do
    context "with a prompt and max_tokens", :vcr do
      let(:prompt) { "How high is the sky?" }
      let(:max_tokens) { 5 }

      let(:response) do
        Gemini::Client.new.generate_content(
          parameters: {
            model: model,
            max_tokens_to_sample: max_tokens,
            prompt: prompt
          }
        )
      end
      let(:text) { response.dig("parts", 0, "text") }
      let(:cassette) { "#{model} content #{prompt}".downcase }

      context "with model: gemini-pro" do
        let(:model) { "gemini-pro" }

        it "succeeds" do
          VCR.use_cassette(cassette) do
            expect(response["content"].empty?).to eq(false)
          end
        end
      end
    end
  end
end
