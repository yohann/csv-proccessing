class CreateErrorLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :error_logs do |t|
      t.json :data
      t.string :message

      t.timestamps
    end
  end
end
