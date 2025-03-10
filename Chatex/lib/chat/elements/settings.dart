import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Beállítások',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          Icon(Icons.search,
              color: Colors.white, size: 40), //TODO: keresési mező
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              //TODO: a dizájnok legyenek ilyen kártyás formáuak
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryTitle('Általános'),
                _buildSettingItem(Icons.language, 'Nyelv', 'Magyar'),
                _buildSettingItem(Icons.notifications, 'Értesítések', 'Be'),
                _buildDivider(),
                // _buildCategoryTitle('Fiók'),
                // _buildSettingItem(Icons.lock, 'Jelszó módosítása', ''),
                // _buildSettingItem(Icons.person, 'Fiók adatok', ''),
                // _buildDivider(),
                // _buildCategoryTitle('Téma'),
                // _buildSettingItem(Icons.dark_mode, 'Sötét mód', 'Be'),
                // _buildSettingItem(Icons.palette, 'Színek testreszabása', ''),
                // _buildDivider(),
                // _buildCategoryTitle('Egyéb'),
                // _buildSettingItem(Icons.info, 'Verzió', '1.0.0'),
                // _buildSettingItem(Icons.help, 'Súgó és támogatás', ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: TextStyle(color: Colors.grey[400]))
          : null,
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.5);
  }
}
