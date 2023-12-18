import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/services/image_upload_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
import '../managers/lost_and_founds_manager.dart';

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
  List<File> photosFiles = [];
  var categoriesMapQs = CategoryManager().categoriesMap;
  var categoriesMapLs = LostAndFoundsManager().categoriesMap;

  @override
  void initState() {
    super.initState();
    categoriesChoices = categoriesMapQs.entries.map((entry) {
      return Category(
        name: entry.value.name,
        icon: CategoryIcon(icon: entry.value.icon),
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

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      photosFiles.add(File(pickedFile.path));
      return File(pickedFile.path);
    }
    return null;
  }

  void showBottomSheetForNewPost(BuildContext context) {
    bool inConfessions = indexToCollection[selectedTabIndex] == "confessions";
    bool inQuestions = indexToCollection[selectedTabIndex] == "questions";
    bool inFeed = indexToCollection[selectedTabIndex] == "feed";
    bool inLosts = indexToCollection[selectedTabIndex] == "lost_and_founds";

    if (inLosts) {
      setState(() {
        categoriesChoices = categoriesMapLs.entries.map((entry) {
          return Category(
            name: entry.value.name,
            icon: CategoryIcon(icon: entry.value.icon),
            addCategory: addCategory,
            removeCategory: removeCategory,
          );
        }).toList();
      });
    }
    if (inQuestions) {
      setState(() {
        categoriesChoices = categoriesMapQs.entries.map((entry) {
          return Category(
            name: entry.value.name,
            icon: CategoryIcon(icon: entry.value.icon),
            addCategory: addCategory,
            removeCategory: removeCategory,
          );
        }).toList();
      });
    }

    setState(() {
      categoriesChoices[0].selected = true;
    });

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

    bool postingImagesAllowed = inQuestions || inFeed || inLosts;

    bool loadingSubmission = false;

    setState(() {
      photosFiles = [];
    });
    List<File> localPhotosFiles = [];
    List<String> localPhotosUrls = [];

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
                            if (inQuestions || inLosts)
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
                            if (postingImagesAllowed)
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        File? image =
                                            await pickImage(); // or ImageSource.camera
                                        if (image != null) {
                                          setModalState(() {
                                            localPhotosFiles.add(image);
                                          });
                                        }
                                      },
                                      child: const Text('Pick Image'),
                                    ),
                                    const SizedBox(width: 10),
                                    // Display selected images
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            100, // Adjust the size as needed
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: localPhotosFiles.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.file(
                                                localPhotosFiles[index],
                                                width: 100, // Thumbnail width
                                                height: 100, // Thumbnail height
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                            if (!loadingSubmission)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: !localAnon
                                        ? Theme.of(context).primaryColor
                                        : Colors.amberAccent[700],
                                    minimumSize:
                                        const Size(double.infinity, 36),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(action.split(" ")[0],
                                        style: localAnon
                                            ? const TextStyle(
                                                color: Colors.white)
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
                                onPressed: () async {
                                  setModalState(() {
                                    loadingSubmission = true;
                                  });
                                  String title = titleController.text.trim();
                                  String description =
                                      descriptionController.text.trim();
                                  String category =
                                      selectedCategoriesChoices.isNotEmpty
                                          ? selectedCategoriesChoices[0]
                                              .name
                                              .toLowerCase()
                                          : "all";
                                  print("Categoryyyy");
                                  print(selectedCategoriesChoices);
                                  if (selectedCategoriesChoices.isNotEmpty) {
                                    print(selectedCategoriesChoices[0].name);
                                    print("catgory seleccted $category");
                                  }

                                  if (title.isEmpty) {
                                    Toast.show(context, "Please enter a title",
                                        "error");
                                    setModalState(() {
                                      loadingSubmission = false;
                                    });
                                    return;
                                  }

                                  if (description.isEmpty) {
                                    Toast.show(context,
                                        "Please enter a description", "error");
                                    setModalState(() {
                                      loadingSubmission = false;
                                    });
                                    return;
                                  }

                                  if (category.isEmpty) {
                                    Toast.show(context,
                                        "Please choose a category", "error");
                                    setModalState(() {
                                      loadingSubmission = false;
                                    });
                                    return;
                                  }
                                  List<String> uploadedUrls = [];
                                  for (File imgFile in localPhotosFiles) {
                                    print("Going to call upload IMAGE");
                                    String? uploadedImageUrl =
                                        await ImageUploadService.uploadImage(
                                            imgFile,
                                            directoryName: 'post_images');
                                    if (uploadedImageUrl != null) {
                                      print("GOT AN IMAGE");
                                      print("URL $uploadedImageUrl");
                                      uploadedUrls.add(uploadedImageUrl);
                                    }
                                  }
                                  setModalState(() {
                                    localPhotosUrls.addAll(uploadedUrls);
                                  });
                                  DateTime dateTime = DateTime.now();
                                  print("Submitting categoey $category");
                                  Post newPost = Post(
                                      title: title,
                                      userId: userId,
                                      resolved: false,
                                      anon: localAnon,
                                      category: category,
                                      description: description,
                                      photosUrls: localPhotosUrls,
                                      dateCreated: dateTime);
                                  try {
                                    await _postsService.addPost(
                                        collection, newPost);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    Toast.show(
                                        context, "Error Occurred", "error");
                                  }
                                  setModalState(() {
                                    loadingSubmission = false;
                                  });
                                },
                              ),
                            if (loadingSubmission)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    minimumSize:
                                        const Size(double.infinity, 36),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(action.split(" ")[0],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
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
          bool inFeed = indexToCollection[selectedTabIndex] == "feed";
          if (!isPublisher && inFeed) {
            Toast.show(context, "You need to be a publisher", "warning");
          } else {
            showBottomSheetForNewPost(context);
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            constraints: const BoxConstraints.expand(
              height: 56.0,
            ),
            alignment: Alignment.center,
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Confessions',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.fileCircleQuestion),
            label: 'Q/A',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.suitcase),
            label: 'Lost & Founds',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidBell),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
