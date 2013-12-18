require 'curate/deposit/configuration'

module Curate::Deposit

  class Engine < ::Rails::Engine

    def initialize(*args)
      super
      @config = Curate::Deposit::Configuration.new(find_root_with_flag("lib"))
    end

    isolate_namespace Curate::Deposit
    engine_name 'curate_deposit'

    initializer 'curate-deposit.initializers' do |app|
      app.config.paths.add 'app/finalizers', eager_load: true
      app.config.paths.add 'app/resolvers', eager_load: true
      app.config.paths.add 'app/services', eager_load: true
      app.config.autoload_paths += %W(
        #{config.root}/app/finalizers
        #{config.root}/app/resolvers
        #{config.root}/app/services
      )
    end

    config.register_new_form_for(
      :work,
      {
        fieldsets: {
          required:
          { attributes: { title: String },
            validates: { title: {presence: true} },
            },
          secondary:
          { attributes: { abstract: String }}
        },
        on_save: {
          write_attributes: lambda {|object, attributes|
            Work.new(pid: object.persisted_identifier).tap {|work|
              work.attributes = attributes
              work.save!
            }
          }
        },
        identity_minter: 'Curate::Deposit::MintingService'
      }
    )
  end
end
