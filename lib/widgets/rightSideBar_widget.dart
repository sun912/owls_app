import 'package:flutter/material.dart';

class RightSideBarWidget extends StatelessWidget {
  const RightSideBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1400;

    return Column(
      children: [
        ColoredBox(
          color: const Color(0xFFCCECDF).withOpacity(0.5),
          child: Expanded(
            child: Container(
              width: _showDesktop ? 400 : 0,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: const Center(
                          child: Text(
                        'Rull 목록',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Rull 생성',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: _showDesktop ? 400 : 0,
          child: Text(
            'list',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
        )
      ],
    );
  }
}
