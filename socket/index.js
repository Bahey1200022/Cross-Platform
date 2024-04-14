const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 2000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//middlewre
app.use(express.json());
var clients = {};

io.on("connection", (socket) => {
  console.log("connetetd");
  console.log(socket.id, "has joined");
  
  socket.on("/signin", (msg) => {
    console.log(msg);
    clients[msg] = socket.id;
    console.log(clients);
  });

  socket.on("/chat", (msg) => {
    console.log(msg);
    let target=msg.receiver;
    console.log(clients[target]);
    if (clients[target]) io.to(clients[target]).emit("/chat",msg);
  });
});

server.listen(port, "0.0.0.0", () => {
  console.log("server started");
});