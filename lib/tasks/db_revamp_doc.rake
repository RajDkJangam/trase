require 'db_helpers/search_path_helpers.rb'
require 'db_helpers/comment_helpers.rb'
include SearchPathHelpers
include CommentHelpers

namespace :db do
  namespace :revamp do
    namespace :doc do
      desc 'Update sql comments on schema objects and dump new structure.sql'
      task sql: [:environment] do
        data = YAML.safe_load(File.open("#{Rails.root}/db/schema_comments.yml"))
        with_search_path('revamp') do
          data['tables'].each do |table|
            comment_on_table(table['name'], table['comment'])
            table['columns']&.each do |column|
              comment_on_column(table['name'], column['name'], column['comment'] || '')
            end
            table['indexes']&.each do |index|
              comment_on_index(index['name'], index['comment'])
            end
          end
          data['materialized_views'].each do |table|
            comment_on_materialized_view(table['name'], table['comment'])
            table['columns']&.each do |column|
              comment_on_column(table['name'], column['name'], column['comment'] || '')
            end
          end
        end
        Rake::Task['db:structure:dump'].invoke
      end

      desc 'Generate html schema documentation'
      task html: [:sql] do
        exec `cd doc/db; java -jar schemaspy-6.0.0-rc2.jar -renderer :quartz -t pgsql -dp postgresql-42.1.4.jar -db trase_revamp -s revamp -u postgres -host localhost -o ./html`
      end
    end
  end
end
