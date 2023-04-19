// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:time_managing/controllers/task_controller.dart';
import 'package:time_managing/models/task_model.dart';
import 'package:time_managing/services/notification_service.dart';
import 'package:time_managing/widgets/button_widget.dart';
import 'package:time_managing/widgets/input_filed_widget.dart';
import 'package:get/get.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _remindController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startDateTime ;
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  TimeOfDay? _endDateTime ;
  String _endTime = 'pick end time';
  int _selectedRemind = 5;
  String _selectedRepeat = 'None';
  List<int> remindList = [5, 10, 15, 20];
  List<String> repeatList = ['None', 'Daily','Weekly'];
  int _selectedColor = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _remindController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.red,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InputFiledWidget(
                    controller: _titleController,
                    title: 'Title',
                    hint: 'Enter title here',
                    enabled: true,
                  ),
                  InputFiledWidget(
                    controller: _noteController,
                    title: 'Note',
                    hint: 'Enter note here',
                    enabled: true,
                  ),
                  InputFiledWidget(
                    controller: _dateController,
                    title: 'Date',
                    hint: DateFormat.yMd().format(_selectedDate),
                    readOnly: true,
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () {
                        _pickDate();
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputFiledWidget(
                          controller: _startTimeController,
                          title: 'Start Time',
                          hint: _startTime,
                          readOnly: true,
                          suffixIcon: IconButton(
                            color: Colors.grey,
                            icon: const Icon(Icons.watch_later_outlined),
                            onPressed: () {
                              _pickTime(isStartTime: true);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: InputFiledWidget(
                          controller: _endTimeController,
                          title: 'End Time',
                          hint: _endTime,
                          readOnly: true,
                          suffixIcon: IconButton(
                            color: Colors.grey,
                            icon: const Icon(Icons.watch_later_outlined),
                            onPressed: () {
                              _pickTime(isStartTime: false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputFiledWidget(
                    controller: _remindController,
                    title: 'Remind',
                    hint: '$_selectedRemind minutes early',
                    enabled: true,
                    readOnly: true,
                    suffixIcon: DropdownButton(
                      items: remindList.map<DropdownMenuItem<String>>((remind) {
                        return DropdownMenuItem<String>(
                          value: remind.toString(),
                          child: Text(remind.toString()),
                        );
                      }).toList(),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRemind = int.parse(value);
                            _remindController.text =
                                '$_selectedRemind minutes early';
                          });
                        }
                      },
                    ),
                  ),
                  InputFiledWidget(
                    controller: _repeatController,
                    title: 'Repeat',
                    hint: _selectedRepeat,
                    enabled: true,
                    readOnly: true,
                    suffixIcon: DropdownButton(
                      items: repeatList.map<DropdownMenuItem<String>>((repeat) {
                        return DropdownMenuItem<String>(
                          value: repeat.toString(),
                          child: Text(repeat.toString()),
                        );
                      }).toList(),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRepeat = value;
                            _repeatController.text = _selectedRepeat;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Color',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            children: List<Widget>.generate(
                                3,
                                (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = index;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 7.0),
                                        child: CircleAvatar(
                                          radius: 14.0,
                                          backgroundColor: index == 0
                                              ? Colors.red
                                              : index == 1
                                                  ? Colors.blue[700]
                                                  : Colors.yellow[700],
                                          child: _selectedColor == index
                                              ? const Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    )),
                          )
                        ],
                      ),
                      ButtonWidget(
                        height: 60,
                        width: 100,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _addTaskToDb();

                            int month = _selectedDate.month;
                            int day = _selectedDate.day;
                            int year = _selectedDate.year;
                            int hour = _startDateTime?.hour??0;
                            int minute = _startDateTime?.minute??0;

                            notificationService.showScheduleNotification(
                              year: year,
                              month: month,
                              day: day,
                              hour: hour,
                              minutes: minute,
                              remind: _selectedRemind,
                              title: _titleController.text,
                              body: _noteController.text,
                              dateTimeComponents:
                                  _repeatController.text == "Daily"
                                      ? DateTimeComponents.dateAndTime
                                      : null,
                            );

                            Get.back();
                          } else {
                            Get.snackbar("warning", 'Form is not valid');
                          }
                        },
                        text: 'Create',
                        color: Colors.red,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addTaskToDb() async {
    await _taskController.addTask(Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: _dateController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _repeatController.text,
    ));
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2032),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMd().format(_selectedDate);
      });
    }
  }

  _pickTime({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
    print("${pickedTime?.hour}");

    String? formattedTime = pickedTime?.format(context);
    print(formattedTime);

    if (pickedTime == null) {
      print('Time Picker canceled');
    } else if (isStartTime) {
      setState(() {
        _startDateTime = pickedTime;
        _startTime = formattedTime ?? '';
        _startTimeController.text = _startTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endDateTime = pickedTime;
        _endTime = formattedTime ?? '';
        _endTimeController.text = _endTime;
      });
    }
  }
}
