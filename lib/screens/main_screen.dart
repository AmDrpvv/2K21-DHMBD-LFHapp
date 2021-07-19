import 'package:flutter/material.dart';
import 'package:lfh_app/screens/Display.dart';
import 'package:lfh_app/screens/home.dart';
import 'package:lfh_app/screens/settingsScreen.dart';
import 'package:lfh_app/widgets/Drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          Icon(Icons.search),
          SizedBox(width: 5.0),
          IconButton(
            icon : Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DisplayScreen(isCart: true, isCorousel: false);
              },
            ), 
          ),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      drawer: Drawer(child: DrawerWidget(),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)
            ),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Laxmi\nFurniture House',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: onPageChanged,
            children:[
              Home(),
              Container(
                child: Center(
                  child: Text(
                    'No Account Created',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SettingsScreen()
            ]
          ),
          ),
        ], 
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'home'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance,
              ),
              label: 'account'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'settings'
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  // List<String> items = ['Center Table', 'Double Bed', 'Dinning Table', 'Dressing Table',
  // 'LED Panel', 'Single Bed', 'Sofa', 'Sofa Cum Bed', 'Temple'];
  // Map map = {
  //   'Center Table': 2,
  //   'Double Bed': 4,
  //   'Dinning Table': 2,
  //   'Dressing Table': 1,
  //   'LED Panel': 1,
  //   'Single Bed': 1,
  //   'Sofa': 5,
  //   'Sofa Cum Bed': 2,
  //   'Temple': 1,
  // };

  // initializeDatabase() async{
  //   isLoading = true;

  //   for(int j=1; j<=items.length; j++){
  //   // FurnitureImages f = FurnitureItem(name: '${items[j-1]}');
  //   String fid = await DatabaseService().createFurnitureID();
  //   for(int i=1; i<=map[items[j-1]]; i++)
  //   {
  //     String urlLocal = await getImageFileFromAssets('assets/$j/p ($i).jpg', '${items[j-1]}_0$i');
      
  //     String iID = await DatabaseService().createImageID();

  //     String url = await FireStorage().uploadFile(iID, File(urlLocal));
  //     ImageItem img = ImageItem(
  //       furnitureID: fid,
  //       id: iID,
  //       url: url,
  //       name: '${items[j-1]}_0$i'
  //     );

  //     await DatabaseService().createImageItem(img);

  //     if(i==1){
  //       await DatabaseService().createFurnitureItem(FurnitureItem(
  //         name: '${items[j-1]}',
  //         id: fid,
  //         url: url
  //       ));
  //     }
  //   }
  //   }
  //   await Future.delayed(Duration(seconds: 1));
  //   setState(() { isLoading = false; });
  // }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
