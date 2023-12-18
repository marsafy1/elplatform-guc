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
import '../components/categories/category_icon.dart';
import '../pages/home_page.dart';
import '../pages/confessions_page.dart';
import '../pages/questions_page.dart';
import '../pages/lost_and_founds_page.dart';
import '../pages/notifications_page.dart';
import '../managers/categories_manager.dart';

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
  var categoriesMap = CategoryManager().categoriesMap;

  @override
  void initState() {
    super.initState();
    categoriesChoices = categoriesMap.entries.map((entry) {
      return Category(
        name: entry.value.name, // Use the name from the CategoryItem in the map
        icon: CategoryIcon(
            icon: entry.value.icon), // Use the icon from the CategoryItem
        addCategory: addCategory,
        removeCategory: removeCategory,
      );
    }).toList();

    setState(() {
      categoriesChoices[0].selected = true;
    });
  }

  var selectedTabIndex = 0;
  bool anon = false;
  void switchPage(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void addCategory(Category c, bool asFilter) {
    setState(() {
      // Deselect all categories
      categoriesChoices.forEach((element) {
        element.selected = false;
      });

      // Select the chosen category
      c.selected = true;
      selectedCategoriesChoices = [c];
    });

    categoriesChoices.forEach((element) {
      print(element.name + " " + element.selected.toString());
    });
  }

  void removeCategory(Category c, bool asFilter) {
    setState(() {
      print("remove category");

      selectedCategoriesChoices.remove(c);
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
    addCategory(categoriesChoices[0], false);
    String collection = indexToCollection[selectedTabIndex] ?? "feed";
    String action = collectionToAction[collection] ?? "post";
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    String userId = userAuth.user!.id;
    bool localAnon = anon; // Local variable for anon state in the bottom sheet

    bool inConfessions = indexToCollection[selectedTabIndex] == "confessions";
    bool inQuestions = indexToCollection[selectedTabIndex] == "questions";

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
                            if (inQuestions)
                              Categories(
                                  key: UniqueKey(),
                                  categories: categoriesChoices,
                                  updateSheet: () => setModalState(() {
                                        localAnon = localAnon;
                                      }),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                  backgroundColor: !localAnon
                                      ? Theme.of(context).primaryColor
                                      : Colors.amberAccent[700],
                                  minimumSize: const Size(double.infinity, 36),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(action.split(" ")[0],
                                      style: localAnon
                                          ? const TextStyle(color: Colors.white)
                                          : const TextStyle()),
                                  if (localAnon)
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  if (localAnon)
                                    const FaIcon(FontAwesomeIcons.ghost,
                                        size: 20, color: Colors.white),
                                ],
                              ),
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
                                    resolved: false,
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
        backgroundColor: Colors.transparent, // Make FAB background transparent
        elevation: 0, // Remove elevation
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                // Add more colors if needed
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            constraints: const BoxConstraints.expand(
              height: 56.0, // Standard FAB height
              width: 56.0, // Standard FAB width
            ),
            alignment: Alignment.center, // Align the icon inside the container
            child: const FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
          ),
        ),
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
