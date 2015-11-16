Rails.application.routes.draw do
  #-------------------------------------------#
  # Admin
  #-------------------------------------------#
  devise_for :admin_users,
    path: 'admin',
    controllers: {
      passwords: 'admin/devise_overrides/passwords',
      sessions:  'admin/devise_overrides/sessions'
    }

  namespace :admin do
    get '/' => 'base#index'
    get '/bootstrap.json' => 'base#bootstrap_data'

    # rss
    resources :tape_subscriptions, controller: 'tape_subscriptions'
    resources :tape_posts, controller: 'tape_posts'

    # journal
    resources :journal_posts, controller: 'journal_posts'
    resources :journal_pages, controller: 'journal_pages'

    # files
    resources :assets, controller: 'assets' # Loft::Asset

    # settings
    resources :menus, controller: 'menus' # Ants::Menus
    resources :admin_users, controller: 'admin_users' # Ants::AdminUser
    resources :redirects, controller: 'redirects' # Ants::Redirect
  end

  #-------------------------------------------#
  # App Routes
  #-------------------------------------------#
  root 'journal_posts#index'

  get '/:slug/preview' => 'journal_pages#preview',  as: :preview_journal_page, :constraints => Constraints::JournalPages
  get '/:slug'         => 'journal_pages#show',     as: :show_journal_page,    :constraints => Constraints::JournalPages
  get '/:hex/preview'  => 'journal_posts#preview',  as: :preview_journal_post
  get '/:hex/:slug'    => 'journal_posts#show',     as: :show_journal_post,    :constraints => Constraints::JournalPosts
  get '/:hex'          => 'journal_posts#redirect', as: :journal_post_short,   :constraints => Constraints::JournalPosts

  #-------------------------------------------#
  # Redirects, ideally this should go last
  #-------------------------------------------#
  get "/*id" => 'redirects#show', :constraints => Constraints::Redirects
end
