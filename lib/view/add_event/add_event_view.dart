import 'package:aral_mezunlar_mobile/controller/firebase_firestore_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

final TextEditingController _controllerTitle = TextEditingController();
final TextEditingController _controllerMessage = TextEditingController();
final TextEditingController _controllerMapsUrl = TextEditingController();
final TextEditingController _controllerShareMessage = TextEditingController();
String selectedOption = 'Toplanti'; // Başlangıçta seçili olan seçenek
DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

class _AddEventViewState extends State<AddEventView> {

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2033),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDate = combinedDateTime;
          selectedTime = pickedTime;
          print("date and time $selectedDate");
        });
      }
    }
  }

  @override
  void dispose() {
    // Controller'ları temizle
    _controllerTitle.clear();
    _controllerMessage.clear();
    _controllerMapsUrl.clear();
    _controllerShareMessage.clear();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      title: const Text('Yeni Gönderi Oluştur'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(
              controller: _controllerTitle,
              decoration: const InputDecoration(hintText: 'Etkinlik Başlığı'),
            ),
            SizedBox(height: 5.h,),
            TextField(
              controller: _controllerMessage,
              decoration: const InputDecoration(hintText: 'Etkinlik Mesajı'),
            ),
            SizedBox(height: 5.h,),
            TextField(
              controller: _controllerMapsUrl,
              decoration: const InputDecoration(hintText: 'Haritalar Linki'),
            ),
            SizedBox(height: 5.h,),
            TextField(
              controller: _controllerShareMessage,
              decoration: const InputDecoration(hintText: 'Whatsapp Paylaş Mesajı'),
            ),
            SizedBox(height: 5.h,),
            TextButton(onPressed: (){ _selectDateAndTime(context); }, child: const Text("Etkinlik Tarihini Seçin")),
            SizedBox(height: 5.h,),
            Row(
              children: [
                const Text("Etkinlik Fotoğrafı"),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: <String>['Toplanti', 'Ziyaret', 'Bulusma', 'Gezi']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialog kapatılır
          },
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            print("bu $selectedDate");
            FirebaseFirestoreController.firestoreAddEvent(_controllerTitle.text, _controllerMessage.text, _controllerMapsUrl.text, _controllerShareMessage.text, selectedOption, selectedDate,);
            _controllerTitle.clear();
            _controllerMessage.clear();
            _controllerMapsUrl.clear();
            _controllerShareMessage.clear();
            Navigator.of(context).pop(); // Dialog kapatılır
          },
          child: const Text('Gönder'),
        ),
      ],
    );
  }
}
