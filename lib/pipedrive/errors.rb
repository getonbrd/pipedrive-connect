# frozen_string_literal: true

module Pipedrive
  class PipedriveError < StandardError
    attr_reader :code

    def initialize(message = nil, code = nil)
      super(message)
      @message = message
      @code = code
    end

    def message
      code_str = @code.nil? ? "" : "(Status #{@code}) "
      "#{code_str}#{@message}"
    end
  end
  class SettingError < PipedriveError; end
  class AuthenticationError < PipedriveError; end
  class NotFoundError < PipedriveError; end
  class UnkownAPIError < PipedriveError; end
end
