# import nativesockets
import net
# import threadpool
import logging



proc processClient(s: Socket) =
  while true:
    let chunk = s.recvLine()
    if len(chunk) == 0:
      info "break"
      break
    echo repr(chunk)



when isMainModule:
  echo "start..."
  var sock = newSocket()
  sock.bindAddr(Port(1080), address="localhost")
  echo "listening on port 1080"
  sock.listen()

  var sock2 = newSocket()
  while true:
    sock.accept(sock2)
    info "accept 1 client"
    processClient(sock2)

  sock2.close()
  sock.close()