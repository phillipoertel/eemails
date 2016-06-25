class Eemails::Runner
  def run
    puts "=" * 80

    files = Dir.glob('emails/**/*.emlx').sort

    emails = files.map { |file| Mail.new(File.read(file)) }

    sorted_emails = emails.sort_by do |email|
      matches = /issue (\d+)/i.match(email.subject)
      (matches && matches[1]) ? matches[1].to_i : -1
    end

    sorted_emails.each do |email|
      puts "#{email.subject}"
    end
  end
end