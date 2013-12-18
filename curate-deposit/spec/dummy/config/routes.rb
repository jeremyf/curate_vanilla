Rails.application.routes.draw do

  mount Curate::Deposit::Engine => "/deposit"
end
