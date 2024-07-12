import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import '../../model/Me.dart';

// ignore: must_be_immutable
class FilterBottomSheet extends StatefulWidget {
  final bool update;
  final Function(bool) onUpdated;
  final String selectedGender;
  final Function(String) onGenderSelected;
  final List<String> subCities = [
    "Arada, Addis Ababa",
    "Akaky Kaliti, Addis Ababa",
    "Bole, Addis Ababa",
    "Gullele, Addis Ababa",
    "Kirkos, Addis Ababa",
    "Kolfe Keranio, Addis Ababa",
    "Lideta, Addis Ababa",
    "Nifas Silk-Lafto, Addis Ababa",
    "Yeka, Addis Ababa",
  ];

  FilterBottomSheet({
    Key? key,
    required this.update,
    required this.onUpdated,
    required this.selectedGender,
    required this.onGenderSelected,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedSubCity;
  RangeValues _ageRange = RangeValues(20, 50);
  String _selectedGender = '';
  String adr = '';
  bool _isDataFetched = false;
  final FirebaseService _firebaseService = FirebaseService();

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    widget.onGenderSelected(gender);
  }

  Future<void> getUserData(BuildContext context) async {
    // ignore: unused_local_variable
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false).reFetch();
    if (true) {
      final me = UserDataManager().me!;
      final Map<String, dynamic> ageRange = me.ageRange;
      setState(() {
        _ageRange =
            RangeValues(ageRange['min'].toDouble(), ageRange['max'].toDouble());
        _selectedGender = me.preferencesGender;
        adr = me.address;
        _isDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    if (!_isDataFetched) {
      getUserData(context);
    }

    if (profileProvider.isLoading && !_isDataFetched) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (profileProvider.isError) {
      return Scaffold(
        body: Center(
          child: Text("Error fetching user data."),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 28, 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.isDarkMode
                      ? Color.fromARGB(86, 240, 55, 55)
                      : Color(0xffe8e6ea),
                ),
                color:
                    themeProvider.isDarkMode ? Colors.black : Color(0xffffffff),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Interested In:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _selectGender('Female'),
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider.isDarkMode
                                  ? Colors.white10
                                  : const Color.fromARGB(50, 158, 158, 158),
                            ),
                            color: _selectedGender == 'Female'
                                ? Color(0xffe94057)
                                : themeProvider.isDarkMode
                                    ? Colors.white12
                                    : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Girls',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _selectedGender == 'Female'
                                    ? Colors.white
                                    : themeProvider.isDarkMode
                                        ? Colors.white10
                                        : Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _selectGender('Male'),
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider.isDarkMode
                                  ? Colors.white10
                                  : const Color.fromARGB(50, 158, 158, 158),
                            ),
                            color: _selectedGender == 'Male'
                                ? Color(0xffe94057)
                                : themeProvider.isDarkMode
                                    ? Colors.white10
                                    : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Boys',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _selectedGender == 'Male'
                                    ? Colors.white
                                    : themeProvider.isDarkMode
                                        ? Colors.white10
                                        : Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 240,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(49, 11, 9, 10),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            adr,
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white24
                                  : Color.fromARGB(255, 26, 19, 20),
                              fontSize: 16,
                            ),
                          ),
                          value: _selectedSubCity,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white24
                                : Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSubCity = newValue;
                            });
                          },
                          items: widget.subCities.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Age',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '${_ageRange.start.round()} - ${_ageRange.end.round()}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Color(0xffe94057),
                      inactiveTrackColor: Color.fromARGB(29, 158, 158, 158),
                      thumbColor: Color(0xffe94057),
                      overlayColor: Color(0x29e94057),
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 100,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 24,
                      ),
                      trackHeight: 5,
                    ),
                    child: RangeSlider(
                      values: _ageRange,
                      min: 15,
                      max: 60,
                      divisions: 45,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _ageRange = values;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, left: 20.0, right: 20.0, bottom: 8.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedGender == '' ||
                                _selectedSubCity == '' ||
                                _selectedSubCity == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to update please adjust your preferences')),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('updating....')),
                            );
                            bool success =
                                await _firebaseService.updatePreferences(
                              _ageRange.start.round(),
                              _ageRange.end.round(),
                              _selectedGender,
                              _selectedSubCity ?? 'Not specified',
                            );
                            if (success) {
                              getUserData(context);
                              widget.onUpdated(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Saved')),
                              );
                              Navigator.pop(context);
                            } else {
                              widget.onUpdated(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to update preferences')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFE94057),
                            minimumSize: const Size(270, 50),
                            elevation: 8,
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
