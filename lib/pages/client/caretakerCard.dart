import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:take_ama/models/UserLogin.dart';
import 'package:take_ama/services/UserAPI.dart';

class CaretakerCardPage extends StatefulWidget {
  const CaretakerCardPage({Key? key}) : super(key: key);

  @override
  State<CaretakerCardPage> createState() => _CaretakerCardPageState();
}

class _CaretakerCardPageState extends State<CaretakerCardPage> {
  var images = [
    'https://scontent.fbkk29-9.fna.fbcdn.net/v/t1.6435-9/153134206_718434138863324_6138093492518143326_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Do9Hq7UMzJkAX8dugcG&_nc_ht=scontent.fbkk29-9.fna&oh=00_AfAXQGGkhv1c7kQkLXem5aA0SutPS_eDrSrb41e0U8e-8Q&oe=63C205B6',
    'https://scontent.fbkk29-4.fna.fbcdn.net/v/t39.30808-6/271947473_1311517202651052_6706692290469937660_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=YE-u0SKaG5EAX814AhD&tn=zLz2pwmmeXEx9FcM&_nc_ht=scontent.fbkk29-4.fna&oh=00_AfA-r5Aq8WO5mZxuZKqUgBBoPmZ2nSTjtfxEUQlr0tjCsQ&oe=639ECFF0',
    'https://scontent.fbkk29-7.fna.fbcdn.net/v/t1.6435-9/66489643_144932883247841_8950234661112512512_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=174925&_nc_ohc=j8ERX9kaTVMAX_kQYB6&tn=zLz2pwmmeXEx9FcM&_nc_ht=scontent.fbkk29-7.fna&oh=00_AfCdh1skrH9e046rhpklkKuLKpB7dEX3NGPgbXZVDRzwlw&oe=63C1FBA3',
    'https://scontent.fbkk29-4.fna.fbcdn.net/v/t39.30808-6/317865491_2224435954394002_9101560691648456242_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=rjtomwBeGKwAX9cIpzp&_nc_ht=scontent.fbkk29-4.fna&oh=00_AfBRtINjYHH6ESBZGUmLE0HLX7Sa3NJMaz42embJgx-l9w&oe=639FFA6C',
    'https://scontent.fbkk29-8.fna.fbcdn.net/v/t39.30808-6/230034618_1192225044579112_111848914769401005_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=174925&_nc_ohc=jIEmInsm2L0AX_Fj1A8&_nc_ht=scontent.fbkk29-8.fna&oh=00_AfCdwvMADA7qS5lojYeKmjYisHOH7NmjcTM1QmtY_aXS3Q&oe=639F0E6E',
    'https://scontent.fbkk29-6.fna.fbcdn.net/v/t39.30808-6/315281607_112007745056780_1400439495516577262_n.jpg?stp=cp6_dst-jpg&_nc_cat=109&ccb=1-7&_nc_sid=174925&_nc_ohc=_4HK-Wcuj58AX8Z0Mdj&tn=zLz2pwmmeXEx9FcM&_nc_ht=scontent.fbkk29-6.fna&oh=00_AfCnhAhPp0_P9uC7KoMn_RSk6_wsfSaW6BcJd9SqsRf7BA&oe=639F6DBA',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7vAgLQ-YG784iOrvDMDtO-Spf37R7gN09hixLwEmKwmyiduiH5a2INoHI6sWTflRpEv0&usqp=CAU',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: UserAPI.getAll(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Profile?>> snapshot) {
            if (snapshot.hasData) {
              List<Profile?> caretakers = snapshot.data!;
              caretakers = caretakers.where((e) => e!.userType == "2").toList();
              var images = generateImg(caretakers.length);
              return Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  Profile caretaker = caretakers[index]!;
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.network(
                            // caretaker.imgUrl,
                            images[index],
                            //'https://i.pinimg.com/originals/af/9f/1f/af9f1fed99621ae20f9edd2ab6cbb8bd.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${caretaker.firstName} ${caretaker.lastName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                '${DateTime.now().year - int.parse(caretaker.birthDay!)} Year',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _selectCareTaker(caretaker);
                                },
                                child: const Text("Select"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: caretakers.length,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  _selectCareTaker(Profile profile) {
    Navigator.pushNamed(context, "/caretakerDetail", arguments: profile);
  }

  List<String> generateImg(int length) {
    List<String> imgs = [];
    int v = 0;
    for (int i = 0; i < length; i++) {
      imgs.add(images[v]);
      if (i == images.length - 1) v = 0;
      v++;
    }
    return imgs;
  }
}
