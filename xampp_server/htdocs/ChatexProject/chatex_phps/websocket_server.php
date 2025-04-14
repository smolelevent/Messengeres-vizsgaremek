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

    public function onMessage(ConnectionInterface $from, $msg)
    {
        echo "Üzenet: $msg\n";

        $data = json_decode($msg, true);
        if (!$data) {
            echo "Hibás JSON adat!\n";
            return;
        }

        // === TÍPUS SZERINTI FELDOLGOZÁS ===
        $messageId = null;

        $type = $data['message_type'] ?? 'text';

        if (!isset($data['message_type'])) {
            echo "❌ Üzenetben nincs type!\n";
            return;
        }

        echo "típus: " . $type . "\n";

        try {
            if ($type === 'text') {
                if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['message_text'])) {
                    echo "❌ Hiányzó adatok a szöveges üzenethez!\n";
                    return;
                }

                $chatId = intval($data['chat_id']);
                $senderId = intval($data['sender_id']);
                $receiverId = intval($data['receiver_id']);
                $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;

                $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

                if (!$stmt->execute()) {
                    echo "❌ INSERT hiba: " . $stmt->error . "\n";
                    return;
                }

                $messageId = $this->db->insert_id;
            } elseif ($type === 'file') {

                if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
                    echo "❌ Hiányzó fájl adatok!\n";
                    return;
                }

                $chatId = intval($data['chat_id']);
                $senderId = intval($data['sender_id']);
                $receiverId = intval($data['receiver_id']);
                $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;
                $files = $data['files'];

                $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

                if (!$stmt->execute()) {
                    echo "❌ INSERT hiba: " . $stmt->error . "\n";
                    return;
                }

                foreach ($files as $file) {
                    $fileName = basename($file['file_name']);
                    $fileContent = base64_decode($file['file_bytes']);

                    echo "Fájl hossza mielőtt szorzunk:" . strlen($fileContent) . "\n";
                    if (strlen($fileContent) > 100 * 1024 * 1024) {
                        echo "❌ $fileName túl nagy!\n";
                        continue;
                    }

                    $uploadPath = __DIR__ . "/../uploads/files/$fileName";
                    file_put_contents($uploadPath, $fileContent);

                    $messageId = $this->db->insert_id;

                    $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/files/$fileName";

                    $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'file', ?, ?)");
                    $attStmt->bind_param("iss", $messageId, $fileName, $downloadUrl);
                    $attStmt->execute();
                }

                if (!$messageId) {
                    echo "❌ Üres message ID, nem tudjuk csatolmányokat menteni!\n";
                    return;
                }
            } elseif ($type === 'image') { //ITT MÉG NEM TARTUNK ------------------------------------------------------------------
                if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['file_name'], $data['image_data'])) {
                    echo "❌ Hiányzó kép adatok!\n";
                    return;
                }

                $chatId = intval($data['chat_id']);
                $senderId = intval($data['sender_id']);
                $receiverId = intval($data['receiver_id']);
                $fileName = basename($data['file_name']);
                $imageData = base64_decode($data['image_data']);

                $uploadPath = __DIR__ . "/../uploads/media/$fileName"; // ✅ új helyre mentés
                if (!file_exists(dirname($uploadPath))) {
                    mkdir(dirname($uploadPath), 0777, true);
                }
                file_put_contents($uploadPath, $imageData);

                $messageId = $this->db->insert_id;

                $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/media/" . $fileName;


                $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);


                if (!$stmt->execute()) {
                    echo "❌ INSERT hiba: " . $stmt->error . "\n";
                    return;
                } //ITT MÉG NEM TARTUNK VÉGE ------------------------------------------------------------------
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

                $messageId = $this->db->insert_id;
            } elseif ($type === 'ping') {
                echo "📡 Ping érkezett a {$from->resourceId}-tól\n";
                return;
            }

            if ($messageId !== null) {
                $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
                $query->bind_param("i", $messageId);
                $query->execute();
                $result = $query->get_result();
                $messageData = $result->fetch_assoc();
                $query->close();

                if (!$messageData) {
                    echo "Nem található a beszúrt üzenet!\n";
                    return;
                }

                // attachments is csak ilyenkor:
                $attQuery = $this->db->prepare("SELECT file_name, download_url FROM message_attachments WHERE message_id = ?");
                $attQuery->bind_param("i", $messageId);
                $attQuery->execute();
                $attResult = $attQuery->get_result();

                $attachments = [];
                while ($row = $attResult->fetch_assoc()) {
                    $attachments[] = $row;
                }

                $payload = [
                    'message_type' => $type,
                    'data' => array_merge($messageData, ['attachments' => $attachments])
                ];

                foreach ($this->clients as $client) {
                    $client->send(json_encode($payload));
                }

                echo "Üzenet ($type) broadcastolva: " . json_encode($messageData) . "\n";
            }
        } catch (Throwable $e) {
            echo "⚠️ Kivétel történt: " . $e->getMessage() . "\n";
        }
    }


    // public function onMessage(ConnectionInterface $from, $msg) mentés
    // {
    //     echo "Üzenet: $msg\n";

    //     $data = json_decode($msg, true);
    //     if (!$data) {
    //         echo "Hibás JSON adat!\n";
    //         return;
    //     }

    //     // === TÍPUS SZERINTI FELDOLGOZÁS ===
    //     $type = $data['message_type'] ?? 'text';

    //     if (!isset($data['message_type'])) {
    //         echo "❌ Üzenetben nincs type!\n";
    //         return;
    //     }

    //     echo "típus: " . $type . "\n";

    //     try {
    //         if ($type === 'text') {
    //             if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['message_text'])) {
    //                 echo "❌ Hiányzó adatok a szöveges üzenethez!\n";
    //                 return;
    //             }

    //             $chatId = intval($data['chat_id']);
    //             $senderId = intval($data['sender_id']);
    //             $receiverId = intval($data['receiver_id']);
    //             $messageText = trim($data['message_text']);

    //             $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
    //             $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

    //             if (!$stmt->execute()) {
    //                 echo "❌ INSERT hiba: " . $stmt->error . "\n";
    //                 return;
    //             }

    //             $messageId = $this->db->insert_id;
    //         } elseif ($type === 'file') {

    //             if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
    //                 echo "❌ Hiányzó fájl adatok!\n";
    //                 return;
    //             }

    //             $chatId = intval($data['chat_id']);
    //             $senderId = intval($data['sender_id']);
    //             $receiverId = intval($data['receiver_id']);
    //             $messageText = trim($data['message_text'] ?? '');
    //             $files = $data['files'];

    //             $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
    //             $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

    //             if (!$stmt->execute()) {
    //                 echo "❌ INSERT hiba: " . $stmt->error . "\n";
    //                 return;
    //             }

    //             foreach ($files as $file) {
    //                 $fileName = basename($file['file_name']);
    //                 $fileContent = base64_decode($file['file_bytes']);

    //                 echo "Fájl hossza mielőtt szorzunk:" . strlen($fileContent) . "\n";
    //                 if (strlen($fileContent) > 100 * 1024 * 1024) {
    //                     echo "❌ $fileName túl nagy!\n";
    //                     continue;
    //                 }

    //                 $uploadPath = __DIR__ . "/../uploads/files/$fileName";
    //                 file_put_contents($uploadPath, $fileContent);

    //                 $messageId = $this->db->insert_id;

    //                 $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/files/$fileName";

    //                 $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'file', ?, ?)");
    //                 $attStmt->bind_param("iss", $messageId, $fileName, $downloadUrl);
    //                 $attStmt->execute();
    //             }

    //             if (!$messageId) {
    //                 echo "❌ Üres message ID, nem tudjuk csatolmányokat menteni!\n";
    //                 return;
    //             }
    //         } elseif ($type === 'image') { //ITT MÉG NEM TARTUNK ------------------------------------------------------------------
    //             if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['file_name'], $data['image_data'])) {
    //                 echo "❌ Hiányzó kép adatok!\n";
    //                 return;
    //             }

    //             $chatId = intval($data['chat_id']);
    //             $senderId = intval($data['sender_id']);
    //             $receiverId = intval($data['receiver_id']);
    //             $fileName = basename($data['file_name']);
    //             $imageData = base64_decode($data['image_data']);

    //             $uploadPath = __DIR__ . "/../uploads/media/$fileName"; // ✅ új helyre mentés
    //             if (!file_exists(dirname($uploadPath))) {
    //                 mkdir(dirname($uploadPath), 0777, true);
    //             }
    //             file_put_contents($uploadPath, $imageData);

    //             $messageId = $this->db->insert_id;

    //             $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/media/" . $fileName;


    //             $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
    //             $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);


    //             if (!$stmt->execute()) {
    //                 echo "❌ INSERT hiba: " . $stmt->error . "\n";
    //                 return;
    //             } //ITT MÉG NEM TARTUNK VÉGE ------------------------------------------------------------------
    //         } elseif ($type === 'read_status_update') {
    //             if (!isset($data['chat_id'], $data['user_id'])) {
    //                 echo "Hiányzó adatok a read_status_update-hez!\n";
    //                 return;
    //             }

    //             $chatId = intval($data['chat_id']);
    //             $userId = intval($data['user_id']);

    //             $update = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
    //             $update->bind_param("ii", $chatId, $userId);
    //             $update->execute();

    //             $stmt = $this->db->prepare("SELECT * FROM messages WHERE chat_id = ? AND receiver_id = ? AND is_read = 1");
    //             $stmt->bind_param("ii", $chatId, $userId);
    //             $stmt->execute();
    //             $result = $stmt->get_result();

    //             while ($row = $result->fetch_assoc()) {
    //                 $messageReadPayload = [
    //                     'message_type' => 'message_read',
    //                     'data' => $row
    //                 ];
    //                 foreach ($this->clients as $client) {
    //                     $client->send(json_encode($messageReadPayload));
    //                 }
    //             }

    //             $messageId = $this->db->insert_id;
    //         } elseif ($type === 'ping') {
    //             echo "📡 Ping érkezett a {$from->resourceId}-tól\n";
    //             return;
    //         }

    //         // Lekérjük a legutolsó üzenetet újra
    //         $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
    //         $query->bind_param("i", $messageId);
    //         $query->execute();
    //         $result = $query->get_result();
    //         $messageData = $result->fetch_assoc();
    //         $query->close();

    //         if (!$messageData) {
    //             echo "Nem található a beszúrt üzenet!\n";
    //             echo $messageData . "\n";
    //             return;
    //         }

    //         // Kapcsolódó csatolmányok
    //         $attQuery = $this->db->prepare("SELECT file_name, download_url FROM message_attachments WHERE message_id = ?");
    //         $attQuery->bind_param("i", $messageId);
    //         $attQuery->execute();
    //         $attResult = $attQuery->get_result();

    //         $attachments = [];
    //         while ($row = $attResult->fetch_assoc()) {
    //             $attachments[] = $row;
    //         }

    //         $messageData['message_type'] = $type;
    //         $payload = [
    //             'message_type' => $type,
    //             'data' => array_merge($messageData, ['attachments' => $attachments])
    //         ];


    //         foreach ($this->clients as $client) {
    //             $client->send(json_encode($payload));
    //         }

    //         echo "Üzenet ($type) broadcastolva: " . json_encode($messageData) . "\n";
    //     } catch (Throwable $e) {
    //         echo "⚠️ Kivétel történt: " . $e->getMessage() . "\n";
    //     }
    // }

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
