<?php
require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/db.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    protected $clients; //spl object storage

    public function __construct()
    {
        $this->clients = new \SplObjectStorage;
        //$this->db = new mysqli("localhost", "root", "", "dbchatex");
        global $conn;
        if ($this->$conn->connect_error) {
            echo "Adatbázis kapcsolódási hiba: " . $this->$conn->connect_error . "\n";
        } else {
            echo "Adatbázis kapcsolat létrejött.\n";
        }
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        echo "Új kapcsolat: {$conn->resourceId}\n";
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        echo "Beérkezett üzenet: $msg\n";

        $data = json_decode($msg, true);

        if (!$data || !isset($data['chat_id'], $data['sender_id'], $data['message'])) {
            echo "Hibás adat!\n";
            return;
        }

        // Adatbázis mentés (ha kell)
        $chatId = intval($data['chat_id']);
        $senderId = intval($data['sender_id']);
        $messageText = $data['message'];

        global $conn;
        $stmt = $conn->prepare("INSERT INTO messages (chat_id, sender_id, message_text) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $chatId, $senderId, $messageText);
        $stmt->execute();
        $stmt->close();

        // Broadcast az összes clientnek
        foreach ($this->clients as $client) {
            $client->send(json_encode([
                'chat_id' => $chatId,
                'sender_id' => $senderId,
                'message_text' => $messageText,
                'sent_at' => date("c")  // ISO8601 időbélyeg
            ]));
        }
    }


    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn);
        echo "Kapcsolat lezárva: {$conn->resourceId}\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        $conn->close();
    }
}
