require "socket"

RSpec.describe Socket do
  MAXLEN = 10_000

  it "is a two-way communication channel" do
    child_socket, parent_socket = Socket.pair :UNIX, :DGRAM, 0

    fork do
      parent_socket.close
      instruction = child_socket.recv MAXLEN
      child_socket.send "#{instruction} accomplished", 0
    end
    child_socket.close

    parent_socket.send 'Heavy lifting', 0

    expect(parent_socket.recv MAXLEN).to eq 'Heavy lifting accomplished'
  end
end
