import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'contacts_data.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'gallery_page.dart';
import 'detail_image.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HelloWorld(),
  ));
}

class HelloWorld extends StatefulWidget {
  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  var formKey = GlobalKey<FormState>();
  var namaControllers = TextEditingController();
  var nomorControllers = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final currentDate = DateTime.now();
  Color _currentColor = const Color(0xFFE7E0EC);
  List<String> selectedFilePaths = [];

  bool isDataSubmitted = false;

  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Contact'),
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Icon(
                Icons.phone_android,
                size: 40,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15.0),
            Text('Create New Contact'),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                  'A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made. '),
            ),
            Divider(thickness: 2.0, indent: 20.0, endIndent: 20.0),
            SizedBox(height: 20.0),
            nameField(),
            SizedBox(height: 20.0),
            phoneNumberField(),
            DatePicker(),
            SizedBox(height: 20.0),
            buildColorPicker(context),
            SizedBox(height: 20.0),
            filePickerButton(),
            SizedBox(height: 20.0),
            submitButton(),
            SizedBox(height: 20.0),
            submittedDataList(),
          ],
        ),
      ),
    );
  }

  Column DatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Date'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: TextButton(
                child: Text('Select'),
                onPressed: () async {
                  final selectData = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime(1990),
                    lastDate: DateTime(currentDate.year + 5),
                  );
                  setState(() {
                    if (selectData != null) {
                      _dueDate = selectData;
                    }
                  });
                },
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(DateFormat('dd-MM-yyyy').format(_dueDate)),
        ),
      ],
    );
  }

  nameField() {
    return Container(
      margin: EdgeInsets.only(right: 20.0, left: 20.0),
      child: TextFormField(
        controller: namaControllers,
        validator: (value) {
          final trimmedValue = value!.trim();
          final words = trimmedValue.split(' ');
          if (words.length < 2) {
            return 'Nama harus terdiri dari minimal 2 kata';
          }
          for (final word in words) {
            if (!word.isEmpty &&
                !word
                    .substring(0, 1)
                    .toUpperCase()
                    .contains(RegExp(r'[A-Z]'))) {
              return 'Setiap kata harus dimulai dengan huruf kapital.';
            }
          }
          if (trimmedValue.isEmpty) {
            return 'Nama tidak boleh kosong';
          }
          if (trimmedValue.contains(RegExp(r'[0-9!@#%^&*(),.?":{}|<>]'))) {
            return 'Nama tidak boleh mengandung angka atau karakter khusus';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Insert Your Name',
          fillColor: Color.fromARGB(100, 103, 80, 164),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.0),
              topRight: Radius.circular(6.0),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
    );
  }

  phoneNumberField() {
    return Container(
      margin: EdgeInsets.only(right: 20.0, left: 20.0),
      child: TextFormField(
        validator: (value) {
          final nomorTelepon = value!.trim();
          if (nomorTelepon.isEmpty) {
            return 'Nomor telepon harus diisi';
          }
          if (!nomorTelepon.startsWith('0')) {
            return 'Nomor telepon harus dimulai dengan angka 0.';
          }
          if (!RegExp(r'^0[0-9]{7,10}$').hasMatch(nomorTelepon)) {
            return 'Nomor telepon tidak valid. Harus dimulai dengan 0 dan terdiri dari 8 hingga 10 angka.';
          }
          return null;
        },
        controller: nomorControllers,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Nomor',
          hintText: '+62...',
          fillColor: Color.fromARGB(100, 103, 80, 164),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.0),
              topRight: Radius.circular(6.0),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color'),
        SizedBox(height: 10),
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor,
        ),
        SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                _currentColor,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Pick your color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _currentColor,
                        onColorChanged: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      )
                    ],
                  );
                },
              );
            },
            child: Text(
              'Pick Color',
              style: TextStyle(
                color: Color(0xFF49454F),
              ),
            ),
          ),
        )
      ],
    );
  }

  submitButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Color(0xFF6750A4),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final name = namaControllers.text;
    final phone = nomorControllers.text;
    final currentDate = DateTime.now();
    final currentColor = _currentColor;

    List<String> selectedFiles = [];
    if (selectedFilePaths.isNotEmpty) {
      selectedFiles.addAll(selectedFilePaths);
    }

    final contact = Contact(
      name,
      phone,
      currentDate,
      currentColor,
      selectedFilePaths,
    );
    contacts.add(contact);

    setState(() {
      isDataSubmitted = true;
    });

    namaControllers.clear();
    nomorControllers.clear();
  }

  Widget filePickerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _handleFilePick,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE7E0EC),
          ),
          child: Text(
            'Pick Files',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Future<List<String>> _handleFilePick() async {
    final result = await FilePicker.platform.pickFiles();
    final selectedFiles = <String>[];

    if (result != null) {
      final List<PlatformFile> files = result.files;
      for (final file in files) {
        final filePath = file.path;
        if (filePath != null) {
          selectedFilePaths.add(filePath);
        }
      }
    }

    return selectedFiles;
  }

  submittedDataList() {
    return Column(
      children: [
        Text(
          'List Contacts',
          style: TextStyle(
            color: Color(0xFF1C1B1F),
            fontFamily: 'roboto',
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 21),
        ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];

            return ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: contact.name,
                      style: TextStyle(
                        fontFamily: 'roboto',
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1C1B1F),
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextSpan(text: '\n'), // Add a newline separator
                    TextSpan(
                      text: contact.phone,
                      style: TextStyle(
                        fontFamily: 'roboto',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1C1B1F),
                        letterSpacing: 0.25,
                      ),
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(
                      text: DateFormat('dd-MM-yyyy').format(contact.date),
                      style: TextStyle(
                        fontFamily: 'roboto',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1C1B1F),
                        letterSpacing: 0.25,
                      ),
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(
                      text: 'Color: ',
                      style: TextStyle(
                        fontFamily: 'roboto',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1C1B1F),
                        letterSpacing: 0.25,
                      ),
                      children: [
                        WidgetSpan(
                          child: Container(
                            width: 20,
                            height: 20,
                            color: contact.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      editContact(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteContact(index);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void editContact(int index) {
    final contact = contacts[index];

    TextEditingController nameController =
        TextEditingController(text: contact.name);
    TextEditingController phoneController =
        TextEditingController(text: contact.phone);
    DateTime editedDate = contact.date;
    Color editedColor = contact.color;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date'),
                  TextButton(
                    onPressed: () async {
                      final selectDate = await showDatePicker(
                        context: context,
                        initialDate: editedDate,
                        firstDate: DateTime(1991),
                        lastDate: DateTime(currentDate.year + 5),
                      );

                      if (selectDate != null) {
                        setState(() {
                          editedDate = selectDate;
                        });
                      }
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
              Text('Color'),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                color: editedColor, // Display the current color
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      editedColor,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Pick your color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor:
                                  editedColor, // Pass the current color
                              onColorChanged: (color) {
                                setState(() {
                                  editedColor =
                                      color; // Update the edited color
                                });
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Pick Color',
                    style: TextStyle(
                      color: Color(0xFF49454F),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text;
                final newphone = phoneController.text;

                setState(() {
                  contacts[index] = Contact(
                    newName,
                    newphone,
                    editedDate,
                    editedColor,
                    selectedFilePaths,
                    // Update the color in the contact object
                  );
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Color(0xFF6750A4),
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GalleryPage()), // Navigate to the GalleryPage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Implement your navigation logic here
            },
          ),
        ],
      ),
    );
  }
}
