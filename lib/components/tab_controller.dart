import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/components/app_bar_widget.dart';
import 'package:guc_swiss_knife/services/posts_service.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import '../models/category.dart';
import '../models/post.dart';
import 'tabs_controller/glassy_navbar.dart';
import 'drawer_widget.dart';
import './categories/categories.dart';
import '../components/form_components/inputs/textfield.dart';
import '../components/toast/toast.dart';
import '../pages/home_page.dart';
import '../pages/confessions_page.dart';
import '../pages/questions_page.dart';
import '../pages/lost_and_founds_page.dart';
import '../pages/notifications_page.dart';

class TabsControllerScreen extends StatefulWidget {
  const TabsControllerScreen({super.key});

  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  final PostsService _postsService = PostsService();
  final List<Widget> myPages = const [
    HomePage(),
    ConfessionsPage(),
    QuestionsPage(),
    LostAndFoundsPage(),
    NotificationsPage()
    // Add other page widgets here
  ];
  final Map<int, String> indexToCollection = {
    0: "feed",
    1: "confessions",
    2: "questions",
    3: "lost_and_founds",
    4: "notifications"
  };
  List<Category> categoriesChoices = [];
  List<Category> selectedCategoriesChoices = [];
  var selectedTabIndex = 0;
  bool anon = false;
  void switchPage(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void showBottomSheetForNewPost(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final Map<String, String> collectionToAction = {
      "feed": "Add Post",
      "confessions": "Add Confession",
      "questions": "Add Question",
      "lost_and_founds": "Look For",
    };

    String collection = indexToCollection[selectedTabIndex] ?? "feed";
    String action = collectionToAction[collection] ?? "post";
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    String userId = userAuth.user!.id;
    bool localAnon = anon; // Local variable for anon state in the bottom sheet

    bool inConfessions = indexToCollection[selectedTabIndex] == "confessions";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(bc).viewInsets.bottom,
                ),
                child: Wrap(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(action,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Categories(
                                key: UniqueKey(),
                                categories: categoriesChoices,
                                asFilter: false),
                            TextFieldInput(
                              inputPlaceholder: "Title",
                              controller: titleController,
                              minLines: 1,
                              maxLines: 2,
                            ),
                            TextFieldInput(
                              inputPlaceholder: "Add more details here...",
                              controller: descriptionController,
                              minLines: 10,
                              maxLines: 12,
                            ),
                            if (inConfessions)
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.ghost,
                                    color:
                                        localAnon ? Colors.yellow : Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Text("Post Anonymously"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Switch(
                                    value: localAnon,
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    onChanged: (bool value) {
                                      setModalState(() {
                                        localAnon = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  minimumSize: const Size(double.infinity, 36),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero))),
                              child: Text(action.split(" ")[0]),
                              onPressed: () {
                                String title = titleController.text.trim();
                                String description =
                                    descriptionController.text.trim();
                                String category =
                                    selectedCategoriesChoices.isNotEmpty
                                        ? selectedCategoriesChoices[0]
                                            .name
                                            .toLowerCase()
                                        : "all";

                                if (title.isEmpty) {
                                  Toast.show(
                                      context, "Please enter a title", "error");
                                  return;
                                }

                                if (description.isEmpty) {
                                  Toast.show(context,
                                      "Please enter a description", "error");
                                  return;
                                }

                                if (category.isEmpty) {
                                  Toast.show(context,
                                      "Please choose a category", "error");
                                  return;
                                }

                                DateTime dateTime = DateTime.now();
                                Post newQuestion = Post(
                                    title: title,
                                    userId: userId,
                                    anon: localAnon,
                                    category: category,
                                    description: description,
                                    photosUrls: [],
                                    dateCreated: dateTime);
                                _postsService.addPost(collection, newQuestion);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: myPages[selectedTabIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userAuth = Provider.of<AuthProvider>(context, listen: false);
          bool isPublisher = userAuth.user!.isPublisher;
          // Action to take when the FAB is tapped
          if (!isPublisher) {
            Toast.show(context, "You need to be a publisher", "warning");
          } else {
            showBottomSheetForNewPost(context);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ), // The '+' icon is typical for an "Add" action
      ),
      bottomNavigationBar: GlassMorphicBottomNavigationBar(
        selectedIndex: selectedTabIndex,
        onItemSelected: switchPage,
        listItems: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Confessions', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fileCircleQuestion),
            label: 'Q/A', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.suitcase),
            label: 'Lost & Founds', // Empty string for label
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidBell),
            label: 'Notifications', // Empty string for label
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
