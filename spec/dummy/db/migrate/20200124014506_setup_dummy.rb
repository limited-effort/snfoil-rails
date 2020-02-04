# frozen_string_literal: true

class SetupDummy < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name
    end

    create_table :animals do |t|
      t.string :name
      t.string :kingdom
      t.string :phylum
      t.string :family
      t.string :subfamily
      t.string :tribe
      t.string :genus
      t.string :species

      t.references :person
    end
  end
end
