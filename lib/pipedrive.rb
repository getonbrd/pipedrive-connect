# frozen_string_literal: true

require "logger"
require "faraday"
require "json"

# Version
require "pipedrive/version"

# API operations
require "pipedrive/api_operations/request"
require "pipedrive/api_operations/create"
require "pipedrive/api_operations/update"
require "pipedrive/api_operations/delete"

# Support classes
require "pipedrive/resource"
require "pipedrive/errors"
require "pipedrive/util"
require "pipedrive/fields"
require "pipedrive/merge"

# Named API Resources
require "pipedrive/resources"

module Pipedrive
  BASE_URL = "https://api.pipedrive.com"

  class << self
    attr_accessor :api_key,
                  :logger,
                  :debug,
                  :debug_http,
                  :debug_http_body,
                  :treat_no_content_as_not_found

    attr_writer :faraday_adapter

    def use_v2_api!
      @api_version = :v2
    end

    def use_v1_api!
      @api_version = :v1
    end

    def api_version
      @api_version || :v2
    end

    def faraday_adapter
      @faraday_adapter || :net_http
    end
  end

  @logger = Logger.new($stdout)
end
