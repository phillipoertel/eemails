require 'elasticsearch'
# require 'elasticsearch/extensions/ansi'

class Eemails::Runner

  ES_LOGGING      = false
  ES_TYPE         = 'email'

  def run
    puts "=" * 80
    index_files(Dir.glob('emails/**/*.emlx'))
    es.indices.refresh(index: ES_INDEX_NAME)
    count = query(match_all: {})['hits']['total']
    puts "Index #{ES_INDEX_NAME} now has #{count} documents."
    p query(match: { subject: 'Ruby' })
  end

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

  def query(query)
    es.search(index: ES_INDEX_NAME, body: { query: query })
  end

  def es
    @elasticsearch_client ||= Elasticsearch::Client.new(trace: ES_LOGGING)
  end

end