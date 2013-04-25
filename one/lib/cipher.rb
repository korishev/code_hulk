class Cipher

  def add_chars_default_proc
    @chars.default_proc =  proc do |hash, missing_key|
      $STDERR.puts "I don't know how to translate #{missing_key}"
      hash[missing_key] = "."
    end
  end

  def clear_headers_and_footers(input)
    input.gsub!(/^==BEGIN.*|^==END.*/, "")
  end

  def setup_cipher(cipher_text, clear_text)
    clear_headers_and_footers(cipher_text)
    clear_headers_and_footers(clear_text)
    @chars = Hash[ cipher_text.split("").zip(clear_text.split("")) ]
    add_chars_default_proc
    self
  end

  def decode(cipher_text)
    output = StringIO.new
    cipher_text.each_line do |line|
      if line.match(/^==BEGIN/)
        output << "==BEGIN-DECODED-MESSAGE==\n"
      elsif line.match(/^==END/)
        output << "==END-DECODED-MESSAGE==\n"
      else
        line.each_char do |char|
          output << @chars[char]
        end
      end
    end
    output.string
  end
end
