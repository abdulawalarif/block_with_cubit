import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

const names = [
  'Foo',
  'Bar',
  'Baz',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(
        names.getRandomElement(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: cubit.stream,
            builder: (context, snapshot) {
              final button = ElevatedButton(
                onPressed: () => cubit.pickRandomName(),
                child: const Text(
                  'Pick a Random Name',
                ),
              );

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return button;
                case ConnectionState.waiting:
                  return button;
                case ConnectionState.active:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data.toString(),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      button,
                    ],
                  );
                case ConnectionState.done:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
