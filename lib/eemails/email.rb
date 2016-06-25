require 'mail'
require 'nokogiri'

# uses https://github.com/mikel/mail
# 
# mail.sender.address  #=> 'mikel@test.lindsaar.net'
# mail.subject         #=> "This is the subject"
# mail.date.to_s       #=> '21 Nov 1997 09:55:06 -0600'
# mail.message_id      #=> '<4D6AA7EB.6490534@xxx.xxx>'
# mail.to              #=> 'bob@test.lindsaar.net'
# mail.cc              #=> 'sam@test.lindsaar.net'
# mail.body.decoded    #=> 'This is the body of the email...
# 
# mail.multipart?          #=> true
# mail.parts.length        #=> 2
# mail.body.preamble       #=> "Text before the first part"
# mail.body.epilogue       #=> "Text after the last part"
# mail.parts.map { |p| p.content_type }  #=> ['text/plain', 'application/pdf']
# mail.parts.map { |p| p.class }         #=> [Mail::Message, Mail::Message]
# mail.parts[0].content_type_parameters  #=> {'charset' => 'ISO-8859-1'}
# mail.parts[1].content_type_parameters  #=> {'name' => 'my.pdf'}
# 
class Eemails::Email

  def initialize(mail_string)
    @mail_string = mail_string
  end

  def sender
    mail.sender
  end

  def message_id
    mail.message_id
  end
  
  def subject
    mail.subject
  end

  def date
    # mail.date.iso8601
    mail.date.iso8601
  end

  # extract text from HTML
  def body
    if mail.multipart?
      mail.parts.map { |part| Nokogiri::HTML(part.body.decoded).text }.join("\n\n")
    else
      mail.body.decoded
    end
  end

  def mail
    @mail ||= Mail.new(@mail_string)
  end

  # FIXME body is not indexed for now since some emails have utf8 issues and it's a lot of data
  def to_indexable_hash
    %i(sender message_id subject date).inject({}) do |hash, field|
      hash[field] = send(field)
      hash
    end
  end
end