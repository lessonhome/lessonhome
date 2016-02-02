package com.lessonhome.clientapp;

import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Created by vlad on 16.02.2015.
 */
public class Connection {

    Socket socket;
    IO.Options opts;
    private static Logger log = Logger.getLogger(Connection.class.getName());

    Connection ()
    {
        try {
/*
            SSLContext mySSLContext = new SSLContext();
            opts = new IO.Options();todo make ssl
            opts.sslContext = mySSLContext;
            socket = IO.socket("http://lessonhome.ru");
            socket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    log.log(Level.INFO, "connect args");
                    socket.emit("foo", "hi");
                }

            }).on("event", new Emitter.Listener() {

                @Override
                public void call(Object... args) {
                    try {
                        JSONObject obj = (JSONObject) args[0];
                        log.log(Level.INFO, "connect args", obj.getString("hello"));
                    }catch (Exception e){

                        log.log(Level.SEVERE, "Exception ", e);
                    }

                }

            }).on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {

                @Override
                public void call(Object... args) {}

            });
            socket.connect();


            JSONObject obj = new JSONObject();
            obj.put("hello", "server");
            obj.put("binary", new byte[42]);
            socket.emit("event", obj);

            log.log(Level.INFO, "before connect ");
            socket.disconnect();*/
        }catch (Exception e)
        {
            log.log(Level.SEVERE, "Exception ", e);
        }

    }

}
