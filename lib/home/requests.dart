import 'package:fire/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../manager/RequestProvider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late RequestProvider _requestProvider;
  Map<String, bool> _favoriteStates = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _requestProvider = Provider.of<RequestProvider>(context, listen: false);
    _fetchRequestsIfNeeded();
  }

  void _fetchRequestsIfNeeded() {
    if (_requestProvider.requests.isEmpty && !_requestProvider.isLoading) {
      _requestProvider.fetchRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: Consumer<RequestProvider>(
        builder: (context, requestProvider, child) {
          return requestProvider.isLoading
              ? Center(
                  child: SpinKitSpinningLines(
                    size: 80.0,
                    itemCount: 5,
                    color: const Color(0xFFE94057),
                  ),
                )
              : requestProvider.requests.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7, // Adjust as needed
                      ),
                      itemCount: requestProvider.requests.length,
                      itemBuilder: (context, index) {
                        final person = requestProvider.requests[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    person.profileImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  person.firstName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(15)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          String userId = user!.uid;
                                          // Handle reject action
                                          print(
                                              "rejected: ${person.firstName}");
                                          // Remove the card from the list
                                          setState(() {
                                            requestProvider.requests
                                                .removeWhere((p) =>
                                                    p.user_id ==
                                                    person.user_id);
                                          });

                                          //deleting niggaz request
                                          firebaseService.deleteFromRequest(
                                              a_user: userId,
                                              r_user: person.user_id);
                                        },
                                        color: Colors.white,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: () async {
                                          print(
                                              "accepted: ${person.firstName}");
                                          setState(() {
                                            _favoriteStates[person.user_id] ??=
                                                false;
                                            _favoriteStates[person.user_id] =
                                                !_favoriteStates[
                                                    person.user_id]!;
                                          });
                                          User? user = _auth.currentUser;
                                          String userId = user!.uid;
                                          bool isAdded =
                                              await firebaseService.addFriend(
                                                  c_user: userId,
                                                  f_user: person.user_id);
                                          if (isAdded) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'request, accepted.',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            // Remove the card from the list
                                            setState(() {
                                              requestProvider.requests
                                                  .removeWhere((p) =>
                                                      p.user_id ==
                                                      person.user_id);
                                            });

                                            //deleting niggaz request
                                            firebaseService.deleteFromRequest(
                                                a_user: userId,
                                                r_user: person.user_id);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Unable to add friend'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        color:
                                            _favoriteStates[person.user_id] ==
                                                    true
                                                ? Colors.red
                                                : Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/urban-dog.gif'),
                          Text(
                            'No requests found',
                            style: GoogleFonts.lato(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
