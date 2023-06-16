import 'package:connect2bahmni/screens/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentPage = 0;
  PageController? pageController;

  final List<Widget> _pages = [
    BasicDetailsPage(),
    IdentifiersPage(),
    AddressPage(),
  ];

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _currentPage++;
      FocusScope.of(context).unfocus();
    }
  }

  void _previousPage() {
    _currentPage--;
    FocusScope.of(context).unfocus();
  }


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _currentPage);

    pageController!.addListener(() {
      _currentPage = pageController!.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
        ),
        body: PageView(
          controller: pageController,
          children: _pages,

          // children: [
          //   BasicDetailsPage(),
          //   IdentifiersPage(),
          //   AddressPage(),
          // ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Perform registration logic using model.patient
          },
          child: Icon(Icons.done),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageController!.hasClients ? pageController!.page!.round() : 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Basic Details'),
            BottomNavigationBarItem(icon: Icon(Icons.perm_identity),label: 'Identifiers'),
            BottomNavigationBarItem(icon: Icon(Icons.location_city_sharp),label: 'Address'),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (v) {
            if (pageController!.hasClients) {
              pageController!.animateToPage(
                v,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
            // setState(() {
            //   _currentPage = v;
            // });
          },
        ),
      ),
    );
  }

  //@override
  Widget build1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(child: _pages[_currentPage]),
            ButtonBar(
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: Text('Previous'),
                  ),
                if (_currentPage < _pages.length - 1)
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text('Next'),
                  ),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Perform registration logic here using _patient object
                      }
                    },
                    child: Text('Register'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BasicDetailsPage extends StatefulWidget {
  const BasicDetailsPage({super.key});

  @override
  State<BasicDetailsPage> createState() => _BasicDetailsPageState();
}

class _BasicDetailsPageState extends State<BasicDetailsPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(labelText: 'First Name'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(labelText: 'Last Name'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _genderController,
          decoration: InputDecoration(labelText: 'Gender'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your gender';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _dateOfBirthController,
          decoration: InputDecoration(labelText: 'Date of Birth'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your date of birth';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class IdentifiersPage extends StatefulWidget {
  const IdentifiersPage({super.key});

  @override
  State<IdentifiersPage> createState() => _IdentifiersPageState();
}

class _IdentifiersPageState extends State<IdentifiersPage> {
  final _identifiers = <ProfileIdentifier>[];
  final _typeController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _addIdentifier() {
    setState(() {
      final identifier = ProfileIdentifier(
        name: _typeController.text,
        value: _valueController.text,
      );
      _identifiers.add(identifier);
      _typeController.clear();
      _valueController.clear();
    });
  }

  void _removeIdentifier(int index) {
    setState(() {
      _identifiers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _identifiers.length,
          itemBuilder: (context, index) {
            final identifier = _identifiers[index];
            return ListTile(
              title: Text('Type: ${identifier.name}'),
              subtitle: Text('Value: ${identifier.value}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeIdentifier(index),
              ),
            );
          },
        ),
        TextFormField(
          controller: _typeController,
          decoration: InputDecoration(labelText: 'Identifier Type'),
        ),
        TextFormField(
          controller: _valueController,
          decoration: InputDecoration(labelText: 'Identifier Value'),
        ),
        ElevatedButton(
          onPressed: _addIdentifier,
          child: Text('Add Identifier'),
        ),
      ],
    );
  }
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _subdistrictController = TextEditingController();
  final _villageController = TextEditingController();

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _subdistrictController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _stateController,
          decoration: InputDecoration(labelText: 'State'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your state';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _districtController,
          decoration: InputDecoration(labelText: 'District'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your district';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _subdistrictController,
          decoration: InputDecoration(labelText: 'Subdistrict'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your subdistrict';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _villageController,
          decoration: InputDecoration(labelText: 'Village'),
        ),
      ],
    );
  }
}