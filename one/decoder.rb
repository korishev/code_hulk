#!/usr/bin/env ruby
require './lib/cipher'
require './corpus/message_inputs'

print Cipher.new.setup_cipher(TEST_CIPHER_TEXT, TEST_CLEAR_TEXT).decode(ACTUAL_MESSAGE)
