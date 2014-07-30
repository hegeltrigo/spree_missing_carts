Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  match '/admin/reports/missing_carts' => 'admin/reports#missing_carts',  :via  => [:get, :post], :as   => 'missing_carts_admin_reports'
end
