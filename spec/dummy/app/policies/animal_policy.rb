class AnimalPolicy
  include SnFoil::Policy

  permission(:create?) { true }

  permission :show?, with: :create?
  permission :update?, with: :create?
  permission :destroy?, with: :create?
  permission :index?, with: :create?
end