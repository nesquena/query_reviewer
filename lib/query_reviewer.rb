# QueryReviewer
require "ostruct"
require 'erb'
require 'yaml'

module QueryReviewer
  CONFIGURATION = {}

  def self.load_configuration
    default_config = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), "..", "query_reviewer_defaults.yml"))).result)

    CONFIGURATION.merge!(default_config["all"] || {})
    CONFIGURATION.merge!(default_config[Rails.env || "test"] || {})

    app_config_file = Rails.root + "config/query_reviewer.yml"

    if File.file?(app_config_file)
      app_config = YAML.load(ERB.new(IO.read(app_config_file)).result)
      CONFIGURATION.merge!(app_config["all"] || {})
      CONFIGURATION.merge!(app_config[Rails.env || "test"] || {})
    end

    if enabled?
      begin
        CONFIGURATION["uv"] ||= if Gem::Specification.respond_to?(:find_all_by_name)
          !Gem::Specification.find_all_by_name('uv').empty?
        else # RubyGems < 1.8.0
          !Gem.searcher.find("uv").nil?
        end

        if CONFIGURATION["uv"]
          require "uv"
        end
      rescue
        CONFIGURATION["uv"] ||= false
      end

      require "query_reviewer/query_warning"
      require "query_reviewer/array_extensions"
      require "query_reviewer/sql_query"
      require "query_reviewer/mysql_analyzer"
      require "query_reviewer/sql_sub_query"
      require "query_reviewer/mysql_adapter_extensions"
      require "query_reviewer/controller_extensions"
      require "query_reviewer/sql_query_collection"
    end
  end

  def self.enabled?
    CONFIGURATION["enabled"]
  end
end

# Rails Integration
require 'query_reviewer/rails' if defined?(Rails)

