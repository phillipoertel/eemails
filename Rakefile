$LOAD_PATH << './lib'
require 'eemails'

namespace :index do

  task :index do
    # path = '/Users/phillip/Library/Mail/V3/169A4770-EF5D-450B-AF82-AD7E5B20A064'
    path = 'emails'
    Eemails::Runner.new.index_path(path)
  end

  task :search do
    Eemails::Runner.new.run_search
  end


  task :delete do
    sh("curl -X DELETE http://localhost:9200/#{ES_INDEX_NAME}/")
    puts
  end

  # a mapping is like a table schema, i.e. describes the index structure
  task :mappings do
    sh("curl -X GET http://localhost:9200/#{ES_INDEX_NAME}/_mappings")
  end
end