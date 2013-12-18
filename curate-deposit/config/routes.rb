Curate::Deposit::Engine.routes.draw do
  get 'works/new/:work_type', to: 'works#new', as: :new_work
  post 'works/:work_type', to: 'works#create'
  get 'works/:id', to: 'works#show', as: :work
  get 'works/:id/edit', to: 'works#edit', as: :edit_work
  put 'works/:id', to: 'works#update'
  get 'works(/:work_type)', to: 'works#index', as: :works
  delete 'works/:id', to: 'works#destroy'
end
