<?php
// require __DIR__ . '/vendor/autoload.php';
// require __DIR__ . '/db.php';

// use Ratchet\MessageComponentInterface;
// use Ratchet\ConnectionInterface;

// class ChatServer implements MessageComponentInterface
// {
//     protected $clients; //spl object storage
//     private $db;

//     public function __construct()
//     {
//         $this->clients = new \SplObjectStorage;
//         $this->db = new mysqli("localhost", "root", "", "dbchatex");

//         if ($this->db->connect_error) {
//             echo "Adatbázis kapcsolódási hiba: " . $this->db->connect_error . "\n";
//         } else {
//             echo "Adatbázis kapcsolat létrejött.\n";
//         }
//     }

//     public function onOpen(ConnectionInterface $conn)
//     {
//         $this->clients->attach($conn);
//         echo "Új kapcsolat: {$conn->resourceId}\n";
//     }

//     public function onMessage(ConnectionInterface $from, $msg)
//     {
//         echo "Beérkezett üzenet: $msg\n";

//         $data = json_decode($msg, true);

//         if (!$data || !isset($data['chat_id'], $data['sender_id'], $data['message'])) {
//             echo "Hibás adat!\n";
//             return;
//         }

//         // Adatbázis mentés (ha kell)
//         $chatId = intval($data['chat_id']);
//         $senderId = intval($data['sender_id']);
//         $messageText = $data['message'];

//         global $conn;
//         $stmt = $conn->prepare("INSERT INTO messages (chat_id, sender_id, message_text) VALUES (?, ?, ?)");
//         $stmt->bind_param("iis", $chatId, $senderId, $messageText);
//         $stmt->execute();
//         $stmt->close();

//         // Broadcast az összes clientnek
//         foreach ($this->clients as $client) {
//             $client->send(json_encode([
//                 'chat_id' => $chatId,
//                 'sender_id' => $senderId,
//                 'message_text' => $messageText,
//                 'sent_at' => date("c")  // ISO8601 időbélyeg
//             ]));
//         }
//     }


//     public function onClose(ConnectionInterface $conn)
//     {
//         $this->clients->detach($conn);
//         echo "Kapcsolat lezárva: {$conn->resourceId}\n";
//     }

//     public function onError(ConnectionInterface $conn, \Exception $e)
//     {
//         $conn->close();
//     }
// } mentés

require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/db.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    protected $clients;
    private $db;

    public function __construct()
    {
        $this->clients = new \SplObjectStorage;
        $this->db = new mysqli("localhost", "root", "", "dbchatex");

        if ($this->db->connect_error) {
            echo "❌ DB Hiba: " . $this->db->connect_error . "\n";
        } else {
            echo "✅ DB kapcsolat létrejött\n";
        }
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        echo "🔗 Új kapcsolat: {$conn->resourceId}\n";
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        echo "📩 Üzenet: $msg\n";

        $data = json_decode($msg, true);

        if (!$data || !isset($data['chat_id'], $data['sender_id'], $data['message_text'])) {
            echo "❌ Hiányzó adat!\n";
            return;
        }

        $chatId = intval($data['chat_id']);
        $senderId = intval($data['sender_id']);
        $messageText = trim($data['message_text']);

        // 🗃️ Mentés az adatbázisba
        $stmt = $this->db->prepare("
            INSERT INTO messages (chat_id, sender_id, message_text)
            VALUES (?, ?, ?)
        ");
        $stmt->bind_param("iis", $chatId, $senderId, $messageText);
        $stmt->execute();

        $messageId = $this->db->insert_id;

        // 🔄 Lekérjük a teljes adatot
        $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
        $query->bind_param("i", $messageId);
        $query->execute();
        $result = $query->get_result();
        $messageData = $result->fetch_assoc();
        $query->close();

        if (!$messageData) {
            echo "❌ Nem található az imént beszúrt üzenet!\n";
            return;
        }

        // 🔊 Broadcast mindenkinek
        foreach ($this->clients as $client) {
            $client->send(json_encode($messageData));
        }

        echo "✅ Broadcast elküldve: " . json_encode($messageData) . "\n";
    }

    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn);
        echo "❎ Kapcsolat lezárva: {$conn->resourceId}\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        echo "💥 Hiba: {$e->getMessage()}\n";
        $conn->close();
    }
}
