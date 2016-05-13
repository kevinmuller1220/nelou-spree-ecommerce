# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.logo = 'logo.svg'
  config.admin_interface_logo = 'logo.svg'
  config.currency = 'EUR'
  config.layout = 'layouts/application'
  config.track_inventory_levels = false
  config.address_requires_state = false
  config.show_variant_full_price = true
  config.auto_capture = true
end

Spree::Config.show_products_without_price = true # To make automatically exchanged prices work

Devise.setup do |config|
  config.allow_unconfirmed_access_for = 1.week
  config.router_name = :spree
end

SpreeI18n::Config.available_locales = [:en, :de]
SpreeI18n::Config.supported_locales = [:en, :de]

# Require confirmation of user emails
Spree::Auth::Config[:confirmable] = true
# Set Spree to use the spree_auth_devise user class
Spree.user_class = 'Spree::User'

Spree::Image.attachment_definitions[:attachment][:styles] = {
  mini: '50x75>',
  mini_2x: '100x150>',
  small: '150x225>',
  small_2x: '300x450>',
  product: '300x450>',
  product_2x: '600x900>',
  large: '1000x1500>',
  large_2x: '2000x3000>'
}

# Add permitted attributes for standard spree classes
Spree::PermittedAttributes.product_attributes.push :designer_label_id, :eco, :photo_credits, :production_type
Spree::PermittedAttributes.variant_attributes.push :limited, :limited_items, :limited_items_sold, :original_price
Spree::PermittedAttributes.user_attributes.push :terms_and_services, :privacy_and_conditions, designer_label_attributes: [:name]
Spree::PermittedAttributes.address_attributes.push :gender

# Split orders by designer label
Rails.application.config.spree.stock_splitters << Nelou::Stock::Splitter::DesignerLabel

Rails.application.config.to_prepare do
  require_dependency 'spree/authentication_helpers'
end