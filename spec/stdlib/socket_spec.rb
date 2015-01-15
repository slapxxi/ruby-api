require "socket"

RSpec.describe Socket do
  include Helpers::Socket

  let(:socket) { Socket.new :INET, :STREAM }
  let(:address) { Socket.pack_sockaddr_in port, ip }

  after(:each) { socket.close }

  specify "listening for incoming connections" do
    expect(socket).to receive(:listen)

    socket.bind address
    socket.listen max_connections
  end

  describe "binding" do
    it "can't be bound to the port already in use" do
      second_socket = Socket.new :INET, :STREAM

      expect {socket.bind address}.not_to raise_error
      expect {second_socket.bind address}.to raise_error
    end

    it "can't be bound to an unknown interface" do
      unknown_address = Socket.pack_sockaddr_in 4481, '1.2.3.4'

      expect {socket.bind unknown_address}.to raise_error
    end
  end


  it "is a two-way communication channel" do
    child_socket, parent_socket = Socket.pair :UNIX, :DGRAM, 0

    fork do
      parent_socket.close
      instruction = child_socket.recv max_bytes
      child_socket.send "#{instruction} accomplished", 0
    end
    child_socket.close

    parent_socket.send 'Heavy lifting', 0

    expect(parent_socket.recv max_bytes).to eq 'Heavy lifting accomplished'
  end
end
