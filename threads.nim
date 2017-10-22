import threadpool
import os
import fibonacci

proc fib_thread(n: int): int =
    result = fibonacci.fibonacci(n)
    echo result

proc spaw_only =
    for x in 39..40:
        discard spawn fib_thread(x)
    sync()


proc spaw_store =
    var responses = newSeq[int](2)
    for i in 39..40:
        responses.add(^spawn fib_thread(i))

    sync()
    echo responses


# Channels cannot be passed between threads. Use globals or pass them by ptr.
var channel: Channel[string]


proc jobs =
    echo "                    I'm Job. I'm heavy. "


proc sender {.thread.} =
    var text = ""
    echo "Note: type 'exit' to exit."
    while true:
        echo "Say something:"
        text = readLine(stdin)
        channel.send(text)
        if text == "exit":
            echo "sender exit."
            break
        os.sleep(milsecs = 200)

proc receiver {.thread.} =
    var message = ""
    while true:
        message = channel.recv()
        echo "                    I'm worker. You typed: \"" & message & "\". I'm working on it."
        if message == "exit":
            echo "                    receiver exit."
            break
        else:
            jobs()



proc spaw_pass_content_via_channel =
    channel.open()

    spawn sender()
    spawn receiver()
    sync()

    channel.close()


when isMainModule:
    # spaw_only()
    # spaw_store()
    spaw_pass_content_via_channel()





# import threadpool

# var channel: Channel[string]


# proc main =

#   for ix in countup(1,ch_max):
#     echo "opening: " & $ix & "/" & $ch_max
#     channels[ix].open()

#   for ix in countup(1,ch_max):
#     echo "spawning: " & $ix & "/" & $ch_max
#     spawn consumer(ix)

#   for ix in countup(1,ch_max):
#     echo "sending: " & $ix & "/" & $ch_max
#     channels[ix].send("send by " & $ix)


#   sync()
#   echo "synced"

#   for ix in countup(1,ch_max): channels[ix].close()

# when isMainModule:
#   echo "<<begin>>"
#   main()
#   echo "<<end>>"
