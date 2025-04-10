<?php
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
            echo "DB Hiba: " . $this->db->connect_error . "\n";
        } else {
            echo "DB kapcsolat létrejött\n";
        }
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        echo "Új kapcsolat: {$conn->resourceId}\n";
    }

    // public function onMessage(ConnectionInterface $from, $msg)
    // {
    //     echo "📩 Üzenet: $msg\n";

    //     $data = json_decode($msg, true);
    //     if (!$data) {
    //         echo "❌ Hibás JSON adat!\n";
    //         return;
    //     }

    //     // === TÍPUS SZERINTI FELDOLGOZÁS ===
    //     $type = $data['type'] ?? 'message';

    //     if ($type === 'message') {
    //         // Új üzenet küldése
    //         if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['message_text'])) {
    //             echo "❌ Hiányzó üzenet adatok!\n";
    //             return;
    //         }

    //         $chatId = intval($data['chat_id']);
    //         $senderId = intval($data['sender_id']);
    //         $receiverId = intval($data['receiver_id']);
    //         $messageText = trim($data['message_text']);

    //         // 📥 Beszúrás adatbázisba
    //         $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
    //         $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);
    //         $stmt->execute();
    //         $messageId = $this->db->insert_id;

    //         // 📤 Lekérés az új üzenetre
    //         $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
    //         $query->bind_param("i", $messageId);
    //         $query->execute();
    //         $result = $query->get_result();
    //         $messageData = $result->fetch_assoc();
    //         $query->close();

    //         if (!$messageData) {
    //             echo "❌ Nem található az új üzenet!\n";
    //             return;
    //         }

    //         $messageDataPayload = [
    //             'type' => 'message',
    //             'data' => $messageData
    //         ];

    //         foreach ($this->clients as $client) {
    //             $client->send(json_encode($messageDataPayload));
    //         }

    //         echo "✅ Broadcast elküldve: " . json_encode($messageData) . "\n";
    //     }

    //     // === Olvasási státusz frissítés ===
    //     elseif ($type === 'read_status_update') {
    //         if (!isset($data['chat_id'], $data['user_id'])) {
    //             echo "❌ Hiányzó adatok a read_status_update-hez!\n";
    //             return;
    //         }

    //         $chatId = intval($data['chat_id']);
    //         $userId = intval($data['user_id']); //azért ő a reciever_id mert a küldő a fogja látni azt hogy "Látta" vagy "Kézbesítve"

    //         // ✅ is_read = 1 minden olyan üzenetre, amit a user kapott, de nem olvasott
    //         $update = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
    //         $update->bind_param("ii", $chatId, $userId);
    //         $update->execute();

    //         // 🔁 Lekérjük a frissített üzeneteket
    //         $stmt = $this->db->prepare("SELECT * FROM messages WHERE chat_id = ? AND receiver_id = ? AND is_read = 1");
    //         $stmt->bind_param("ii", $chatId, $userId);
    //         $stmt->execute();
    //         $result = $stmt->get_result();

    //         while ($row = $result->fetch_assoc()) {
    //             $messageReadPayload = [
    //                 'type' => 'message_read',  // 👈 fontos!
    //                 'data' => $row
    //             ];
    //             foreach ($this->clients as $client) {
    //                 $client->send(json_encode($messageReadPayload));
    //             }
    //         }


    //         echo "📬 is_read frissítés broadcastolva ($chatId, user: $userId)\n";
    //     } else {
    //         echo "❓ Ismeretlen üzenet típus: $type\n";
    //     }
    // } mentés

    public function onMessage(ConnectionInterface $from, $msg)
    {
        if (!$this->db->ping()) { //debug
            echo "🔄 Újrakapcsolódás az adatbázishoz...\n";
            $this->db = new mysqli("localhost", "root", "", "dbchatex");
            if ($this->db->connect_error) {
                echo "❌ Újrakapcsolódási hiba: " . $this->db->connect_error . "\n";
                return;
            }
        }

        echo "Üzenet: $msg\n";

        $data = json_decode($msg, true);
        if (!$data) {
            echo "Hibás JSON adat!\n";
            return;
        }

        // === TÍPUS SZERINTI FELDOLGOZÁS ===
        $type = $data['message_type'] ?? 'text';

        if (!isset($data['message_type'])) {
            echo "❌ Üzenetben nincs type!\n";
            return;
        }

        echo $type . "\n";

        if ($type === 'text') {
            // Szöveges üzenet
            if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['message_text'])) {
                echo "Hiányzó adatok a szöveges üzenethez!\n";
                return;
            }

            $chatId = intval($data['chat_id']);
            $senderId = intval($data['sender_id']);
            $receiverId = intval($data['receiver_id']);
            $messageText = trim($data['message_text']);
            $messageType = $data['message_type']; // 'text' típusú üzenet

            $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, message_type) VALUES (?, ?, ?, ?, ?)");
            $stmt->bind_param("iiiss", $chatId, $senderId, $receiverId, $messageText, $messageType);

            if (!$stmt->execute()) {
                echo "❌ INSERT hiba: " . $stmt->error . "\n";
                return;
            }
        } elseif ($type === 'file') {

            // echo "Érkezett fájl üzenet: " . json_encode($data) . "\n";
            // // Fájl üzenet
            // if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['file_name'], $data['message_file'])) {
            //     echo "❌ Hiányzó fájl adatok!\n";
            //     return;
            // }

            // $chatId = intval($data['chat_id']);
            // $senderId = intval($data['sender_id']);
            // $receiverId = intval($data['receiver_id']);
            // $messageType =  $data['message_type'];
            // $fileName = basename($data['file_name']);
            // $fileContent = base64_decode($data['message_file']);
            // $messageText = trim($data['message_text'] ?? '');

            // if (strlen($fileContent) > 100 * 1024 * 1024) {
            //     echo "❌ Fájl túl nagy (100MB+)!\n";
            //     return;
            // }

            // $uploadPath = __DIR__ . "/../uploads/files/$fileName"; // ✅ új helyre mentés
            // if (!file_exists(dirname($uploadPath))) {
            //     mkdir(dirname($uploadPath), 0777, true);
            // }
            // file_put_contents($uploadPath, $fileContent);

            // $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/files/" . $fileName;


            // if (file_put_contents($uploadPath, $fileContent) === false) {
            //     echo "❌ Nem sikerült menteni a fájlt: $uploadPath\n";
            //     return;
            // }

            // $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_type, message_file, message_text) VALUES (?, ?, ?, ?, ?, ?)");
            // $stmt->bind_param("iiisss", $chatId, $senderId, $receiverId, $messageType, $fileName, $messageText);

            // if (!$stmt->execute()) {
            //     echo "❌ INSERT hiba: " . $stmt->error . "\n";
            //     return;
            // } mentés


            if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
                echo "❌ Hiányzó fájl adatok!\n";
                return;
            }

            $chatId = intval($data['chat_id']);
            $senderId = intval($data['sender_id']);
            $receiverId = intval($data['receiver_id']);
            $messageText = trim($data['message_text'] ?? '');
            $files = $data['files']; // Ez egy tömb

            foreach ($files as $file) {
                $fileName = basename($file['file_name']);
                $fileContent = base64_decode($file['file_bytes']);

                if (strlen($fileContent) > 100 * 1024 * 1024) {
                    echo "❌ $fileName túl nagy!\n";
                    continue;
                }

                $uploadPath = __DIR__ . "/../uploads/files/$fileName";
                file_put_contents($uploadPath, $fileContent);

                $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/files/$fileName"; //TODO: itt hagytam abba holnap innen folyt köv, a message 1 file-t jelenít meg és nem többet, a terminál viszont jól mutatja de ott is egyet (lehet jól mutatná de nem küldi el mind a 2-t!)

                $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, message_type, message_file) VALUES (?, ?, ?, ?, 'file', ?)");
                $stmt->bind_param("iiiss", $chatId, $senderId, $receiverId, $messageText, $fileName);
                $stmt->execute();

                if (!$stmt->execute()) {
                    echo "❌ INSERT hiba: " . $stmt->error . "\n";
                    return;
                }
            }
        } elseif ($type === 'image') {
            // Kép üzenet
            if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['file_name'], $data['image_data'])) {
                echo "❌ Hiányzó kép adatok!\n";
                return;
            }

            $chatId = intval($data['chat_id']);
            $senderId = intval($data['sender_id']);
            $receiverId = intval($data['receiver_id']);
            $messageType = $data['message_type'];
            $fileName = basename($data['file_name']);
            $imageData = base64_decode($data['image_data']);

            $uploadPath = __DIR__ . "/../uploads/media/$fileName"; // ✅ új helyre mentés
            if (!file_exists(dirname($uploadPath))) {
                mkdir(dirname($uploadPath), 0777, true);
            }
            file_put_contents($uploadPath, $imageData);

            $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/media/" . $fileName;


            $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_type, message_file) VALUES (?, ?, ?, ?, ?)");
            $stmt->bind_param("iiiss", $chatId, $senderId, $receiverId, $messageType, $fileName);

            if (!$stmt->execute()) {
                echo "❌ INSERT hiba: " . $stmt->error . "\n";
                return;
            }
        } elseif ($type === 'read_status_update') {
            if (!isset($data['chat_id'], $data['user_id'])) {
                echo "Hiányzó adatok a read_status_update-hez!\n";
                return;
            }

            $chatId = intval($data['chat_id']);
            $userId = intval($data['user_id']);

            $update = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
            $update->bind_param("ii", $chatId, $userId);
            $update->execute();

            // 🔁 Lekérjük a frissített üzeneteket
            $stmt = $this->db->prepare("SELECT * FROM messages WHERE chat_id = ? AND receiver_id = ? AND is_read = 1");
            $stmt->bind_param("ii", $chatId, $userId);
            $stmt->execute();
            $result = $stmt->get_result();

            while ($row = $result->fetch_assoc()) {
                $messageReadPayload = [
                    'message_type' => 'message_read',
                    'data' => $row
                ];
                foreach ($this->clients as $client) {
                    $client->send(json_encode($messageReadPayload));
                }
            }
        }

        // Lekérjük a legutolsó üzenetet újra
        $messageId = $this->db->insert_id;
        $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
        $query->bind_param("i", $messageId);
        $query->execute();
        $result = $query->get_result();
        $messageData = $result->fetch_assoc();
        $query->close();

        if (!$messageData) {
            //echo "Nem található a beszúrt üzenet!\n";
            echo $messageData;
            return;
        }



        $broadcastType = $messageData['message_type'] ?? 'text';

        if ($broadcastType === 'file' || $broadcastType === 'image') {
            $fileName = $messageData['message_file'];
            $messageData['download_url'] = $downloadUrl;
        }

        $payload = [
            'message_type' => $broadcastType,
            'data' => $messageData,
        ];

        foreach ($this->clients as $client) {
            $client->send(json_encode($payload));
        }

        echo "Üzenet ($broadcastType) broadcastolva: " . json_encode($messageData) . "\n";
    }


    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn);
        echo "Kapcsolat lezárva: {$conn->resourceId}\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        echo "Hiba: {$e->getMessage()}\n";
        $conn->close();
    }
}
