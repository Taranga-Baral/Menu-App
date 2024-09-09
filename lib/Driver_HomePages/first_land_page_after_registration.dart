
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:card_loading/card_loading.dart';

// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});

//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }

// class _DriverHomePageState extends State<DriverHomePage> {
//   String _selectedSortOption = 'Timestamp Newest First';
//   final int _itemsPerPage = 10;
//   DocumentSnapshot? _lastDocument;
//   bool _hasMore = true;
//   List<Map<String, dynamic>> _tripDataList = [];
//   bool _isLoading = false;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchTrips();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//         _fetchTrips();
//       }
//     });
//   }

//   Future<void> _fetchTrips() async {
//     if (_isLoading || !_hasMore) return;
//     setState(() {
//       _isLoading = true;
//     });

//     Query query = FirebaseFirestore.instance.collection('trips')
//       .orderBy(_getSortField(), descending: _getSortDescending())
//       .limit(_itemsPerPage);

//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }

//     try {
//       QuerySnapshot querySnapshot = await query.get();
//       if (querySnapshot.docs.isEmpty) {
//         setState(() {
//           _hasMore = false;
//         });
//       } else {
//         _lastDocument = querySnapshot.docs.last;
//         var newTrips = querySnapshot.docs.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           // Convert distance and fare from string to number
//           if (data['distance'] is String) {
//             data['distance'] = double.tryParse(data['distance'] as String) ?? 0.0;
//           }
//           if (data['fare'] is String) {
//             data['fare'] = double.tryParse(data['fare'] as String) ?? 0.0;
//           }
//           return data;
//         }).toList();
//         // Update state after fetching data
//         if (mounted) {
//           setState(() {
//             _tripDataList.addAll(newTrips);
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching trips: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   String _getSortField() {
//     switch (_selectedSortOption) {
//       case 'Timestamp Newest First':
//         return 'timestamp';
//       case 'Price Expensive First':
//       case 'Price Cheap First':
//         return 'fare';
//       case 'Distance Largest First':
//       case 'Distance Smallest First':
//         return 'distance';
//       default:
//         return 'timestamp';
//     }
//   }

//   bool _getSortDescending() {
//     switch (_selectedSortOption) {
//       case 'Timestamp Newest First':
//         return true;
//       case 'Price Expensive First':
//         return true;
//       case 'Price Cheap First':
//         return false;
//       case 'Distance Largest First':
//         return true;
//       case 'Distance Smallest First':
//         return false;
//       default:
//         return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trips'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               setState(() {
//                 _selectedSortOption = value;
//                 _tripDataList.clear();
//                 _lastDocument = null;
//                 _hasMore = true;
//                 _fetchTrips();
//               });
//             },
//             itemBuilder: (BuildContext context) {
//               return [
//                 'Timestamp Newest First',
//                 'Price Expensive First',
//                 'Price Cheap First',
//                 'Distance Largest First',
//                 'Distance Smallest First'
//               ].map((String choice) {
//                 return PopupMenuItem<String>(
//                   value: choice,
//                   child: Text(choice),
//                 );
//               }).toList();
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _tripDataList.length + (_hasMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= _tripDataList.length) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: CardLoading(
//                 height: 150,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             );
//           }
//           var tripData = _tripDataList[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             child: Card(
//               color: Colors.white.withOpacity(0.95), // Slightly transparent
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15), // Curved edges
//               ),
//               elevation: 5, // Shadow for a better look
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(16),
//                 title: Text(
//                   tripData['username'] ?? 'No Username',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold, // Bold Title
//                     fontSize: 18,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Pickup: ${tripData['pickupLocation'] ?? 'No pickup location'}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Delivery: ${tripData['deliveryLocation'] ?? 'No delivery location'}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Distance: ${tripData['distance'] ?? 'No distance'} km',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Fare: \NPR ${tripData['fare'] ?? 'No fare'}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Phone: ${tripData['phone'] ?? 'No phone'}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     Text(
//                       'Timestamp: ${tripData['timestamp']?.toDate() ?? 'No timestamp'}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 isThreeLine: true,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_loading/card_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String _selectedSortOption = 'Timestamp Newest First';
  final int _itemsPerPage = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  List<Map<String, dynamic>> _tripDataList = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTrips();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchTrips();
      }
    });
  }

  Future<void> _fetchTrips() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance.collection('trips')
      .orderBy(_getSortField(), descending: _getSortDescending())
      .limit(_itemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        _lastDocument = querySnapshot.docs.last;
        var newTrips = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          // Ensure distance and fare are treated as numbers
          if (data['distance'] is String) {
            data['distance'] = double.tryParse(data['distance'] as String) ?? 0.0;
          }
          if (data['fare'] is String) {
            data['fare'] = double.tryParse(data['fare'] as String) ?? 0.0;
          }
          return data;
        }).toList();
        // Update state after fetching data
        if (mounted) {
          setState(() {
            _tripDataList.addAll(newTrips);
          });
        }
      }
    } catch (e) {
      print("Error fetching trips: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshTrips() async {
    setState(() {
      _tripDataList.clear();
      _lastDocument = null;
      _hasMore = true;
    });
    await _fetchTrips();
  }

  String _getSortField() {
    switch (_selectedSortOption) {
      case 'Timestamp Newest First':
        return 'timestamp';
      case 'Price Expensive First':
      case 'Price Cheap First':
        return 'fare';
      case 'Distance Largest First':
      case 'Distance Smallest First':
        return 'distance';
      default:
        return 'timestamp';
    }
  }

  bool _getSortDescending() {
    switch (_selectedSortOption) {
      case 'Timestamp Newest First':
        return true;
      case 'Price Expensive First':
        return true;
      case 'Price Cheap First':
        return false;
      case 'Distance Largest First':
        return true;
      case 'Distance Smallest First':
        return false;
      default:
        return true;
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedSortOption = value;
                _tripDataList.clear();
                _lastDocument = null;
                _hasMore = true;
                _fetchTrips();
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                'Timestamp Newest First',
                'Price Expensive First',
                'Price Cheap First',
                'Distance Largest First',
                'Distance Smallest First'
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTrips,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _tripDataList.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _tripDataList.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CardLoading(
                  height: 150,
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            }
            var tripData = _tripDataList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Card(
                color: Colors.white.withOpacity(0.95), // Slightly transparent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Curved edges
                ),
                elevation: 5, // Shadow for a better look
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tripData['username'] ?? 'No Username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Bold Title
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {
                          final phoneNumber = tripData['phone'] ?? '';
                          if (phoneNumber.isNotEmpty) {
                            _launchPhone(phoneNumber);
                          }
                        },
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '𝗣𝗶𝗰𝗸𝘂𝗽: ${tripData['pickupLocation'] ?? 'No pickup location'}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '𝗗𝗲𝗹𝗶𝘃𝗲𝗿𝘆: ${tripData['deliveryLocation'] ?? 'No delivery location'}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '𝗗𝗶𝘀𝘁𝗮𝗻𝗰𝗲: ${tripData['distance']?.toStringAsFixed(2) ?? 'No distance'} km',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '𝗙𝗮𝗿𝗲: \NPR ${tripData['fare']?.toStringAsFixed(2) ?? 'No fare'}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '𝗣𝗵𝗼𝗻𝗲: ${tripData['phone'] ?? 'No phone'}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Timestamp: ${tripData['timestamp']?.toDate() ?? 'No timestamp'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
