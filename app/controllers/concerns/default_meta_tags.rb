module DefaultMetaTags
  extend ActiveSupport::Concern

  included do
    before_action :set_default_meta_tags
  end

  private

  def set_default_meta_tags
    set_meta_tags(
      site: Rails.application.class.module_parent_name.titleize,
      reverse: true,
      separator: "|",
      og: {
        site_name: Rails.application.class.module_parent_name.titleize
      }
    )
  end
end
