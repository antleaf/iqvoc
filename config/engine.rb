require 'rails'

# An engine doesn't require it's own dependencies automatically. We also don't
# want the applications to have to do that.
require 'cancan'
require 'authlogic'
require 'scrypt'
require 'kaminari'
require 'iq_rdf'
require 'deep_cloneable'
require 'json'
require 'rails_autolink'
require 'sass'
require 'sass-rails'
require 'bootstrap_form'
require 'font-awesome-rails'
require 'uglifier'
require 'apipie-rails'
require 'database_cleaner'
require 'delayed_job_active_record'
require 'carrierwave'
require 'autoprefixer-rails'
require 'faraday'
require 'faraday_middleware'
require 'rack-mini-profiler'

module Iqvoc
  class Engine < Rails::Engine
    paths['lib/tasks'] << 'lib/engine_tasks'

    initializer 'iqvoc.mixin_controller_extensions' do |app|
      if Kernel.const_defined?(:ApplicationController)
        ApplicationController.send(:include, Iqvoc::ControllerExtensions)
      end
    end

    initializer 'iqvoc.add_assets_to_precompilation' do |app|
      # add host app assets when mounting iqvoc as a engine
      app.config.assets.paths << Iqvoc::Engine.root.join('node_modules')
      app.config.assets.precompile += Iqvoc.core_assets
    end

    initializer 'iqvoc.load_migrations' do |app|
      # Pull in all the migrations to the application embedding iqvoc
      app.config.paths['db/migrate'].concat(Iqvoc::Engine.paths['db/migrate'].existent)
    end
  end
end
