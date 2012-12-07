Letsplaylol::Application.routes.draw do
  root :to => "pages#home"

  get "home", :to => "pages#home"
  get "disclaimer", :to => "pages#disclaimer"
  post "save_listing", :to => "pages#save_listing"
  get "new_listing", :to => "pages#new_listing"
  match "edit_listing", :to => "pages#edit_listing"
  match "delete_listing", :to => "pages#delete_listing"
  match "examine_listing", :to => "pages#examine_listing"
  match "prolong_listing", :to => "pages#prolong_listing"
  match "search_listing", :to => "pages#search_listing"
  match "search", :to => "pages#search"

  # namespace 'pages' do
   
  #   get "disclaimer"
  #   post "save_listing"
  #   get "new_listing"
  #   match "edit_listing"
  #   match "delete_listing"
  #   match "examine_listing"
  #   get "search"
  #   match "prolong_listing"
  # end

end
