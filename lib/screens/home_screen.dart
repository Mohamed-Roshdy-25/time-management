import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:time_managing/controllers/task_controller.dart';
import 'package:time_managing/models/task_model.dart';
import 'package:time_managing/screens/add_task_screen.dart';
import 'package:time_managing/services/notification_service.dart';
import 'package:time_managing/widgets/button_widget.dart';
import 'package:time_managing/widgets/drawer_widget.dart';
import 'package:get/get.dart';
import 'package:time_managing/widgets/tasks_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: _body(size),
    );
  }

  _body(size) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          _addTaskBar(),
          const SizedBox(
            height: 25,
          ),
          _dateBar(),
          const SizedBox(
            height: 25,
          ),
          _tasksView(size),
        ],
      ),
    );
  }

  _tasksView(Size size) {
    return Expanded(child: Obx(() {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _taskController.taskList.length,
        itemBuilder: (context, index) {
          Task task = _taskController.taskList[index];

          print(task.date);
          // print(task.toJson());
          if (task.repeat == 'Daily') {

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task, size);
                    },
                    child: TasksListWidget(task),
                  ),
                ),
              ),
            );
          }
          if (task.date == DateFormat.yMd().format(_selectedDate)) {

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task, size);
                    },
                    child: TasksListWidget(task),
                  ),
                ),
              ),
            );
          }
          if (task.repeat == 'Weekly'){

            for(int i=1;i>0;i++){
              int day = DateFormat.yMd().parse(task.date??'').day;
              print(day);
              if(day == _selectedDate.day) {
                day=day+7;
                print(day);
                return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task, size);
                      },
                      child: TasksListWidget(task),
                    ),
                  ),
                ),
              );
              }else{return Container();}

            }
            return Container();
          }
          else {
            return Container();
          }
        },
      );
    }));
  }

  _showBottomSheet(context, Task task, Size size) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
      height: task.isCompleted == 1 ? size.height * 0.24 : size.height * 0.32,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            if (task.isCompleted == 0)
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ButtonWidget(
                    textColor: Colors.white,
                    height: 45,
                    width: 350,
                    color: Colors.blue,
                    onTap: () async {
                      await _taskController.markTaskCompleted(task.id);
                      Get.back();
                    },
                    text: 'Task Completed',
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              textColor: Colors.white,
              height: 45,
              width: 350,
              color: Colors.red,
              onTap: () async {
                _taskController.deleteTask(task);
                Get.back();
              },
              text: 'Delete Task',
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              height: 45,
              width: 350,
              color: Colors.white,
              onTap: () {
                Get.back();
              },
              text: 'Close',
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    ));
  }

  _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              height: 10,
            ),
            Text(DateFormat.yMMMMd().format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        ButtonWidget(
            textColor: Colors.white,
            height: 60,
            width: 100,
            color: Colors.red,
            onTap: () {
              Get.to(const AddTaskScreen());
            },
            text: '+  Add Task'),
      ],
    );
  }

  _dateBar() {
    return DatePicker(
      DateTime.now(),
      height: 100,
      width: 70,
      initialSelectedDate: DateTime.now(),
      dateTextStyle: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      monthTextStyle: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      dayTextStyle: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      selectedTextColor: Colors.white,
      selectionColor: Colors.red,
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate;
        });
        if (kDebugMode) {
          print(DateFormat.yMMMMd().format(_selectedDate));
        }
      },
    );
  }
}
