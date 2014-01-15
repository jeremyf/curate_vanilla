require 'curate/deposit/configuration'
require 'virtus'
require File.expand_path('../../../../app/models/curate/contributor', __FILE__)

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
      app.config.paths.add 'app/forms', eager_load: true
      app.config.paths.add 'app/resolvers', eager_load: true
      app.config.paths.add 'app/inputs', eager_load: true
      app.config.paths.add 'app/services', eager_load: true
      app.config.autoload_paths += %W(
        #{config.root}/app/finalizers
        #{config.root}/app/forms
        #{config.root}/app/inputs
        #{config.root}/app/resolvers
        #{config.root}/app/services
      )
    end

    config.register_new_form_for(
      :work, {
        fieldsets: {
          required:
          {
            attributes: {
              title: String,
            },
            validates: {
              title: {presence: true},
            }
          }
        },
        identity_minter: 'Curate::Deposit::NoidMintingService'
      }
    )
    config.register_new_form_for(
      :article,
      {
        fieldsets: {
          required:
          {
            attributes: {
              title: String,
              contributors_attributes: Array[Curate::Contributor],
              abstract: String
            },
            validates: {
              title: {presence: true},
              abstract: {presence: true}
            },
          },
          additional:
          {
            attributes: {
              subject: Array[String],
              publisher: Array[String],
              recommended_citation: Array[String],
              language: Array[String],
            }
          },
          content:
          {
            attributes: {
              linked_resource_urls: Array[String],
              files: Array[File],
            }
          },
          identifier: {
            attributes: {
              doi_assignment_strategy: String,
              existing_identifier: String,
              embargo_release_date: Date
            }
          },
          access_rights: {
            attributes: {
              visibility: [String, default: 'restricted'],
              rights: [String, default: 'All rights reserved']
            },
            validates: {
              visibility: {presence: true},
              rights: {presence: true}
            }
          }
        },
        on_save: {
          write_attributes: lambda {|object, attributes|
            article = Article.new(pid: object.minted_identifier)
            current_user = object.controller.current_user
            actor = CurationConcern.actor(article, current_user, attributes)
            actor.create
          }
        },
        identity_minter: 'Curate::Deposit::NoidMintingService'
      }
    )
  end
end
