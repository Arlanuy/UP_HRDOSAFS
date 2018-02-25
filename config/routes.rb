Rails.application.routes.draw do

  get 'evaluate/evaluation', to: 'evaluate#evaluation'

  get 'apply/studyleave', to: 'apply#studyleave'

  get 'apply/dsf', to: 'apply#dsf'

  get 'apply/sabbatical', to: 'apply#sabbatical'

  get 'apply/specialdetail', to: 'apply#specialdetail'

  get 'apply/enrollmentprivileges', to: 'apply#enrollmentprivileges'

  get 'web_pages/rsocalculator', to: 'web_pages#rsocalculator'

  root 'web_pages#landingpage'

  get '/landingpage', to: 'web_pages#landingpage'

  get '/rsocalculator', to: 'web_pages#rsocalculator'

  get 'contacts/new',   to: 'contacts#new'

  get 'contacts/create',    to: 'contacts#create'

  get 'evaluate/eval_SL', to: 'evaluate#eval_SL'

  get 'evaluate/eval_DSF', to: 'evaluate#eval_DSF'

  get 'evaluate/eval_Sab', to: 'evaluate#eval_Sab'

  get 'evaluate/eval_SD', to: 'evaluate#eval_SD'

  get 'evaluate/eval_EP', to: 'evaluate#eval_EP'

  resources :apply
  resources :evaluate
  resources :contacts, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
