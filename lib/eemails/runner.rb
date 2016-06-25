require 'elasticsearch'
require 'pathname'
# require 'elasticsearch/extensions/ansi'

class Eemails::Runner

  ES_LOGGING      = false
  ES_TYPE         = 'email'

  def index_path(path)
    path = Pathname.new(path).join('**/*.emlx')
    file_paths = Dir.glob(path)
    puts "Indexing #{file_paths.count} files from ... #{path}"
    start_time = Time.now
    index_files(file_paths)
    es.indices.refresh(index: ES_INDEX_NAME)
    puts "Took #{Time.now - start_time}s"
  end

  def run_search
    print_num_documents

    result = search(match: { subject: 'Ruby' })
    result_info(result, "subject: Ruby")
    
    result = search(
      "range": {
        "date": {
          "gte": "2016-01-01",
        }
      }
    )
    result_info(result, "gte 2016-01-01")
  end

  private

  def index_files(files)
    files.each do |file| 
      email = Eemails::Email.new(File.read(file))
      index(email.to_indexable_hash)
    end
  end

  def index(document)
    es.index(index: ES_INDEX_NAME, type: ES_TYPE, body: document)
  rescue
    # FIXME some fail due to utf8 issues, ignore for now
    # puts "Failed to index #{document[:subject]}"
  end

  def search(query)
    es.search(index: ES_INDEX_NAME, body: { query: query })
  end

  def es
    @elasticsearch_client ||= Elasticsearch::Client.new(trace: ES_LOGGING)
  end

  def result_info(result, label = 'Query')
    puts "#{label} returned #{result['hits']['total']} results."
    puts "First results:" if result['hits']['total'] > 0
    result['hits']['hits'].take(5).each do |row|
      p row["_source"]
    end
  end

  def print_num_documents
    count = search(match_all: {})['hits']['total']
    puts "Index #{ES_INDEX_NAME} now has #{count} documents."
  end

end