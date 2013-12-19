module Curate::Deposit
  module ApplicationHelper
    delegate(
      :catalog_index_path,
      :root_path,
      :new_classify_concern_path,
      :new_curation_concern_article_path,
      :new_curation_concern_image_path,
      :new_curation_concern_dataset_path,
      :new_collection_path,
      :collections_path,
      :user_profile_path,
      :person_depositors_path,
      :destroy_user_session_path,
      :new_help_request_path,
      { to: :main_app }
    )
  end
end
