require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module ActiveSeo
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migrations to add SEO meta tables.'
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      migration_template 'migration/migration.rb', 'db/migrate/create_seo_meta.rb'
    end

    def create_config_file
      template 'initializer/initializer.rb', 'config/initializers/active_seo.rb'
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
