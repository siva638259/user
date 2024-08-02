import 'package:flutter/material.dart';

void main() {
  runApp(TodayOrdersPage());
}

class TodayOrdersPage extends StatefulWidget {
  @override
  _TodayOrdersPageState createState() => _TodayOrdersPageState();
}

class _TodayOrdersPageState extends State<TodayOrdersPage> {
  List<MilkItem> milkItemsToday = [
    MilkItem("Heritage Milk", 2, 50, false),
    MilkItem("Cavin's Milk", 1, 22, false),
    MilkItem("Amul Milk Red", 2, 40, false),
    MilkItem("Amul Milk Blue", 5, 120, false),
    MilkItem("Amul Milk Yellow", 3, 75, false),
    MilkItem("Arokia Milk", 4, 92, false),
  ];

  List<MilkItem> milkItemsTomorrow = [];

  int selectedPageIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  int getTotalPrice(List<MilkItem> items) {
    return items
        .where((item) => item.isSelected)
        .fold(0, (total, item) => total + (item.price * item.quantity));
  }

  void toggleSelection(MilkItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      selectedPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void clearAll() {
    setState(() {
      if (selectedPageIndex == 0) {
        milkItemsToday.forEach((item) => item.isSelected = false);
      } else {
        milkItemsTomorrow.forEach((item) => item.isSelected = false);
      }
    });
  }

  void confirmOrder() {
    // Handle order confirmation
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'ஆர்டர் பட்டியல்',
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton.icon(
              icon: Icon(Icons.list_alt_rounded, color: Colors.red),
              label: Text(
                'நிலுவை ஆர்டர்கள்',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              onPressed: () {
                // Navigate to pending orders page
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
          backgroundColor: Colors.deepPurple,
        ),
        backgroundColor: Colors.deepPurple,
        body: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => onTabTapped(0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: selectedPageIndex == 0
                                    ? Colors.deepPurple
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: selectedPageIndex == 0
                                  ? Colors.deepPurple
                                  : Colors.white,
                            ),
                            child: Text(
                              'இன்றைய ஆர்டர்கள்',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectedPageIndex == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => onTabTapped(1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: selectedPageIndex == 1
                                    ? Colors.deepPurple
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: selectedPageIndex == 1
                                  ? Colors.deepPurple
                                  : Colors.white,
                            ),
                            child: Text(
                              'நாளைய ஆர்டர்கள்',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selectedPageIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedPageIndex = index;
                    });
                  },
                  children: [
                    OrdersList(
                      milkItems: milkItemsToday,
                      toggleSelection: toggleSelection,
                    ),
                    milkItemsTomorrow.isNotEmpty
                        ? OrdersList(
                            milkItems: milkItemsTomorrow,
                            toggleSelection: toggleSelection,
                          )
                        : Center(
                            child: Text(
                              'No items',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '₹${getTotalPrice(selectedPageIndex == 0 ? milkItemsToday : milkItemsTomorrow)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // This is needed to trigger the button's onPressed action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 12), // Adjust as needed
                      ),
                      child: GestureDetector(
                        onTapDown: (details) {
                          final buttonWidth = context.size?.width ?? 0;
                          final clickPosition = details.localPosition.dx;

                          if (clickPosition < buttonWidth / 2) {
                            clearAll();
                          } else {
                            confirmOrder();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: (){},
                                  child: Text(
                                    'அனைத்தையும் அழி',
                                    style: TextStyle(color: Colors.white, fontSize: 13), // Adjust fontSize as needed
                                  ),
                                ),
                              ),
                            ),
                            
                             VerticalDivider(
                                color: const Color.fromARGB(255, 159, 145, 145), // Color of the vertical line
                                thickness: 1, // Thickness of the vertical line
                                width: 20, // Space around the vertical line
                              ),
                            
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Text(
                                    'ஆர்டர் உறுதி',
                                    style: TextStyle(color: Colors.white, fontSize: 13), // Adjust fontSize as needed
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<MilkItem> milkItems;
  final Function(MilkItem) toggleSelection;

  OrdersList({required this.milkItems, required this.toggleSelection});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: milkItems.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final data = milkItems[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Implement delete functionality if needed
                },
              ),
              Expanded(
                flex: 2,
                child: Text(data.name),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('${data.quantity}'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Checkbox(
                  value: data.isSelected,
                  onChanged: (value) {
                    toggleSelection(data);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('₹${data.price}'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MilkItem {
  final String name;
  final int quantity;
  final int price;
  bool isSelected;

  MilkItem(this.name, this.quantity, this.price, this.isSelected);
}
