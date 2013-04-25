require 'rspec'
require 'cipher'

TEST_CIPHER_TEXT = <<EOF
==BEGIN-ENCODED-MESSAGE==
wvEr2JmJUs2JRr:78wWSobOFIm9AB?
0s2E:7-f/-G/N-.f7jN:Mi:.CDfGX7tn!

ys6vs6h7ys6vs6h7KEH4Ea2Jr17JddEvJs2E7saaJa2srUE,7RlExh73sa2sxvah7ys6DDD
==END-ENCODED-MESSAGE==
EOF

TEST_CLEAR_TEXT = <<EOF
==BEGIN-DECODED-MESSAGE==
Identification: lIbYpESzkf?-Hh
Date: 07/08/2057 12:34:56.789 CGT

Mayday! Mayday! Requesting immediate assistance, over! Bastards! May...
==END-DECODED-MESSAGE==
EOF

ACTUAL_MESSAGE = <<EOF
==BEGIN-ENCODED-MESSAGE==
wvEr2JmJUs2JRr:7a1AJvvHvAmRRWsxWsFAvJvAJAaoE88A2?s2AxJ1?29
0s2E:7-f/-G/N-.f7jN:MC:ifDCGN7tn!

0Esx7bsx2?8Jr1a,
SR47sxE7?ExEW67rR2JmJEv72?s27s8876R4x7WsaE7sxE7WE8Rr172R74aD

SR4xa7aJrUExE86,
!?E7OosUE7B48Ia
==END-ENCODED-MESSAGE==
EOF

ACTUAL_CLEAR_TEXT = <<EOF
==BEGIN-DECODED-MESSAGE==
Identification: sg-iddqd-foobarbaz-did-i-spell-that-right?
Date: 07/08/2057 12:36:47.682 CGT

Dear Earthlings,
You are hereby notified that all your base are belong to us.

Yours sincerely,
The Space Hulks
==END-DECODED-MESSAGE==
EOF

describe Cipher do
  it "can be created with no arguments" do
    Cipher.new.should be_a_kind_of Cipher
  end

  describe "setup_cipher" do
    it "must respond to setup_cipher, with two args" do
      described_class.new.should respond_to(:setup_cipher)
      lambda { described_class.new.setup_cipher }.should raise_error(ArgumentError)
      lambda { described_class.new.setup_cipher("hello") }.should raise_error(ArgumentError)
      lambda { described_class.new.setup_cipher("hello", "world") }.should_not raise_error(ArgumentError)
    end
  end

  describe "decode" do

    it "must exist" do
      described_class.new.should respond_to(:decode)
    end

    it "requires one argument" do
      lambda{described_class.new.decode}.should raise_error(ArgumentError)
    end

    # wvEr2JmJUs2JRr:78wWSobOFIm9AB?
    # Identification: lIbYpESzkf?-Hh

    context "when setup with cipher" do
      subject { described_class.new.setup_cipher(TEST_CIPHER_TEXT, TEST_CLEAR_TEXT) }

      it "should turn 'w' into 'I'" do
        subject.decode('w').should == 'I'
      end

      it "should turn 'v' into 'd'" do
        subject.decode('v').should == 'd'
      end
    end

    it "should decode a message properly" do
      described_class.new.setup_cipher(TEST_CIPHER_TEXT, TEST_CLEAR_TEXT).decode(TEST_CIPHER_TEXT).should == TEST_CLEAR_TEXT
    end

    it "should properly decode the actual message" do
      described_class.new.setup_cipher(TEST_CIPHER_TEXT, TEST_CLEAR_TEXT).decode(ACTUAL_MESSAGE).should == ACTUAL_CLEAR_TEXT
    end
  end
end
