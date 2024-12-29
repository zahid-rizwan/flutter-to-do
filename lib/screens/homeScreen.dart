import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app_1_0/data/local/db_helper.dart';
import 'package:todo_app_1_0/screens/login_screen.dart';
import 'package:todo_app_1_0/utils/constans.dart';

class HomeScreen extends StatefulWidget {
  Map<String,dynamic>? user;
  HomeScreen({required this.user});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbRef;
  final List<Map<String, String>> arrData = [
    {'name': 'Java', 'mobno': '789456123', 'unread': '2', 'date': '2024-12-25'},
    {'name': 'Flutter', 'mobno': '123456789', 'unread': '5', 'date': '2024-12-26'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
    {'name': 'Dart', 'mobno': '987654321', 'unread': '3', 'date': '2024-12-27'},
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController controller = TextEditingController();
  String? completionDate;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  List<Map<String, dynamic>> allTask = [];
  Map<String,dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=widget.user;
    dbRef=DBHelper.getInstance;
    fetchTasks();


  }
  Future<void> fetchTasks()  async {
     await getTodo();
     await getAllTask();
      setState(() {
      isLoading = false; // Mark loading as false once tasks are fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildSearchField(),
          Align(
            alignment: Alignment.centerLeft, // Ensures "Your Task" aligns to the left
            child: _buildSectionTitle("Your Task"),
          ),
          _buildTaskFilters(),
          SizedBox(height: 22),
          Expanded(child: _buildTaskList()),
          _buildBottomNavigationBar(),
        ],
      ),
      drawer:Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
                child: Text("Header")
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (allNotes.isNotEmpty) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Image.asset('assets/images/logo.png'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black)),
              Text(user?[DBHelper.COLUMN_USER_USER_NAME], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          // trailing: Builder(builder: (context){
          //   return IconButton(onPressed: (){
          //     Scaffold.of(context).openDrawer();
          //   }, icon: Icon(null));
          // }),
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Loading..."),
      );
    }

  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Find your task here",
          filled: true,
          fillColor: Color(0xfff6f6f6),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFD4D4D4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFFD4D4D4)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjusted padding
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTaskFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton("In Progress", Colors.white, Colors.blue),
          _buildFilterButton("To Do", Colors.black, Colors.grey[300]!),
          _buildFilterButton("Completed", Colors.black, Colors.grey[300]!),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, Color textColor, Color bgColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: () {},
      child: Text(title, style: TextStyle(color: textColor)),
    );
  }

  // Widget _buildTaskList() {
  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),333
  //     itemCount: arrData.length,
  //     itemBuilder: (context, index) {
  //       final task = arrData[index];
  //       return _buildTaskCard(task);
  //     },
  //   );
  // }
  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allTask.length,
      itemBuilder: (context, index) {
        final task = allTask[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            );
          },
          child: _buildTaskCard(task),
        );
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(task[DBHelper.COLUMN_TODO_TASK_NAME]!,task[DBHelper.COLUMN_TASK_TASK_ID]),
            SizedBox(height: 8),
            _buildTaskDescription(task[DBHelper.COLUMN_TODO_TASK_DESCRIPTION]!),
            SizedBox(height: 16),
            _buildTaskFooter(task[DBHelper.COLUMN_TODO_TASK_COMPLETION_DATE]!),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskHeader(String title,int taskId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        PopupMenuButton<String>(
          onSelected: (result)async {
            if (result == 'edit') {
              print('Edit tapped');
            } else if (result == 'delete') {

                bool check = await dbRef!.deleteTask(taskId: taskId);
                if(check){
                  getAllTask();
                  print("success");
                  Fluttertoast.showToast(
                    msg: "Deleted successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.grey,
                    textColor: Colors.red,
                    fontSize: 16.0,
                  );

              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: _buildPopupMenuItem(Icons.edit, 'Edit', Colors.blue)),
            PopupMenuItem(value: 'delete', child: _buildPopupMenuItem(Icons.delete, 'Delete', Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildPopupMenuItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildTaskDescription(String name) {
    return Text(
      "This is a detailed description for $name.",
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildTaskFooter(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_month,size: 15,),
            Text(": ${date.split('T')[0]}", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[500])),

          ],
        ),
        Row(
          children: [
            _buildBadge("Pending", Colors.orange),
            SizedBox(width: 8),
            _buildBadge("High", Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(user: user),
                    ),
                  );
                },
                child: Icon(Icons.home)),
            GestureDetector(
              onTap: (){
                showModalBottomSheet(isScrollControlled:true,context: context, builder: (context){
                  return SingleChildScrollView(
                    child: Padding(padding: EdgeInsets.only(
                      left: 11,
                      right: 11,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 11,
                      top: 11
                    ),
                    child: Column(
                      mainAxisSize:MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(textAlign: TextAlign.center,"Add Task",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        SizedBox(
                          height: 21,
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "Enter title here",
                            label: Text("Title *"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11)
                            )
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        TextField(
                          controller: descController,
                          decoration: InputDecoration(
                              hintText: "Enter description here",
                              label: Text("Description *"),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)
                              )
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Completion Date',
                            hintText: 'Tap to select a date',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11)
                            ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)
                              ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () =>_selectDate(context), // Open date picker on tap
                            ),
                          ),
                          readOnly: true, // Makes the TextField read-only so users cannot type in it
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(onPressed: ()async{
                                if(titleController.text.isNotEmpty && descController.text.isNotEmpty && completionDate.toString().isNotEmpty){
                                  bool check =await dbRef!.addTask(userId: user?[DBHelper.COLUMN_USER_USER_ID], taskName: titleController.text, taskDescription: descController.text, taskStatus: "pending",completionDate: completionDate);

                                  if(check){
                                    print("success");

                                  }
                                  getAllTask();
                                  Navigator.pop(context);
                                  setState(() {

                                  });


                                }
                                else{

                                }

                              }, child: Text("Add")),
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                            ),

                          ],
                        )
                      ],

                    ),),
                  );
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryButtonColor,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Icon(Icons.add, size: 35,color: Colors.white,),
              ),
            ),
            Icon(FontAwesomeIcons.solidUser),
            GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }

  Future<void> getTodo() async{
    dbRef?.logDatabaseSchema();
    allNotes = await dbRef!.getAllUser();
    setState(() {

    });

  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date as initial date
      firstDate: DateTime(2000),   // First available date
      lastDate: DateTime(2101),    // Last available date
    );

    if (pickedDate != null) {
      completionDate=pickedDate.toIso8601String();
      // If a date is picked, update the text field with the selected date
      setState(() {
        controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  Future<void> getAllTask() async{
    final task =await dbRef!.fetchTasksByUserId(user?[DBHelper.COLUMN_USER_USER_ID]);
    print(allTask);
    if(task!=null){
      setState(() {
        allTask = task;
      });
    }
    print("all task");
    print(user);
  }
}
class TaskDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task[DBHelper.COLUMN_TODO_TASK_NAME]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Name: ${task[DBHelper.COLUMN_TODO_TASK_NAME]}"),
            Text("Description: ${task[DBHelper.COLUMN_TODO_TASK_DESCRIPTION]}"),
            Text("Date: ${task[DBHelper.COLUMN_TODO_TASK_COMPLETION_DATE].toString().split("T")[0]}"),
          ],
        ),
      ),
    );
  }
}
