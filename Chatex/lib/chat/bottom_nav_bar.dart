import 'package:chatex/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:chatex/chat/people.dart';

class BottomNavbarForChat extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped; // Külső vezérléshez

  const BottomNavbarForChat({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
}

class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
            minWidth: 50,
            onPressed: () => widget.onItemTapped(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat,
                  color: widget.selectedIndex == 0
                      ? Colors.deepPurple[400]
                      : Colors.grey[400],
                ),
                Text(
                  'Chatek',
                  style: TextStyle(
                    color: widget.selectedIndex == 0
                        ? Colors.deepPurple[400]
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            minWidth: 50,
            onPressed: () => widget.onItemTapped(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: widget.selectedIndex == 1
                      ? Colors.deepPurple[400]
                      : Colors.grey[400],
                ),
                Text(
                  'Ismerősök',
                  style: TextStyle(
                    color: widget.selectedIndex == 1
                        ? Colors.deepPurple[400]
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:chatex/chat/chat.dart';
// import 'package:flutter/material.dart';
// import 'package:chatex/chat/people.dart';

// class BottomNavbarForChat extends StatefulWidget {
//   final int? selectedIndex;
//   const BottomNavbarForChat({super.key, this.selectedIndex});
// //TODO: EZZEL KEZDJEM HOLNAP: NEM TELJES MÉRET SIDEBAR, SELECTEDINDEX A SIDEBARON
//   @override
//   State<BottomNavbarForChat> createState() => _BottomNavbarForChatState();
// }

// class _BottomNavbarForChatState extends State<BottomNavbarForChat> {
//   late int _currentIndex = 0;

//   void onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//       // widget.selectedIndex = index;
//       // _currentIndex = widget.selectedIndex;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.selectedIndex ?? 0;
//     //onItemTapped(widget.selectedIndex);
//   }

//   // final List<Widget> pages = [
//   //   ChatUI(),
//   //   People(),
//   // ];

//   final PageStorageBucket bucket = PageStorageBucket();

//   @override
//   Widget build(BuildContext context) {
//     Widget currentScreen = _currentIndex == 0 ? ChatUI() : People();
//     return SafeArea(
//       child: Scaffold(
//         body: PageStorage(
//           bucket: bucket,
//           child: currentScreen,
//         ),
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[700],
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15),
//             ),
//           ),
//           child: BottomAppBar(
//             //TODO: külön widgetbe kéne tenni de nem engedi
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     MaterialButton(
//                       minWidth: 50,
//                       onPressed: () {
//                         setState(() {
//                           currentScreen = ChatUI();
//                           _currentIndex = 0;
//                         });
//                       },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.chat,
//                             color: _currentIndex == 0
//                                 ? Colors.deepPurple[400]
//                                 : Colors.grey[400],
//                           ),
//                           Text(
//                             'Chatek',
//                             style: TextStyle(
//                               color: _currentIndex == 0
//                                   ? Colors.deepPurple[400]
//                                   : Colors.grey[400],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     MaterialButton(
//                       minWidth: 50,
//                       onPressed: () {
//                         setState(() {
//                           currentScreen = People();
//                           _currentIndex = 1;
//                         });
//                       },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.person,
//                             color: _currentIndex == 1
//                                 ? Colors.deepPurple[400]
//                                 : Colors.grey[400],
//                           ),
//                           Text(
//                             'Ismerősök',
//                             style: TextStyle(
//                               color: _currentIndex == 1
//                                   ? Colors.deepPurple[400]
//                                   : Colors.grey[400],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
