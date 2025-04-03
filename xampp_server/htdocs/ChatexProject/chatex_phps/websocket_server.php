<?php
require __DIR__ . '/vendor/autoload.php';
//require __DIR__ . '/db.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    protected $clients; //spl object storage

    public function __construct()
    {
        $this->clients = new \SplObjectStorage;
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn); //ez a storage kapcsolódik az adatbázishoz
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        $data = json_decode($msg, true);

        // Továbbküldés MINDENKINEK
        foreach ($this->clients as $client) {
            $client->send($msg); //elküldi a storage-nak
        }

        // Mentés adatbázisba
        $conn = new mysqli("localhost", "root", "", "dbchatex");
        $stmt = $conn->prepare("INSERT INTO messages (chat_id, sender_id, message_text) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $data["chat_id"], $data["sender_id"], $data["message"]);
        $stmt->execute();
        $stmt->close();
    }

    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn); //a storage nem küldi tovább az adatokat
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        $conn->close();
    }
}
