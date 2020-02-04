# frozen_string_literal: true

class SpecificAnimalSearcher
  include SnFoil::Rails::Searcher

  model_class Animal

  order_by :name, ASC

  includes :person

  distinct true

  setup do |scope, _params|
    scope.where(kingdom: 'Animalia')
  end

  filter(if: ->(p) { p[:kingdom].present? }) do |scope, params|
    scope.where(kingdom: params[:kingdom])
  end

  filter(if: ->(p) { p[:phylum].present? }) do |scope, params|
    scope.where(phylum: params[:phylum])
  end

  filter(unless: ->(p) { p[:family].blank? }) do |scope, params|
    scope.where(family: params[:family])
  end

  filter(unless: ->(p) { p[:subfamily].blank? }) do |scope, params|
    scope.where(subfamily: params[:subfamily])
  end

  filter do |scope, params|
    scope.where(genus: params[:genus])
  end
end
