require "action_view"
require File.join(File.dirname(__FILE__), "views", "query_review_box_helper")

module QueryReviewer
  module ControllerExtensions
    class QueryViewBase < ActionView::Base
      include QueryReviewer::Views::QueryReviewBoxHelper
    end

    def self.included(base)
      if QueryReviewer::CONFIGURATION["inject_view"]
        alias_name = defined?(Rails::Railtie) ? :process_action : :perform_action
        base.alias_method_chain(alias_name, :query_review)
      end
      base.alias_method_chain :process, :query_review
      base.helper_method :query_review_output
    end

    def query_review_output(ajax = false, total_time = nil)
      faux_view = QueryViewBase.new([File.join(File.dirname(__FILE__), "views")], {}, self)
      queries = Thread.current["queries"]
      queries.analyze!
      faux_view.instance_variable_set("@queries", queries)
      faux_view.instance_variable_set("@total_time", total_time)
      if ajax
        js = faux_view.render(:partial => "/box_ajax.js")
      else
        html = faux_view.render(:partial => "/box")
      end
    end

    def add_query_output_to_view(total_time)
      if request.xhr?
        if cookies["query_review_enabled"]
          if !response.content_type || response.content_type.include?("text/html")
            response.body += "<script type=\"text/javascript\">"+query_review_output(true, total_time)+"</script>"
          elsif response.content_type && response.content_type.include?("text/javascript")
            response.body += ";\n"+query_review_output(true, total_time)
          end
        end
      else
        if response.body.is_a?(String) && response.body.match(/<\/body>/i)
          idx = (response.body =~ /<\/body>/i)
          html = query_review_output(false, total_time)
          response.body = response.body.insert(idx, html)
        end
      end
    end

    def perform_action_with_query_review(*args)
      Thread.current["query_reviewer_enabled"] = query_reviewer_output_enabled?

      t1 = Time.now
      r = defined?(Rails::Railtie) ? process_action_without_query_review(*args) : perform_action_without_query_review(*args)
      t2 = Time.now
      add_query_output_to_view(t2 - t1)
      r
    end
    alias_method :process_action_with_query_review, :perform_action_with_query_review

    def process_with_query_review(*args) #:nodoc:
      Thread.current["queries"] = SqlQueryCollection.new
      process_without_query_review(*args)
    end

    # @return [Boolean].  Returns whether or not the user has indicated that query_reviewer output is enabled
    def query_reviewer_output_enabled?
      cookie_enabled = (CONFIGURATION["enabled"] == true and cookies["query_review_enabled"])
      session_enabled = (CONFIGURATION["enabled"] == "based_on_session" and session["query_review_enabled"])
      return cookie_enabled || session_enabled
    end
  end
end
