# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:categories) do
      primary_key :id
      String :name, null: false
      String :description, null: false
    end
  end
  down do
    drop_table(:categories)
  end
end
