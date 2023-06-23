import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/ruleItem_data.dart';

class RuleItemWidget extends StatefulWidget {
  const RuleItemWidget({Key? key}) : super(key: key);

  @override
  State<RuleItemWidget> createState() => _RuleItemWidgetState();
}

class _RuleItemWidgetState extends State<RuleItemWidget> {
  final List<RuleItem> _data = generateItems(8);
  // final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  bool light = false;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildPanel(),
        _buildPanelUsingExpansionTileCard(),
      ],
    );
  }

  Widget _buildPanelUsingExpansionTileCard() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: menuBar,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _data.map<ExpansionTileCard>(
            (RuleItem ruleItem) {
              return ExpansionTileCard(
                key: ruleItem.key,
                borderRadius: BorderRadius.circular(20),
                baseColor: backgroundColor,
                expandedColor: backgroundColor,
                expandedTextColor: primaryAncient,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ruleItem.headerValue,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Switch(
                        value: ruleItem.isApplied,
                        activeColor: primaryAncient,
                        activeTrackColor: primaryLight60,
                        inactiveTrackColor: Colors.grey,
                        onChanged: (bool value) {
                          //TODO: apply rule
                          setState(() {
                            ruleItem.isApplied = value;
                          });
                        })
                  ],
                ),
                subtitle: Text(ruleItem.expandedValue),
                children: [
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                    color: primaryAncient,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        """condition: position 4m inside
alarm type: sms""",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    buttonHeight: 42.0,
                    buttonMinWidth: 70.0,
                    children: <Widget>[
                      TextButton(
                        style: flatButtonStyle,
                        onPressed: () {}, //TODO: 수정 Page 호출
                        child: const Column(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              color: primaryAncient,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              '수정하기',
                              style: TextStyle(color: primaryAncient),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: flatButtonStyle,
                        onPressed: () {
                          _showAlertDialog(ruleItem);

                          //TODO: 삭제 api 전송
                          //TODO: pref 에 값 저장
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.playlist_remove,
                              color: primaryAncient,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              '삭제하기',
                              style: TextStyle(color: primaryAncient),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ).toList()[index];
        },
        itemCount: _data.length,
      ),
    );
  }

  Future<void> _showAlertDialog(RuleItem ruleItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rule 삭제'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('선택하신 Rule을 정말 삭제 하시겠습니까?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _data.removeWhere(
                      (RuleItem currentItem) => ruleItem == currentItem);
                });
                Navigator.of(context).pop();
              },
              child: Text('네', style: TextStyle(color: primaryAncient)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('아니오', style: TextStyle(color: primaryAncient)),
            ),
          ],
        );
      },
    );
  }
}

/*
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((RuleItem ruleItem) {
        return ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: backgroundColor,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(ruleItem.headerValue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            );
          },
          body: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              selectedColor: primaryAncient,
              title: Text(ruleItem.expandedValue),
              subtitle: const Text(
                  'To delete this panel, tap the trash can icon'), //TODO: change to rule content
              trailing: Icon(Icons.delete_rounded),
              iconColor: primaryAncient,
              onTap: () {
                setState(() {
                  _data.removeWhere(
                      (RuleItem currentItem) => ruleItem == currentItem);
                });
              }),
          isExpanded: ruleItem.isExpanded,
        );
      }).toList(),
    );
  }

 */

List<RuleItem> generateItems(int numberOfItems) {
  return List<RuleItem>.generate(numberOfItems, (int index) {
    return RuleItem(
      headerValue: 'Rule $index',
      expandedValue: 'This is Rule number $index',
      isExpanded: false,
      isApplied: false,
      key: GlobalKey(),
    );
  });
}
