$LOAD_PATH << './lib'
require 'eemails'

task default: :"index:delete" do
  Eemails::Runner.new.run
end

namespace :index do
  task :delete do
    sh("curl -X DELETE http://localhost:9200/#{ES_INDEX_NAME}/")
    puts
  end

  # a mapping is like a table schema, i.e. describes the index structure
  task :mappings do
    sh("curl -X GET http://localhost:9200/#{ES_INDEX_NAME}/_mappings")
  end
end