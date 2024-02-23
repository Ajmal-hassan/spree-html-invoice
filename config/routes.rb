Spree::Core::Engine.routes.append do
  namespace :admin do
    get 'invoice/:id(/:template)', to: 'invoice#show'
    get 'orders/:order_id/return_authorizations/:id/print', to: 'return_authorizations#print'
  end
end
