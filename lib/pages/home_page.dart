import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weartherproject/cubits/weather/weather_cubit.dart';
import 'package:weartherproject/pages/search_page.dart';
import 'package:weartherproject/services/store.dart';
import 'package:weartherproject/widgets/error_dialog.dart';
import 'package:weartherproject/constants/constants.dart';
import 'package:weartherproject/cubits/temp_settings/temp_settings_cubit.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  String _email;

  HomePage(this._email);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String idUser = "12345";
  @override
  void initState() {
    _ispress = false;
  }

  bool _ispress = false;
  String? _city;
  FireStoreService _firestore = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thời tiết'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage())); //....

                print('city->$_city');

                // QuerySnapshot query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                // query.docs.first.id;
                if (_city != null) {
                  QuerySnapshot? query =  await _firestore.getData("LoveCity", "name", _city);
                  if(query?.docs.length != 0){
                    _ispress = true;
                  }
                  else{
                    _ispress = false;
                  }
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              },
              icon: const Icon(Icons.search)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage(); //...
                }),
              );
            },
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit; // ....

    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget showIcon(String icon) { //......
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png', //......
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                  onTap: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                    idUser = query.docs.first.id;
                    setState(() {
                    });
                  },
                  child: Text("Thành phố yêu thích", style: TextStyle(fontSize: 20),)
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    print(snapshot.data?.docs.length);
                    return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true, // Đảm bảo ListView không chiếm toàn bộ không gian
                                physics: NeverScrollableScrollPhysics(), // Ngăn cuộn ListView
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = snapshot.data?.docs[index];
                                  return GestureDetector(
                                    onTap: (){
                                      context.read<WeatherCubit>().fetchWeather(item?["name"]!);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(135, 206, 235, 0.5),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item?["name"], style: TextStyle(fontSize: 20),),
                                          ElevatedButton(
                                              onPressed: (){
                                                  String? id = item?.id;
                                                  FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").doc(id).delete();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa thành phố từ danh sách yêu thích")));
                                                },
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 30,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                    );
                  },
                ),
              )
            ],
          );
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                  onTap: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                    idUser = query.docs.first.id;
                    setState(() {
                    });
                  },
                  child: Text("Thành phố yêu thích", style: TextStyle(fontSize: 20),)
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    print(snapshot.data?.docs.length);
                    return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true, // Đảm bảo ListView không chiếm toàn bộ không gian
                                physics: NeverScrollableScrollPhysics(), // Ngăn cuộn ListView
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = snapshot.data?.docs[index];
                                  return GestureDetector(
                                    onTap: (){
                                      context.read<WeatherCubit>().fetchWeather(item?["name"]!);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(135, 206, 235, 0.5),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(item?["name"], style: TextStyle(fontSize: 20),),
                                          ElevatedButton(
                                              onPressed: (){
                                                  String? id = item?.id;
                                                  FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").doc(id).delete();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa thành phố từ danh sách yêu thích")));
                                                },
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 30,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                    );
                  },
                ),
              )
            ],
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(135, 206, 235, 0.5),
                  borderRadius: BorderRadius.circular(25)),
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              setState(() {
                                _ispress = true;
                              });
                              QuerySnapshot? query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                              if(query.docs.isNotEmpty){
                                String idUser = query.docs.first.id;
                                QuerySnapshot? queryLoveCity = await FirebaseFirestore.instance.collection("User").doc(idUser).collection("LoveCity").where("name", isEqualTo: state.weather.name).get();
                                if(queryLoveCity.docs.isEmpty){
                                  await FirebaseFirestore.instance.collection("User").doc(idUser).collection("LoveCity").add({"name" : state.weather.name});
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm vào danh sách thành phố yêu thích")));
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thành phố đã có trong danh sách yêu thích")));
                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi user")));
                              }
                            },
                            onDoubleTap: () async{
                              setState(() {
                                _ispress = false;
                              });
                              QuerySnapshot? query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                              if(query.docs.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Không có user với email: ${widget._email}")));
                              }
                              else{
                                String? idUser = query.docs.first.id;
                                QuerySnapshot? queryLoveCity = await FirebaseFirestore.instance.collection("User").doc(idUser).collection("LoveCity").where("name", isEqualTo : state.weather.name).get();
                                if(queryLoveCity.docs.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thành phố không có trong danh sách yêu thích")));
                                }
                                else{
                                  String idLoveCity = queryLoveCity.docs.first.id;
                                  await FirebaseFirestore.instance.collection("User").doc(idUser).collection("LoveCity").doc(idLoveCity).delete();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa tên thành phố")));
                                }
                              }
                            },
                            child: Icon(
                              Icons.favorite,
                              color: _ispress? Colors.red : Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      state.weather.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          TimeOfDay.fromDateTime(state.weather.lastUpdated)
                              .format(context),
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          '(${state.weather.country})',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          showTemperature(state.weather.temp),
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text(
                              showTemperature(state.weather.tempMax),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              showTemperature(state.weather.tempMin),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        showIcon(state.weather.icon),
                        Expanded(
                          flex: 3,
                          child: formatText(state.weather.description),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () async {
                  QuerySnapshot query = await FirebaseFirestore.instance.collection("User").where("email", isEqualTo: widget._email).get();
                  idUser = query.docs.first.id;
                  setState(() {
                  });
                },
                child: Text("Thành phố yêu thích", style: TextStyle(fontSize: 20),)
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  print(snapshot.data?.docs.length);
                  return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true, // Đảm bảo ListView không chiếm toàn bộ không gian
                              physics: NeverScrollableScrollPhysics(), // Ngăn cuộn ListView
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = snapshot.data?.docs[index];
                                return GestureDetector(
                                  onTap: (){
                                    context.read<WeatherCubit>().fetchWeather(item?["name"]!);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(135, 206, 235, 0.5),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item?["name"], style: TextStyle(fontSize: 20),),
                                        ElevatedButton(
                                            onPressed: (){
                                              String? id = item?.id;
                                              FirebaseFirestore.instance.collection('User').doc(idUser).collection("LoveCity").doc(id).delete();
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa thành phố từ danh sách yêu thích")));
                                            },
                                            child: Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                              size: 30,
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
