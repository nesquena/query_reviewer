    # QueryReviewer #

## Introduction ##

QueryReviewer is an advanced SQL query analyzer.  It accomplishes the following goals:

 * View all EXPLAIN output for all SELECT queries to generate a page
 * Rate a page's SQL usage into one of three categories: OK, WARNING, CRITICAL
 * Attach meaningful warnings to individual queries, and collections of queries
 * Display interactive summary on page

## Use This Fork ##

I use this utility for most of my MySQL-backed Rails projects. Still the best out there in my opinion for analyzing and understanding your generated SQL queries. 
I forked the original [query_reviewer](https://github.com/dsboulder/query_reviewer) and applied a collection of patches that have been made since the plugin was created. 
A list of the biggest additions below:

 * Snazzed up the README into markdown for better readability
 * Full compatibility for Rails 3 (including Railtie)
 * Cleanup and move rake task to `lib/tasks` to fix deprecation warnings
 * Added gemspec for use with Bundler (as a gem)
 * Fixed missing tags and additional XHTML escaping
 * Fix SQL escaping for better XHTML compatibility
 * Fixes for deprecation warnings and for 1.9 compatiblity
 * Converts templates to more modern foo.html.erb naming

As of August 2011, This has become the "official" version to use. David has deprecated the [original repo](https://github.com/dsboulder/query_reviewer) and recommends that people looking for this utility use this fork instead. 
This fork compiles a variety of patches that were made since that time along with additional work to support compatibility with 1.9 and Rails 3. 
**Also:** If anyone else creates generally useful enhancements to this utility please start by forking this and then issue me a pull request.

**Note:** This plugin should work for Rails 2.X and Rails 3. If you run into issues, please file a bug report or send a pull request. I consider this new fork to be a group effort
so if you want to be added as a contributor to help maintain this, please let me know!

## Database Limitations ##

As of right now, this plugin  supports analyzing queries **only for MySQL**. I consider this the primary **limitation** of this gem. 
I am now using PostgreSQL for a number of my projects and the "EXPLAIN" output is totally different. Several people have started a PostgreSQL adapter for
this plugin, but none that are mature enough to include here.

If anyone is interested at taking a stab at implementing PostgreSQL support for this utility, that would be hugely appreciated! I hope this plugin can come to support
all the major Rails adapters over time.

## Installation ##

All you have to do is install it into your Rails 2 or 3 project.

    gem install query_reviewer

Right now if you use bundler, simply add this to your Gemfile:

    # Gemfile
    gem "query_reviewer"

If you are not using bundler, you might want to [start using it](http://gembundler.com/rails23.html). You can also install this as a plugin:

    script/plugin install git://github.com/nesquena/query_reviewer.git

In Rails 2, the rake tasks are not loaded automatically (as a gem), you’ll need to add the following to your Rakefile:

    # Rakefile
    begin
      require 'query_reviewer/tasks'
    rescue LoadError
      STDERR.puts "The query_reviewer gem could not be found!"
    end

You can then run:

    $ rake query_reviewer:setup

Which will create `config/query_reviewer.yml` in your application, see below for what these options mean.
If you don't create a config file, the gem will use the default in `vendor/plugins/query_reviewer`.

## Configuration ##

The configuration file allows you to set configuration parameters shared across all rails environment, as well as overriding those shared parameteres with environment-specific parameters (such as disabling analysis on production!)

 * `enabled`: whether any output or query analysis is performed.  Set this false in production!
 * `inject_view`: controls whether the output automatically is injected before the &lt;/body&gt; in HTML output.
 * `profiling`: when enabled, runs the MySQL SET PROFILING=1 for queries longer than the `warn_duration_threshold` / 2.0
 * `production_data`: whether the duration of a query should be taken into account
 * `stack_trace_lines`: number of lines of call stack to include in the "short" version of the stack trace
 * `trace_includes_vendor`: whether the "short" version of the stack trace should include files in /vendor
 * `trace_includes_lib`: whether the "short" version of the stack trace should include files in /lib
 * `warn_severity`: the severity of problem that merits "WARNING" status
 * `critical_severity`: the severity of problem that merits "CRITICAL" status
 * `warn_query_count`: the number of queries in a single request that merits "WARNING" status
 * `critical_query_count`: the number of queries in a single request that merits "CRITICAL" status
 * `warn_duration_threshold`: how long a query must take in seconds (float) before it's considered "WARNING"
 * `critical_duration_threshold`: how long a query must take in seconds (float) before it's considered "CRITICIAL"

## Example ##

If you disable the inject_view option above, you'll need to manually put the analyzer's output into your view:

    # view.html.haml
    = query_review_output

and that will display the analyzer view!

## Resources ##

Random collection of resources that might be interesting related to this utility:

 * <http://blog.purifyapp.com/2010/06/15/optimise-your-mysql/>
 * <http://www.tatvartha.com/2009/09/rails-optimizing-database-indexes-using-query_analyzer-and-query_reviewer/>
 * <http://www.geekskillz.com/articles/using-indexes-to-improve-rails-performance>
 * <http://www.williambharding.com/blog/rails/rails-mysql-indexes-step-1-in-pitiful-to-prime-performance/>
 * <http://guides.rubyonrails.org/performance_testing.html>

Other related gems that prove useful for database optimization:

 * [bullet](https://github.com/flyerhzm/bullet)
 * [slim-scrooge](https://github.com/sdsykes/slim_scrooge)
 * [slim-attributes](https://github.com/sdsykes/slim-attributes)

## Alternatives ##

There have been other alternatives created since this was originally released. A few of the best are listed below. I for one still prefer this utility over the other options:

 * [rack-bug](https://github.com/brynary/rack-bug)
 * [rails-footnotes](https://github.com/josevalim/rails-footnotes)
 * [newrelic-development](http://support.newrelic.com/kb/docs/developer-mode)
 * [palmist](https://github.com/flyingmachine/palmist)
 * [query_diet](https://github.com/makandra/query_diet)
 * [query_trace](https://github.com/ntalbott/query_trace)

Know of a better alternative? Let me know!

## Acknowledgements ##

Created by Kongregate & David Stevenson.
Refactorings and compilations of all fixes since was done by Nathan Esquenazi.
Also, ajvargo for helping with some fixes.

Copyright (c) 2007-2008 Kongregate & David Stevenson, released under the MIT license
